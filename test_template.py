import cocotb
from cocotb.triggers import RisingEdge, ClockCycles
from cocotb.clock import Clock

@cocotb.test()
async def test_falu(dut):
    """ Test template with data """
    c = Clock(dut.clk, 1, "ns")
    await cocotb.start(c.start())
    i2c_clk = Clock(dut.ui_in[2], 1, "ns")
    await cocotb.start(i2c_clk.start())
    
    # Reset interface
    dut.rst_n.value = 0b1
    await ClockCycles(dut.ui_in[2], 2, rising=True)
    dut.rst_n.value = 0b0
    
    # Master will was von dir!
    #dut.ui_in[1].value = 0b0
    #await ClockCycles(dut.ui_in[2], 1, rising=True)
    #dut.ui_in[1].value = 0b0

    # Write to slave
    await ClockCycles(dut.ui_in[2], 1, rising=True)
    dut.ui_in[1].value = 0b0
    await ClockCycles(dut.ui_in[2], 1, rising=True)

    # start writing data
    dut.ui_in[0].value = 0b1
    await ClockCycles(dut.ui_in[2], 1, rising=True)
    dut.ui_in[0].value = 0b0

    # Write data to  
    ops = 0b0010
    a = 0b11011101
    b = 0b01001000
    #await ClockCycles(dut.ui_in[2], 1, rising=True)
    data_in = (ops << 16) | (a << 8) | b

    for i in range(20):
        dut.ui_in[3].value = (data_in >> 19-i) & 0b1
        await ClockCycles(dut.ui_in[2], 1, rising=True)
        
    await ClockCycles(dut.ui_in[2], 2, rising=True)


    # Write to slave
    await ClockCycles(dut.ui_in[2], 1, rising=True)
    dut.ui_in[1].value = 0b1
    await ClockCycles(dut.ui_in[2], 1, rising=True)

    # start writing data
    dut.ui_in[0].value = 0b0001
    await ClockCycles(dut.ui_in[2], 1, rising=True)
    dut.ui_in[0].value = 0b0000

    # Write data to  
    #ops = 0b0011
    #a = 0b00000111
    #b = 0b01001010
    #await ClockCycles(dut.ui_in[2], 1, rising=True)
    #data_in = (ops << 16) | (a << 8) | b
    x = ""
    for i in range(18):
       x += str(dut.uo_out[0].value.binstr)
       await ClockCycles(dut.ui_in[2], 1, rising=True)
    
    dut._log.info(x)
    await ClockCycles(dut.ui_in[2], 2, rising=True)


    

    






    




