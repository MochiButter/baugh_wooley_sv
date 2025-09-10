class mult_sequence extends uvm_sequence#(mult_seq_item);
  `uvm_object_utils(mult_sequence)

  function new (string name="mult_sequence");
    super.new(name);
  endfunction

  virtual task body();
    repeat(15) begin
      req = mult_seq_item::type_id::create("req");
      wait_for_grant();
      req.randomize();
      send_request(req);
      wait_for_item_done();
    end
  endtask
endclass
