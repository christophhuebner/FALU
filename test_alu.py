import cocotb
from cocotb.triggers import RisingEdge, ClockCycles
from cocotb.clock import Clock


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
    '''Tests the mac operation'''
    for a in range(4):
        for b in range (4):
            for c in range(8):
                dut.op.value = 44444
