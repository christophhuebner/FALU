import cocotb
from cocotb.triggers import RisingEdge, ClockCycles
from cocotb.clock import Clock


async def async_falucinator(dut):
    """The ultimate FALU operation commander!"""
    
    for ops in [0b1010, 0b0000, 0b0010, 0b0011, 0b1111, 0b1110, 0b1000]: 
        # Reset DUT
        await ClockCycles(dut.clk, 1, rising=True)
        dut.rst_n.value = 0
        await ClockCycles(dut.clk, 1, rising=True)
        dut.rst_n.value = 1

        # Initiate a write operation
        # .start(ui_in[0]),  // Start signal from ui_in[0]
        # .wr(ui_in[1]),     // Write signal from ui_in[1]
        # .i2c_clk(ui_in[2]),  // I2C clock input
        await ClockCycles(dut.clk, 1, rising=True)
        dut.ui_in[1].value = 0  # Write mode
        dut.ui_in[0].value = 1  # Raise start
        await ClockCycles(dut.clk, 1, rising=True)
        dut.ui_in[0].value = 0  # Lower start
        dut.ui_in[1].value = 0  # Write mode

        # Prepare data [opcode(4) | a(8) | b(8)]
        a = 0b0111_1110
        b = 0b1101_0101
        data_in = (ops << 16) | (a << 8) | b

        # Send data serially
        for i in range(20):
            dut.ui_in[3].value = (data_in >> (19 - i)) & 0b1
            await ClockCycles(dut.clk, 1, rising=True)

        # Initiate read operation
        await ClockCycles(dut.clk,  2, rising=True)
        
        dut.ui_in[1].value = 1  # Read mode
        dut.ui_in[0].value = 1  # Raise start
        await ClockCycles(dut.clk, 1, rising=True)
        dut.ui_in[0].value = 0  # Lower start
        dut.ui_in[1].value = 0  # Clear read
        await ClockCycles(dut.clk, 1, rising=True)

        # Capture output
        output_data = ""
        for i in range(16):
            await ClockCycles(dut.clk, 1, rising=True)
            output_data += str(dut.uo_out[0].value.binstr)
         
        dut._log.info(f"Ops {ops:04b} -> Output: {output_data} (length {len(output_data)})")

        # Small delay before next op
        await ClockCycles(dut.clk, 1, rising=True)


# -------------------------------
# Cocotb test wrapper
# -------------------------------
@cocotb.test()
async def test_falu(dut):
    """Cocotb test wrapper for async_falucinator."""
    
    # Setup clocks
    main_clk = Clock(dut.clk, 1, "ns")
    await cocotb.start(main_clk.start())

    i2c_clk = Clock(dut.ui_in[2], 1, "ns")
    await cocotb.start(i2c_clk.start())

    # Call the reusable FALU test logic
    await async_falucinator(dut)
