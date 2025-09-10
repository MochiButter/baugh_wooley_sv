`include "mult_env.sv"

class mult_test extends uvm_test;
  `uvm_component_utils(mult_test)

  mult_env env;
  mult_sequence seq;

  function new (string name = "mult_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);

    env = mult_env::type_id::create("env", this);
    seq = mult_sequence::type_id::create("seq");
  endfunction

  virtual function void end_of_elaboration ();
    print();
  endfunction

  task run_phase (uvm_phase phase);
    phase.raise_objection(this);
    seq.start(env.mult_agnt.sequencer);
    phase.drop_objection(this);
  endtask

  function void report_phase (uvm_phase phase);
    uvm_report_server svr;
    super.report_phase(phase);

    svr = uvm_report_server::get_server();
    if(svr.get_severity_count(UVM_FATAL) + svr.get_severity_count(UVM_ERROR) > 0) begin
      `uvm_info(get_type_name(), "\033[0;31mSIM FAILED\033[0m", UVM_NONE)
    end else begin
      `uvm_info(get_type_name(), "\033[0;32mSIM PASSED\033[0m", UVM_NONE)
    end
  endfunction
endclass
