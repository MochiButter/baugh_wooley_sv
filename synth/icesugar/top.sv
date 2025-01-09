module top
  (input [3:0] a_i
  ,input [3:0] b_i
  ,output [7:0] p_o); 

  multiply #(.p_width(4)) mult_inst(
    .a_i(a_i),
    .b_i(b_i),
    .a_signed_i(1'b1),
    .b_signed_i(1'b1),
    .product_o(p_o)
  );
endmodule 
