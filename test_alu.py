import cocotb
from cocotb.triggers import Timer


def to_signed(val, bits):
    return val - (1 << bits) if val >= (1 << (bits - 1)) else val

clz_test_vectors = {
        0b00000000: 8,
        0b10000000: 0,
        0b01000000: 1,
        0b00100000: 2,
        0b00010000: 3,
        0b00001000: 4,
        0b00000100: 5,
        0b00000010: 6,
        0b00000001: 7,
        0b11111111: 0,
        0b01111111: 1,
        0b00001111: 4,
    }



def sort_model(a,b):
    if a < b:
        return (b << 8) | a
    else:
        return (a << 8) | b

def approx_log_model(a):
    pass

def ctz_model(a):
    pass

def division_model(a):
    pass

def multiplication_model(a,b):
    pass

def hamming_distance_model(a,b):
    return bin(a ^ b).count('1')



@cocotb.test(skip=True)
async def test_mac(dut):
    dut.op.value = 0b1001
    for a in range(16):
        for b in range(16):
            for c in range(256):
                merged = (a << 12) | (b << 8) | c
                dut.data_in.value = merged
                await Timer(2, "ns")
                
                expected = a * b + c
                actual = dut.result.value.integer
                
                assert actual == expected, f"Mismatch for A={a} B={b} C={c}: got {actual}, expected {expected}"
               

@cocotb.test(skip=True)
async def test_sort(dut):
    '''Test the sorting number'''
    dut.op.value = 0b1010
    for a in range(256):
        for b in range(256):
            merged = (a << 8) | b
            dut.data_in.value = merged
            await Timer(2, "ns")
            expected = sort_model(a,b)
            actual = dut.result.value.integer
            assert actual == expected, f"Mismatch for A={a} B={b}: got {actual}, expected {expected}"
               

@cocotb.test(skip=True)
async def test_hamming_distance(dut):
    '''Test Hamming distance'''
    dut.op.value = 0b1111

    for a in range(256):
        for b in range (256):
            expected = hamming_distance_model(a,b)
            merged = ((a & 0xFF )<< 8) | (b & 0xFF)
            dut.data_in.value = merged
            await Timer(2, "ns")
            actual = dut.result.value.integer
            assert actual == expected, f"Mismatch for A={a} B={b}: got {actual}, expected {expected}"
           

@cocotb.test(skip=True)
async def test_addition(dut):
    '''Test Addition'''
    dut.op.value = 0b0000
    for a in range(-128, 128):
        for b in range(-128,128):
            merged = ((a & 0xFF )<< 8) | (b & 0xFF)
            dut.data_in.value = merged
            await Timer(2, "ns")
            actual = dut.result.value.signed_integer
            expected = a + b
            assert actual == expected, f"Mismatch for A={a} B={b}: got {actual}, expected {expected}"
           
@cocotb.test(skip=True)
async def test_subtraction(dut):
    '''Test Subtraction'''
    dut.op.value = 0b0001
    for a in range(-128, 128):
        for b in range(-128,128):
            merged = ((b & 0xFF) << 8) | (a & 0xFF)
            dut.data_in.value = merged
            await Timer(2, "ns")
            actual = dut.result.value.signed_integer
            expected = a - b
            assert actual == expected, f"Mismatch for A={a} B={b}: got {actual}, expected {expected}"
           
@cocotb.test(skip=True)
async def test_and(dut):
    '''Test And'''
    dut.op.value = 0b0010
    for a in range(-128, 128):
        for b in range(-128,128):
            merged = ((b & 0xFF) << 8) | (a & 0xFF)
            dut.data_in.value = merged
            await Timer(2, "ns")
            actual = dut.result.value.integer
            expected = (a & 0xFF) & (b & 0xFF)
            assert actual == expected, f"Mismatch for A={a} B={b}: got {actual}, expected {expected}"
      
@cocotb.test(skip=True)
async def test_or(dut):
    '''Test Or'''
    dut.op.value = 0b0011
    for a in range(-128, 128):
        for b in range(-128,128):
            merged = ((b & 0xFF) << 8) | (a & 0xFF)
            dut.data_in.value = merged
            await Timer(2, "ns")
            actual = dut.result.value.integer
            expected = (a & 0xFF) | (b & 0xFF)
            assert actual == expected, f"Mismatch for A={a} B={b}: got {actual}, expected {expected}"
      
@cocotb.test(skip=True)
async def test_xor(dut):
    '''Test Xor'''
    dut.op.value = 0b0100
    for a in range(-128, 128):
        for b in range(-128,128):
            merged = ((b & 0xFF) << 8) | (a & 0xFF)
            dut.data_in.value = merged
            await Timer(2, "ns")
            actual = dut.result.value.integer
            expected = (a & 0xFF) ^ (b & 0xFF)
            assert actual == expected, f"Mismatch for A={a} B={b}: got {actual}, expected {expected}"
      
@cocotb.test(skip=True)
async def test_nand(dut):
    '''Test NAND'''
    dut.op.value = 0b0101
    for a in range(-128, 128):
        for b in range(-128,128):
            merged = ((b & 0xFF) << 8) | (a & 0xFF)
            dut.data_in.value = merged
            await Timer(2, "ns")
            actual = dut.result.value.integer
            expected = ~((a & 0xFF) & (b & 0xFF)) & 0xFF
            assert actual == expected, f"Mismatch for A={a} B={b}: got {actual}, expected {expected}"
      

@cocotb.test(skip=True)
async def test_nor(dut):
    '''Test Nor'''
    dut.op.value = 0b0110
    for a in range(-128, 128):
        for b in range(-128,128):
            merged = ((b & 0xFF) << 8) | (a & 0xFF)
            dut.data_in.value = merged
            await Timer(2, "ns")
            actual = dut.result.value.integer
            expected = ~((a & 0xFF) | (b & 0xFF)) & 0xFF
            assert actual == expected, f"Mismatch for A={a} B={b}: got {actual}, expected {expected}"


@cocotb.test(skip=True)
async def test_xnor(dut):
    '''Test XNOR'''
    dut.op.value = 0b0111
    for a in range(-128, 128):
        for b in range(-128,128):
            merged = ((b & 0xFF) << 8) | (a & 0xFF)
            dut.data_in.value = merged
            await Timer(2, "ns")
            actual = dut.result.value.integer
            expected = ~((a & 0xFF) ^ (b & 0xFF)) & 0xFF
            assert actual == expected, f"Mismatch for A={a} B={b}: got {actual}, expected {expected}"


@cocotb.test()
async def test_clz(dut):
    '''Test CLZ'''
    dut.op.value = 0b1000
    a = 0b00000000
    for vector in clz_test_vectors:
        merged = (vector << 8) | a
        dut.data_in.value = merged
        await Timer(2, "ns")
        expected = clz_test_vectors[vector]
        actual = dut.result.value.integer
        assert actual == expected, f"Mismatch for A={a} B={b}: got {actual}, expected {expected}"

        
         