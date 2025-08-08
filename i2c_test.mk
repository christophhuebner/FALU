# Makefile created with cocotb_snippets

# Simulator to be used.
SIM ?= verilator
#EXTRA_ARGS += 

TOPLEVEL_LANG ?= verilog

# Add verilog sources
# Add more sources by replicating the following lines.
#VERILOG_SOURCES += $(PWD)/FALU_top.sv

VERILOG_SOURCES += $(PWD)/src/i2c.sv

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = I2C_Controller

# MODULE is the basename of the Python test file
# Corresponds the filename of the python file
MODULE = test_i2c


# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim