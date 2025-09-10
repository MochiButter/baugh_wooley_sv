class mult_monitor extends uvm_monitor;
  virtual mult_if vif;
  uvm_analysis_port #(mult_seq_item) item_collected_port;

  mult_seq_item trans_collected;

  `uvm_component_utils(mult_monitor)

  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected = new();
    item_collected_port = new("item_collected_port", this);
  endfunction

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(virtual mult_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NO_VIF", {"virtual interface must be set for: ", get_full_name(), ".vif"});
    end
  endfunction

  virtual task run_phase (uvm_phase phase);
    forever begin
      #10;
      trans_collected.a = vif.a_i;
      trans_collected.b = vif.b_i;
      trans_collected.a_signed = vif.a_signed_i;
      trans_collected.b_signed = vif.b_signed_i;
      trans_collected.product = vif.product_o;
      item_collected_port.write(trans_collected);
      #10;
    end
  endtask
endclass
