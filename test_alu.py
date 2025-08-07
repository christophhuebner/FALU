import cocotb
from cocotb.triggers import Timer


def to_signed(val, bits):
    return val - (1 << bits) if val >= (1 << (bits - 1)) else val

def add_model(a, b):
    pass

def sub_model(a,b):
    pass

def and_model(a,b):
    pass

def or_model(a,b):
    pass

def xor_model(a,b):
    pass

def nand_model(a,b):
    pass

def nor_model(a,b):
    pass

def xnor_model(a,b):
    pass

def clz_model(a):
    pass

def mac_model(a,b,c):
    pass

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
            merged = (a << 8) | b
            dut.data_in.value = merged
            await Timer(2, "ns")
            actual = dut.result.value.integer
            assert actual == expected, f"Mismatch for A={a} B={b}: got {actual}, expected {expected}"
           

@cocotb.test()
async def test_addition(dut):
    '''Test Addition'''
    dut.op.value = 0b0000
    for a in range(-128, 128):
        for b in range(-128,128):
            merged = (a << 8) | (b & 0xFF)
            dut.data_in.value = merged
            await Timer(2, "ns")
            actual = dut.result.value.signed_integer
            expected = a + b
            assert actual == expected, f"Mismatch for A={a} B={b}: got {actual}, expected {expected}"
           
            

