# Makefile created with cocotb_snippets

# Simulator to be used.
SIM ?= verilator
#EXTRA_ARGS += 

TOPLEVEL_LANG ?= verilog

# Add verilog sources
# Add more sources by replicating the following lines.
#VERILOG_SOURCES += $(PWD)/FALU_top.sv
VERILOG_SOURCES += $(PWD)/ALU.sv
VERILOG_SOURCES += $(PWD)/i2c.sv

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = ALU

# MODULE is the basename of the Python test file
# Corresponds the filename of the python file
MODULE = test_alu


# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim