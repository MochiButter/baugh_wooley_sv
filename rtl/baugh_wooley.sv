module baugh_wooley
  #(parameter p_width = 8)
  (input signed [p_width - 1:0] a_i
  ,input signed [p_width - 1:0] b_i
  ,output signed [(2 * p_width) - 1:0] product_o
  );

  /* n * n multiplier based on the Baugh Wooley design
   * 
   * resources:
   * https://ieeexplore.ieee.org/document/4674784
   * https://ieeexplore.ieee.org/document/1672241
   * https://courses.csail.mit.edu/6.111/f2008/handouts/L09.pdf
   * http://dce.hust.edu.vn/wp-content/uploads/2017/05/MultiplierBaughWooley.pdf
   */

  wire [p_width - 2:0][p_width - 1:0] sum_in_a_w;
  wire [p_width:0][p_width - 1:0] sum_in_b_w;
  wire [p_width - 1:0][p_width - 1:0] sum_out_c_w;

  genvar i, j;
  generate
    
    // fill the b input of the 0th row adders
    // fill top bit with 1
    // fill second top bit with inverted product a_n-1 * b_0
    // fill rest with regular product a_n-2 * b_0 - a_1 * b_0
    assign sum_in_b_w[0][p_width - 1] = 1'b1;
    assign sum_in_b_w[0][p_width - 2] = ~(a_i[p_width - 1] & b_i[0]);
    for(i = 0; i < (p_width - 2); i ++) begin : gen_b_inputs
      assign sum_in_b_w[0][i] = a_i[i + 1] & b_i[0];
    end

    // 0th bit of product is a0b0
    assign product_o[0] = a_i[0] & b_i[0];
    
    // create n rows of adders and 1 row of a ripple carry adder
    for(i = 0; i < p_width; i ++) begin : gen_rows
      // create n adders per row
      for(j = 0; j < p_width; j ++) begin : gen_rows_adders

        // fill a inputs for adders with partial products
        // invert the msb for the first n-2 rows
        // invert all but the msb for the n-2 th row
        // the last ripple carry adder row doesn't need an a input

        // special case for row n-2
        // invert all but msb
        if(i < (p_width - 1)) begin : gen_rows_adders_a_in
          if(i != (p_width - 2)) begin : gen_rows_adders_lastrow
            if(j != (p_width - 1)) begin : gen_rows_adders_lastrow_lastadder
              assign sum_in_a_w[i][j] = a_i[j] & b_i[i + 1];
            end
            else begin : gen_rows_adders_lastrow_else
              assign sum_in_a_w[i][j] = ~(a_i[j] & b_i[i + 1]);
            end
          end

          // all other rows
          // invert only the msb product
          else begin : gen_rows_adders_else
            if(j != (p_width - 1)) begin : gen_rows_adders_else_lastadder
              assign sum_in_a_w[i][j] = ~(a_i[j] & b_i[i + 1]);
            end
            else begin : gen_rows_adders_else_else
              assign sum_in_a_w[i][j] = a_i[j] & b_i[i + 1];
            end
          end
        end

        // 0th row are half adders as there are no carry ins from the last row
        if(i == 0) begin : zeroth_row_halfadders 
          half_add #() ha_gen_inst (
            .a_i(sum_in_a_w[i][j]),
            .b_i(sum_in_b_w[i][j]),
            .s_o(sum_in_b_w[i + 1][j]),
            .c_o(sum_out_c_w[i][j])
          );
        end

        // rows in between 0th and last
        else if(i != (p_width - 1)) begin : middle_row_adders 
          // msb of the row can use half adder as there are no more partial
          // products. Each adder sums the partial product, sum of the
          // previous row (except the digit that will be the final product), 
          // and the carry of the previous row 
          if(j == (p_width - 1)) begin : middle_row_adders_half 
            half_add #() ha_gen_inst (
              .a_i(sum_in_a_w[i][j]),
              .b_i(sum_out_c_w[i - 1][j]),
              .s_o(sum_in_b_w[i + 1][j]),
              .c_o(sum_out_c_w[i][j])
            );
          end
          else begin : middle_row_adders_full 
            full_add #() fa_gen_inst (
              .a_i(sum_in_a_w[i][j]),
              .b_i(sum_in_b_w[i][j + 1]),
              .c_i(sum_out_c_w[i - 1][j]),
              .s_o(sum_in_b_w[i + 1][j]),
              .c_o(sum_out_c_w[i][j])
            );
          end
        end : middle_row_adders 

        // last row: ripple carry full adders
        else begin : last_row_adders 

          // the last row adds the remaining carries and the sums from the n-1
          // th row. A '1' is added to the msb as a part of the adder design 
          // (basically flipping the bit with a possible carry out)
          if(j == 0) begin : last_row_adders_lsb 
            half_add #() ha_gen_inst (
              .a_i(sum_out_c_w[i - 1][j]),
              .b_i(sum_in_b_w[i][j + 1]),
              .s_o(sum_in_b_w[i + 1][j]),
              .c_o(sum_out_c_w[i][j])
            );
          end
          else if(j == (p_width - 1)) begin : last_row_adders_msb 
            full_add #() fa_gen_inst (
              .a_i(sum_out_c_w[i - 1][j]),
              .b_i(1'b1),
              .c_i(sum_out_c_w[i][j - 1]),
              .s_o(sum_in_b_w[i + 1][j]),
              .c_o(sum_out_c_w[i][j])
            );
          end
          else begin : last_row_adders_therest 
            full_add #() fa_gen_inst (
              .a_i(sum_out_c_w[i - 1][j]),
              .b_i(sum_in_b_w[i][j + 1]),
              .c_i(sum_out_c_w[i][j - 1]),
              .s_o(sum_in_b_w[i + 1][j]),
              .c_o(sum_out_c_w[i][j])
            );
          end
        end : last_row_adders 

      end : gen_rows_adders
    end : gen_rows

    // get bits 1 -> (n-1) of the product from the adder output
    for(i = 1; i < p_width; i ++) begin : gen_product_lh
      assign product_o[i] = sum_in_b_w[i][0];
    end

    // get bits n -> (2 * n - 1) of the product from the ripple adder
    for(i = p_width; i < (2 * p_width); i ++) begin : gen_product_uh
      assign product_o[i] = sum_in_b_w[p_width][i - p_width];
    end
  endgenerate
endmodule
