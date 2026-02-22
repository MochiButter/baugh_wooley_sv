`timescale 1ns/1ps
module top
  (input [3:0] sw_ni
  ,input [3:0] btn_ni
  ,output [7:0] led_no); 

  wire [3:0] sw_inv = ~sw_ni;
  wire [3:0] btn_inv = ~btn_ni;
  wire [7:0] led_prod;
  multiply #(.p_width(4)) mult_inst(
    .a_i(sw_inv),
    .b_i(btn_inv),
    .a_signed_i(1'b1),
    .b_signed_i(1'b1),
    .product_o(led_prod)
  );
  assign led_no = ~led_prod;
endmodule 
