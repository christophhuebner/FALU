import cocotb
from cocotb.triggers import Timer

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
    pass

def approx_log_model(a):
    pass

def ctz_model(a):
    pass

def division_model(a):
    pass

def multiplication_model(a,b):
    pass

def hamming_distance_model(a,b):
    pass



@cocotb.test()
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
               
