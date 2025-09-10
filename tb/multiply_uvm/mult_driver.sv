class mult_driver extends uvm_driver #(mult_seq_item);
  virtual mult_if vif;
  `uvm_component_utils(mult_driver)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual mult_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NO_VIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
    end
  endfunction

  virtual task run_phase (uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask

  virtual task drive();
    vif.a_i <= req.a;
    vif.b_i <= req.b;
    vif.a_signed_i <= req.a_signed;
    vif.b_signed_i <= req.b_signed;
    #20;
  endtask
endclass
