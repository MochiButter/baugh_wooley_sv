class mult_scoreboard extends uvm_scoreboard;
  mult_seq_item pkt_qu[$];

  uvm_analysis_imp #(mult_seq_item, mult_scoreboard) item_collected_export;
  `uvm_component_utils(mult_scoreboard)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
      item_collected_export = new("item_collected_export", this);
  endfunction

  virtual function void write(mult_seq_item pkt);
    pkt.print();
    pkt_qu.push_back(pkt);
  endfunction

  logic signed [4:0] a, b;
  logic signed [9:0] p;

  virtual task run_phase(uvm_phase phase);
    mult_seq_item mult_pkt;

    forever begin
      wait(pkt_qu.size() > 0);
      mult_pkt = pkt_qu.pop_front();

      a = {(mult_pkt.a_signed & mult_pkt.a[3]) , mult_pkt.a};
      b = {(mult_pkt.b_signed & mult_pkt.b[3]) , mult_pkt.b};
      p = a * b;
      if (mult_pkt.product == p[7:0]) begin
        `uvm_info(get_type_name(), $sformatf("%d * %d = %d : \033[0;32mOK\033[0m", a, b, p), UVM_LOW)
      end else begin
        `uvm_error(get_type_name(), $sformatf("%d * %d = %d : \033[0;31mFAIL\033[0m", a, b, p))
      end
    end
  endtask
endclass
