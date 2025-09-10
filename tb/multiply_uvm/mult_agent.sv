`include "mult_seq_item.sv"
`include "mult_sequencer.sv"
`include "mult_sequence.sv"
`include "mult_driver.sv"
`include "mult_monitor.sv"

class mult_agent extends uvm_agent;
  mult_driver    driver;
  mult_sequencer sequencer;
  mult_monitor   monitor;

  `uvm_component_utils(mult_agent)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);

    monitor = mult_monitor::type_id::create("monitor", this);

    if(get_is_active() == UVM_ACTIVE) begin
      driver    = mult_driver::type_id::create("driver", this);
      sequencer = mult_sequencer::type_id::create("sequencer", this);
    end
  endfunction

  function void connect_phase (uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction
endclass
