# UVM test for the multiplier module
The uvm testbench and makefile are based on the examples in
[verilator-verification](https://github.com/antmicro/verilator-verification/tree/main/tests/uvm-testbenches/mem-tb).

The uvm testbench needs a specific modified uvm library, as well as a fairly new version of verilator to run.

I was using the verilator version:
`Verilator 5.041 devel rev v5.040-67-gc6ffd22c4`
to run these tests.
Version
`Verilator 5.029 devel rev v5.028-203-gece0613e0`
was not able to run due to errors.

To run the simulation, make sure you have an appropriate verilator version, and the uvm files.

```
git submodule update --init
VERILATOR_ROOT=/if/your/system/verion/is/old make simulate
```

This will randomly generate 15 pairs of operands and test if the multiplier works properly.
