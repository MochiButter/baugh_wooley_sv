`timescale 1ns/1ps
module icesugar_gls();

  localparam lp_width = 4;
  logic [lp_width - 1:0] a_i, b_i;
  logic [0:0] a_signed_i, b_signed_i;
  logic [(2 * lp_width) - 1:0] p_o;

  top #() t_inst(
    .a_i(a_i),
    .b_i(b_i),
    .a_signed_i(a_signed_i),
    .b_signed_i(b_signed_i),
    .p_o(p_o)
  );

  logic signed [lp_width:0] a, b;
  logic [(2 * lp_width) - 1:0] p;

  initial begin
`ifdef VERILATOR
  $dumpfile("verilator.vcd");
`else
  $dumpfile("iverilog.vcd");
`endif
  $dumpvars;

    for(int itervar_sign = 0; itervar_sign < 4; itervar_sign ++) begin
      a_signed_i = itervar_sign[0];
      b_signed_i = itervar_sign[1];
      for(int itervar_a = 0; itervar_a < (1 << lp_width); itervar_a ++) begin
        a_i = itervar_a[lp_width - 1:0];
        for(int itervar_b = 0; itervar_b < (1 << lp_width); itervar_b ++) begin
          b_i = itervar_b[lp_width - 1:0];
          #10;
          
          // sign extend
          // Verilog's own doesn't work the way I expected it to, so all
          // numbers are to be signed, if input is unsigned then add an extra
          // zero in front.
          // If it is signed and is positive, then add a zero too.
          // Signed negative inputs gets a one in front.
          // The product will be two bits longer, so get rid of that in the
          // comparison.
          a = {(a_signed_i & a_i[lp_width - 1]) , a_i};
          b = {(b_signed_i & b_i[lp_width - 1]) , b_i};
          p = a * b;
          if(p[(2 * lp_width) - 1:0] != p_o) begin
            $display("Bad output");
            $display("%b != %b", p[(2 * lp_width) - 1:0], p_o);
            $display("a_i: %b b_i: %b p_o: %b", a_i, b_i, p_o);
            $display("\033[0;31mSIM FAILED\033[0m");
            $finish();
          end
        end
      end
    end

    $display("No bad outputs detected");
    $display("\033[0;32mSIM PASSED\033[0m");
    $finish();
  end
endmodule
