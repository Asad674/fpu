# fpu
IEEE-754 compliant FP32 Floating-Point Unit in Verilog, currently featuring a fully verified 32-bit adder with subnormal support and all standard rounding modes, with plans to add more FPU units and parameterization support.

The project uses ModelSim with a flexible Makefile-driven workflow.
All key parameters are configurable at runtime.

##
Basic simulation
##
```
make modelsim OP=add MODE=RNE
make modelsim OP=mul MODE=RNE
```

##Run with a specific rounding mode
```
make modelsim OP=add MODE=RTZ
make modelsim OP=add MODE=RUP
make modelsim OP=add MODE=RDN
make modelsim OP=add MODE=RMM
```

##Launch simulation with GUI
```
make modelsim OP=add MODE=RTZ GUI=1
```

Run full regression across all rounding modes
```
make modelsim_all OP=add
```
