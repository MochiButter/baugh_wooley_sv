`timescale 1ns/1ps
module top
  (input signed [3:0] a_i
  ,input signed [3:0] b_i
  ,input [0:0] a_signed_i
  ,input [0:0] b_signed_i
  ,output signed [7:0] p_o); 

  multiply #(.p_width(4)) mult_inst(
    .a_i(a_i),
    .b_i(b_i),
    .a_signed_i(a_signed_i),
    .b_signed_i(b_signed_i),
    .product_o(p_o)
  );
endmodule 
