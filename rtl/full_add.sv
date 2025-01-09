module full_add
  (input [0:0] a_i
  ,input [0:0] b_i
  ,input [0:0] c_i
  ,output [0:0] s_o
  ,output [0:0] c_o);

  wire [0:0] sum_w;
  wire [1:0] carry_w;
  half_add #() ha_first_inst (
    .a_i(a_i),
    .b_i(b_i),
    .s_o(sum_w),
    .c_o(carry_w[0])
  );

  half_add #() ha_second_inst (
    .a_i(sum_w),
    .b_i(c_i),
    .s_o(s_o),
    .c_o(carry_w[1])
  );

  assign c_o = |carry_w;
endmodule
