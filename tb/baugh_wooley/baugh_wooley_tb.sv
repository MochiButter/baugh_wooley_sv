`timescale 1ns/1ps
module baugh_wooley_tb();

  localparam lp_width = 8;
  logic signed [lp_width - 1:0] a_i, b_i;
  logic signed [(2 * lp_width) - 1:0] p_o;

`ifdef GLS
  baugh_wooley #() bw_inst(
`else
  baugh_wooley #(.p_width(lp_width)) bw_inst(
`endif
    .a_i(a_i),
    .b_i(b_i),
    .product_o(p_o)
  );

  initial begin
`ifdef VERILATOR
  $dumpfile("verilator.vcd");
`else
  $dumpfile("iverilog.vcd");
`endif
  $dumpvars;

    for(int itervar_a = 0; itervar_a < (1 << lp_width); itervar_a ++) begin
      a_i = itervar_a[lp_width - 1:0];
      for(int itervar_b = 0; itervar_b < (1 << lp_width); itervar_b ++) begin
        b_i = itervar_b[lp_width - 1:0];
        #10;
        //$display("a_i: %d, b_i %d, p_o: %d", a_i, b_i, p_o);
        if(p_o != (a_i * b_i)) begin
          $display("Bad output at a_i: %d b_i: %d = %d", a_i, b_i, p_o);
          $display("SIM FAILED");
          $finish();
        end
      end
    end

    $display("No bad outputs detected");
    $display("SIM PASSED");
    $finish();
  end
endmodule
