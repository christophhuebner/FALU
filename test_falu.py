import cocotb
from cocotb.triggers import RisingEdge, ClockCycles
from cocotb.clock import Clock

@cocotb.test()
async def test_falu(dut):
    """ Test Falu with data """
    c = Clock(dut.clk, 1, "ns")
    await cocotb.start(c.start())

    # Reset interface
    dut.reset.value = 0b1
    await ClockCycles(dut.clk, 2, rising=True)
    dut.reset.value = 0b0
    
    # Master will was von dir!
    dut.start.value = 0b1
    await ClockCycles(dut.clk, 1, rising=True)
    dut.start.value = 0b0

    # Write to slave
    dut.wr.value = 0b1
    await ClockCycles(dut.clk, 1, rising=True)
    dut.wr.value = 0b0

    # 


    




