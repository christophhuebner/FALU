// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtop.h for the primary calling header

#ifndef VERILATED_VTOP___024ROOT_H_
#define VERILATED_VTOP___024ROOT_H_  // guard

#include "verilated.h"


class Vtop__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtop___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(op,3,0);
    VL_OUT8(zero,0,0);
    VL_OUT8(carry,0,0);
    VL_OUT8(busy,0,0);
    CData/*3:0*/ ALU__DOT__op;
    CData/*0:0*/ ALU__DOT__zero;
    CData/*0:0*/ ALU__DOT__carry;
    CData/*0:0*/ ALU__DOT__busy;
    CData/*0:0*/ __VstlFirstIteration;
    CData/*0:0*/ __VicoFirstIteration;
    CData/*0:0*/ __VactContinue;
    VL_IN16(in,15,0);
    VL_OUT16(result,15,0);
    SData/*15:0*/ ALU__DOT__in;
    SData/*15:0*/ ALU__DOT__result;
    IData/*31:0*/ ALU__DOT__ALU_ops__DOT__unnamedblk1__DOT__i;
    IData/*31:0*/ __VactIterCount;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VicoTriggered;
    VlTriggerVec<0> __VactTriggered;
    VlTriggerVec<0> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vtop__Syms* const vlSymsp;

    // PARAMETERS
    static constexpr IData/*31:0*/ ALU__DOT__WIDTH = 8U;

    // CONSTRUCTORS
    Vtop___024root(Vtop__Syms* symsp, const char* v__name);
    ~Vtop___024root();
    VL_UNCOPYABLE(Vtop___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
