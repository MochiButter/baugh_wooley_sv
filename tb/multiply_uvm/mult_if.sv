interface mult_if #(parameter p_width = 4) ();
  logic [p_width - 1:0] a_i;
  logic [p_width - 1:0] b_i;
  logic [0:0] a_signed_i;
  logic [0:0] b_signed_i;
  logic [(2 * p_width) - 1:0] product_o;
endinterface
