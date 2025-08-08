import cocotb
from cocotb.triggers import RisingEdge, ClockCycles
from cocotb.clock import Clock



@cocotb.test()
async def test_falu_i2c_r(dut):
    ops = 0b0011
    a = 0b00000111
    b = 0b01001010
    c = Clock(dut.scl, 5, "ns")
    await cocotb.start(c.start())

    dut.start.value = 0b0001
    await ClockCycles(dut.scl, 1, rising=True)
    dut.start.value = 0b0000
    d_in = (ops << 16) | (a << 8) | b

    for i in range(20):
        dut.sda_i.value = (d_in >> 19-i) & 1
        await ClockCycles(dut.scl, 1, rising=True)
        print(dut.data_out.value)


    await ClockCycles(dut.scl, 2, rising=True)
 

    expected = int(ops)
    actual = dut.op.value.integer
    
    assert actual == expected, f"got {actual}, expected {expected}"

    expected = int((a << 8) | b)
    actual = dut.data_out.value.integer
    
    assert actual == expected, f"got {actual}, expected {expected}"


@cocotb.test()
async def test_falu_i2c_w(dut):
    ops = 0b0011
    a = 0b00000111
    b = 0b01001010
    c = Clock(dut.scl, 5, "ns")
    await cocotb.start(c.start())

    dut.start.value = 0b0001
    await ClockCycles(dut.scl, 1, rising=True)
    dut.start.value = 0b0000
    d_in = (ops << 16) | (a << 8) | b

    for i in range(20):
        dut.sda_i.value = (d_in >> 19-i) & 1
        await ClockCycles(dut.scl, 1, rising=True)
        print(dut.data_out.value)


    await ClockCycles(dut.scl, 2, rising=True)
 

    expected = int(ops)
    actual = dut.op.value.integer
    
    assert actual == expected, f"got {actual}, expected {expected}"

    expected = int((a << 8) | b)
    actual = dut.data_out.value.integer
    
    assert actual == expected, f"got {actual}, expected {expected}"
    