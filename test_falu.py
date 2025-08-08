import cocotb
from cocotb.triggers import RisingEdge, ClockCycles
from cocotb.clock import Clock

@cocotb.test()
async def test_falu(dut):
    """ Test Falu with data """
    c = Clock(dut.clk, 1, "ns")
    await cocotb.start(c.start())
    i2c_clk = Clock(dut.i2c_clk, 1, "ns")
    await cocotb.start(i2c_clk.start())
    

    # Reset interface
    dut.reset.value = 0b1
    await ClockCycles(dut.i2c_clk, 2, rising=True)
    dut.reset.value = 0b0
    
    # Master will was von dir!
    #dut.wr.value = 0b0
    #await ClockCycles(dut.i2c_clk, 1, rising=True)
    #dut.wr.value = 0b0

    # Write to slave
    await ClockCycles(dut.i2c_clk, 1, rising=True)
    dut.wr.value = 0b0
    await ClockCycles(dut.i2c_clk, 1, rising=True)

    # start writing data
    dut.start.value = 0b0001
    await ClockCycles(dut.i2c_clk, 1, rising=True)
    dut.start.value = 0b0000

    # Write data to  
    ops = 0b0011
    a = 0b00000111
    b = 0b01001010
    #await ClockCycles(dut.i2c_clk, 1, rising=True)

 

    data_in = (ops << 16) | (a << 8) | b

    for i in range(20):
        dut.i2c_sda_i.value = (data_in >> 19-i) & 1
        await ClockCycles(dut.i2c_clk, 1, rising=True)
        dut._log.info(f"{dut.i2c_inst.data_out.value.signed_integer}")

    await ClockCycles(dut.i2c_clk, 2, rising=True)

    for i in range(5):
        print(dut.data_in.value)
        print(dut.op.value)
    






    




