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
    
    await ClockCycles(dut.ui_in[2], 2, rising=True)
    # Reset interface
    dut.rst_n.value = 0b1
    await ClockCycles(dut.ui_in[2], 2, rising=True)
    dut.rst_n.value = 0b0
    await ClockCycles(dut.ui_in[2], 2, rising=True)
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
    await ClockCycles(dut.ui_in[2], 2, rising=True)
    dut.ui_in[0].value = 0b0

    ops = [
        0b0000,  # OP_ADD
        0b0001,  # OP_SUB
        0b0010,  # OP_AND
        0b0011,  # OP_OR
        0b0100,  # OP_XOR
        0b0101,  # OP_NAND
        0b0110,  # OP_NOR
        0b0111,  # OP_XNOR
        0b1000,  # OP_CLZ
        0b1001,  # OP_MAC
        0b1010,  # OP_SORT
        0b1011,  # OP_LOG
        0b1100,  # OP_CTZ
        0b1110,  # OP_MUL
        0b1111   # OP_HAMMING
    ]

    # Write data to  
    for op in ops:
        a = 0b11000101 #221
        b = 0b11001000 #200
        #await ClockCycles(dut.ui_in[2], 1, rising=True)
        data_in = (op << 16) | (a << 8) | b
        dut._log.info(f"Data in: {data_in}, Op: {op}")

        for i in range(20):
            dut.ui_in[3].value = (data_in >> 19-i) & 0b1
            # await ClockCycles(dut.ui_in[2], 1, rising=True)
            await ClockCycles(dut.clk, 1, rising=True)
            
        await ClockCycles(dut.clk, 2, rising=True)


        # Write to slave
        await ClockCycles(dut.clk, 2, rising=True)
        dut.ui_in[1].value = 0b1
        await ClockCycles(dut.clk, 2, rising=True)

        # start writing data
        dut.ui_in[0].value = 0b1
        await ClockCycles(dut.clk, 2, rising=True)
        dut.ui_in[0].value = 0b0
        x = ""
        dut._log.info(f"-------- X: {x}")
       
        
        for i in range(17):
            x += str(dut.uo_out[0].value.binstr)
            # dut._log.info(f"{dut.i2c_inst.}")
            await ClockCycles(dut.clk, 1, rising=True)
            
        dut._log.info(x)
        await ClockCycles(dut.ui_in[2], 2, rising=True)

        

    






    




