`timescale 1ns/1ps
module half_add
  (input [0:0] a_i
  ,input [0:0] b_i
  ,output [0:0] s_o
  ,output [0:0] c_o);

  assign s_o = a_i ^ b_i;
  assign c_o = a_i & b_i;
endmodule
