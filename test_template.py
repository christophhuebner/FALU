import cocotb
from cocotb.triggers import RisingEdge, ClockCycles
from cocotb.clock import Clock

@cocotb.test()
async def test_falu(dut):
    """Testbench for writing to and reading from the FALU interface."""
    
    # Start main clock
    main_clk = Clock(dut.clk, 1, "ns")
    await cocotb.start(main_clk.start())
    
    # Start I2C clock
    i2c_clk = Clock(dut.ui_in[2], 1, "ns")
    await cocotb.start(i2c_clk.start())
    
    # Reset DUT
    await ClockCycles(dut.clk, 2, rising=True)
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 2, rising=True)
    dut.rst_n.value = 1

    # Initiate a write operation
    # .start(ui_in[0]),  // Start signal from ui_in[0]
    # .wr(ui_in[1]),     // Write signal from ui_in[1]
    # .i2c_clk(ui_in[2]),  // I2C clock input
    await ClockCycles(dut.clk, 1, rising=True)
    dut.ui_in[1].value = 0  # Write mode
    dut.ui_in[0].value = 1  # Raise start signal
    await ClockCycles(dut.clk, 1, rising=True)
    dut.ui_in[1].value = 0  # Lower start signal
    dut.ui_in[0].value = 0  # Write mode

    # Prepare data: [opcode(4 bits), a(8 bits), b(8 bits)]
    ops = 0b0011
    a = 0b11111111
    b = 0b11010101
    data_in = (ops << 16) | (a << 8) | b

    # Send data serially over ui_in[3]
    for i in range(20):
        dut.ui_in[3].value = (data_in >> (19 - i)) & 0b1
        await ClockCycles(dut.clk, 1, rising=True)

    # Initiate a read operation
    await ClockCycles(dut.clk, 1, rising=True)
    dut.ui_in[1].value = 1  # Read mode
    dut.ui_in[0].value = 1  # Raise start signal
    await ClockCycles(dut.clk, 2, rising=True)
    dut.ui_in[0].value = 0  # Lower start signal
    dut.ui_in[1].value = 0  # Clear read signal

    # Capture output data from DUT
    output_data = ""
    for i in range(16):  # Exactly 16 bits
        output_data += str(dut.uo_out[0].value.binstr)
        await ClockCycles(dut.clk, 1, rising=True)

    dut._log.info(f"{output_data}, length: {len(output_data)}")

    # Wait a few cycles before ending test
    await ClockCycles(dut.clk, 10, rising=True)
