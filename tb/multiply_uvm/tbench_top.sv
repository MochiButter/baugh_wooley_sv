`include "uvm_pkg.sv"

import uvm_pkg::*;

`include "mult_if.sv"
`include "mult_test.sv"

module tbench_top;
  mult_if intf();

  multiply #(.p_width(4)) DUT (
    .a_i(intf.a_i),
    .b_i(intf.b_i),
    .a_signed_i(intf.a_signed_i),
    .b_signed_i(intf.b_signed_i),
    .product_o(intf.product_o)
  );

  initial begin
    uvm_config_db#(virtual mult_if)::set(uvm_root::get(),"*","vif",intf);
  end

  initial begin
    run_test();
  end
endmodule
