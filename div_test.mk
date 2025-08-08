# Makefile created with cocotb_snippets

# Simulator to be used.
SIM ?= verilator
EXTRA_ARGS += --trace --trace-structs

TOPLEVEL_LANG ?= verilog

# Add verilog sources
# Add more sources by replicating the following lines.
VERILOG_SOURCES += $(PWD)/src/divu_int.sv

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = divu_int

# MODULE is the basename of the Python test file
# Corresponds the filename of the python file
MODULE = div_test

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim