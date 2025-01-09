YOSYS_DATDIR := $(shell yosys-config --datdir)

.PHONY: bitstream include sim lint gls program clean

include synth/icesugar/fpga.mk
SIM_MK ?= def
-include tb/$(SIM_MK)/$(SIM_MK).mk
SIM_TOP := $(strip $(SIM_TOP))
RTL_TOP := $(strip $(RTL_TOP))

bitstream: build/synth/ice40.bin

include:
ifeq ($(SIM_MK),def)
	@echo "Give make the module you want to test: make sim SIM_MK=multiply" 
	@exit 1
endif
ifeq ("$(wildcard tb/$(SIM_MK)/$(SIM_MK).mk)", "")
	@echo "SIM_MK must point to a .mk file that exists."
	@exit 1
endif

sim: include build/sim/$(SIM_TOP)/verilator.vcd build/sim/$(SIM_TOP)/iverilog.vcd

build/sim/$(SIM_TOP)/verilator.vcd: $(SIM_TB) $(SIM_SRC)
	mkdir -p build/sim/$(SIM_TOP)
	verilator lint/verilator.vlt -Mdir build/sim/$(SIM_TOP)/verilator $^ --trace --binary --top $(SIM_TOP)
	cd build/sim/$(SIM_TOP); \
	verilator/V$(SIM_TOP) +verilator+rand+reset+2

build/sim/$(SIM_TOP)/iverilog.vcd: $(SIM_TB) $(SIM_SRC)
	mkdir -p build/sim/$(SIM_TOP)/iverilog
	iverilog -o build/sim/$(SIM_TOP)/iverilog/tb $^ -g2005-sv
	cd build/sim/$(SIM_TOP); \
	vvp iverilog/tb -fst

lint: $(RTL_SRC)
	verilator lint/verilator.vlt --lint-only -top $(RTL_TOP) $^ -Wall

build/synth/rtl.sv2v.v: $(RTL_SRC)
	@mkdir -p build/synth
	sv2v $^ -w $@

build/synth/sim.sv2v.v: include $(SIM_SRC)
	@mkdir -p build/synth
	sv2v $(SIM_SRC) -w $@

build/synth/synth.v: build/synth/sim.sv2v.v synth/yosys_generic/yosys.tcl
	@mkdir -p build/synth
	yosys -p 'tcl synth/yosys_generic/yosys.tcl' -ql build/synth/synth_v.yslog

gls: include build/sim/$(SIM_TOP)_gls/verilator.vcd build/sim/$(SIM_TOP)_gls/iverilog.vcd

build/sim/$(SIM_TOP)_gls/verilator.vcd: $(SIM_TB) build/synth/synth.v $(YOSYS_DATDIR)/simlib.v
	@mkdir -p build/sim/$(SIM_TOP)_gls
	verilator lint/verilator.vlt -Mdir build/sim/$(SIM_TOP)_gls/verilator -DGLS $^ --trace --binary --top $(SIM_TOP) 
	cd build/sim/$(SIM_TOP)_gls; \
	verilator/V$(SIM_TOP) +verilator+rand+reset+2

build/sim/$(SIM_TOP)_gls/iverilog.vcd: $(SIM_TB) build/synth/synth.v $(YOSYS_DATDIR)/simlib.v
	@mkdir -p build/sim/$(SIM_TOP)_gls/iverilog
	iverilog -o build/sim/$(SIM_TOP)_gls/iverilog/tb -DGLS $^ -g2005-sv
	cd build/sim/$(SIM_TOP)_gls; \
	vvp iverilog/tb -fst

build/synth/ice40.json: build/synth/rtl.sv2v.v
	@mkdir -p build/synth
	yosys -ql build/synth/ice40.yslog -p 'ice40_opt' -p 'synth_ice40 -top $(RTL_TOP) -dsp -json build/synth/ice40.json' $^ 

build/synth/ice40.asc: build/synth/ice40.json synth/icesugar/icesugar.pcf
	nextpnr-ice40 --up5k --package sg48 --json build/synth/ice40.json --pcf synth/icesugar/icesugar.pcf --asc build/synth/ice40.asc

build/synth/ice40.bin: build/synth/ice40.asc
	icepack $< $@

build/synth/ice40.rpt: build/synth/ice40.asc
	icetime -d up5k -c 12 -mtr $@ $<

program: build/synth/ice40.bin
	icesprog $<

clean:
	rm -rf build
