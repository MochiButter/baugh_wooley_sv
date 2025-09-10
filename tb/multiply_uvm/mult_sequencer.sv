`ifdef VERILATOR
class mult_sequencer extends uvm_sequencer #(mult_seq_item, mult_seq_item);
`else
class mult_sequencer extends uvm_sequencer #(mult_seq_item);
`endif
  `uvm_component_utils(mult_sequencer)

  function new (string name, uvm_component parent);
    super.new(name,parent);
  endfunction
endclass
