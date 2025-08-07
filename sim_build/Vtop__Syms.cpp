// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vtop__pch.h"
#include "Vtop.h"
#include "Vtop___024root.h"

// FUNCTIONS
Vtop__Syms::~Vtop__Syms()
{

    // Tear down scope hierarchy
    __Vhier.remove(0, &__Vscope_ALU);
    __Vhier.remove(&__Vscope_ALU, &__Vscope_ALU__ALU_ops);
    __Vhier.remove(&__Vscope_ALU__ALU_ops, &__Vscope_ALU__ALU_ops__unnamedblk1);

}

Vtop__Syms::Vtop__Syms(VerilatedContext* contextp, const char* namep, Vtop* modelp)
    : VerilatedSyms{contextp}
    // Setup internal state of the Syms class
    , __Vm_modelp{modelp}
    // Setup module instances
    , TOP{this, namep}
{
        // Check resources
        Verilated::stackCheck(25);
    // Configure time unit / time precision
    _vm_contextp__->timeunit(-9);
    _vm_contextp__->timeprecision(-12);
    // Setup each module's pointers to their submodules
    // Setup each module's pointer back to symbol table (for public functions)
    TOP.__Vconfigure(true);
    // Setup scopes
    __Vscope_ALU.configure(this, name(), "ALU", "ALU", "ALU", -9, VerilatedScope::SCOPE_MODULE);
    __Vscope_ALU__ALU_ops.configure(this, name(), "ALU.ALU_ops", "ALU_ops", "<null>", -9, VerilatedScope::SCOPE_OTHER);
    __Vscope_ALU__ALU_ops__unnamedblk1.configure(this, name(), "ALU.ALU_ops.unnamedblk1", "unnamedblk1", "<null>", -9, VerilatedScope::SCOPE_OTHER);
    __Vscope_TOP.configure(this, name(), "TOP", "TOP", "<null>", 0, VerilatedScope::SCOPE_OTHER);

    // Set up scope hierarchy
    __Vhier.add(0, &__Vscope_ALU);
    __Vhier.add(&__Vscope_ALU, &__Vscope_ALU__ALU_ops);
    __Vhier.add(&__Vscope_ALU__ALU_ops, &__Vscope_ALU__ALU_ops__unnamedblk1);

    // Setup export functions
    for (int __Vfinal = 0; __Vfinal < 2; ++__Vfinal) {
        __Vscope_ALU.varInsert(__Vfinal,"WIDTH", const_cast<void*>(static_cast<const void*>(&(TOP.ALU__DOT__WIDTH))), true, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,0,1 ,31,0);
        __Vscope_ALU.varInsert(__Vfinal,"busy", &(TOP.ALU__DOT__busy), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0,0);
        __Vscope_ALU.varInsert(__Vfinal,"carry", &(TOP.ALU__DOT__carry), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0,0);
        __Vscope_ALU.varInsert(__Vfinal,"in", &(TOP.ALU__DOT__in), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,0,1 ,15,0);
        __Vscope_ALU.varInsert(__Vfinal,"op", &(TOP.ALU__DOT__op), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0,1 ,3,0);
        __Vscope_ALU.varInsert(__Vfinal,"result", &(TOP.ALU__DOT__result), false, VLVT_UINT16,VLVD_NODIR|VLVF_PUB_RW,0,1 ,15,0);
        __Vscope_ALU.varInsert(__Vfinal,"zero", &(TOP.ALU__DOT__zero), false, VLVT_UINT8,VLVD_NODIR|VLVF_PUB_RW,0,0);
        __Vscope_ALU__ALU_ops__unnamedblk1.varInsert(__Vfinal,"i", &(TOP.ALU__DOT__ALU_ops__DOT__unnamedblk1__DOT__i), false, VLVT_UINT32,VLVD_NODIR|VLVF_PUB_RW,0,1 ,31,0);
        __Vscope_TOP.varInsert(__Vfinal,"busy", &(TOP.busy), false, VLVT_UINT8,VLVD_OUT|VLVF_PUB_RW,0,0);
        __Vscope_TOP.varInsert(__Vfinal,"carry", &(TOP.carry), false, VLVT_UINT8,VLVD_OUT|VLVF_PUB_RW,0,0);
        __Vscope_TOP.varInsert(__Vfinal,"in", &(TOP.in), false, VLVT_UINT16,VLVD_IN|VLVF_PUB_RW,0,1 ,15,0);
        __Vscope_TOP.varInsert(__Vfinal,"op", &(TOP.op), false, VLVT_UINT8,VLVD_IN|VLVF_PUB_RW,0,1 ,3,0);
        __Vscope_TOP.varInsert(__Vfinal,"result", &(TOP.result), false, VLVT_UINT16,VLVD_OUT|VLVF_PUB_RW,0,1 ,15,0);
        __Vscope_TOP.varInsert(__Vfinal,"zero", &(TOP.zero), false, VLVT_UINT8,VLVD_OUT|VLVF_PUB_RW,0,0);
    }
}
