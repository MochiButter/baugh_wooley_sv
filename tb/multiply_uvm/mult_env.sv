`include "mult_agent.sv"
`include "mult_scoreboard.sv"

class mult_env extends uvm_env;
  mult_agent      mult_agnt;
  mult_scoreboard mult_scb;

  `uvm_component_utils(mult_env)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);

    mult_agnt = mult_agent::type_id::create("mult_agnt", this);
    mult_scb  = mult_scoreboard::type_id::create("mult_scb", this);
  endfunction

  function void connect_phase (uvm_phase phase);
    mult_agnt.monitor.item_collected_port.connect(mult_scb.item_collected_export);
  endfunction
endclass
