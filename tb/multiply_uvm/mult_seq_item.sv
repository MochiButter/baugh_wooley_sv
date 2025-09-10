class mult_seq_item extends uvm_sequence_item;
  rand bit [3:0] a;
  rand bit [3:0] b;
  rand bit [0:0] a_signed;
  rand bit [0:0] b_signed;
  bit signed [7:0] product;

  `uvm_object_utils_begin(mult_seq_item)
    `uvm_field_int(a, UVM_ALL_ON)
    `uvm_field_int(b, UVM_ALL_ON)
    `uvm_field_int(a_signed, UVM_ALL_ON)
    `uvm_field_int(b_signed, UVM_ALL_ON)
    `uvm_field_int(product, UVM_ALL_ON)
  `uvm_object_utils_end

  function new (string name="mult_seq_item");
    super.new(name);
  endfunction
endclass
