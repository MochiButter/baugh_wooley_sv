module multiply 
  #(parameter p_width = 4)
  (input [p_width - 1:0] a_i
  ,input [p_width - 1:0] b_i
  ,input [0:0] a_signed_i
  ,input [0:0] b_signed_i
  ,output [(2 * p_width) - 1:0] product_o);

  wire signed [p_width:0] a_extend_l, b_extend_l;
  assign a_extend_l = {(a_signed_i ? a_i[p_width - 1] : 1'b0), a_i};
  assign b_extend_l = {(b_signed_i ? b_i[p_width - 1] : 1'b0), b_i};

  wire [1:0] _unused_;
  baugh_wooley #(.p_width(p_width + 1)) bw_inst(
    .a_i(a_extend_l),
    .b_i(b_extend_l),
    .product_o({_unused_, product_o})
  );
endmodule
