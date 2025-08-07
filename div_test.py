import cocotb
from cocotb.triggers import RisingEdge, ClockCycles
from cocotb.clock import Clock



@cocotb.test()
async def test_division(dut):
    """ Basic Division test """
    c = Clock(dut.clk, 1, "ns")
    await cocotb.start(c.start())

    dut.rst.value = 0b1
    await ClockCycles(dut.clk, 2, rising=True)
    dut.rst.value = 0b0
    await ClockCycles(dut.clk, 2, rising=True)

    dut.a.value = 9
    dut.b.value = 0
    dut.start.value = 0b1
    await ClockCycles(dut.clk, 1, rising=True)

    while (dut.busy.value == 0b1):
        dut._log.info(f"Waiting {dut.valid.value}")
    dut._log.info(f"Waiting {dut.valid.value}")



    
