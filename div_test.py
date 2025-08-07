import cocotb
from cocotb.triggers import RisingEdge, ClockCycles
from cocotb.clock import Clock



@cocotb.test()
async def test_division(dut):
    """ Basic Division test """
    c = Clock(dut.clk, 1, "ns")
    await cocotb.start(c.start())
    await ClockCycles(dut.clk, 2, rising=True)
    dut.rst.value = 0b1
    await ClockCycles(dut.clk, 2, rising=True)
    dut.rst.value = 0b0
    await ClockCycles(dut.clk, 2, rising=True)

    for a in range (256):
        for b in range (256):
            dut.a.value = a
            dut.b.value = b

            dut.start.value = 0b1
            await ClockCycles(dut.clk, 1, rising=True)
            dut.start.value = 0b0

            while (dut.busy.value == 0b1):
                await ClockCycles(dut.clk, 1, rising=True)
                #dut._log.info(f"Waiting {dut.valid.value}")
            dut._log.info(f"Result a: {a} b: {b} quotient: {dut.val.value.integer} remainder: {dut.rem.value.integer}")
