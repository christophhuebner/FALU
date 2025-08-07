// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop__pch.h"
#include "Vtop___024root.h"

VL_ATTR_COLD void Vtop___024root___eval_static(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_static\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vtop___024root___eval_initial(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_initial\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vtop___024root___eval_final(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_final\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__stl(Vtop___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vtop___024root___eval_phase__stl(Vtop___024root* vlSelf);

VL_ATTR_COLD void Vtop___024root___eval_settle(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_settle\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    IData/*31:0*/ __VstlIterCount;
    CData/*0:0*/ __VstlContinue;
    // Body
    __VstlIterCount = 0U;
    vlSelfRef.__VstlFirstIteration = 1U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        if (VL_UNLIKELY(((0x64U < __VstlIterCount)))) {
#ifdef VL_DEBUG
            Vtop___024root___dump_triggers__stl(vlSelf);
#endif
            VL_FATAL_MT("/Users/amritsharmapoudel/FALU/ALU.sv", 1, "", "Settle region did not converge.");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        __VstlContinue = 0U;
        if (Vtop___024root___eval_phase__stl(vlSelf)) {
            __VstlContinue = 1U;
        }
        vlSelfRef.__VstlFirstIteration = 0U;
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__stl(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___dump_triggers__stl\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VstlTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VstlTriggered.word(0U))) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vtop___024root___stl_sequent__TOP__0(Vtop___024root* vlSelf);

VL_ATTR_COLD void Vtop___024root___eval_stl(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_stl\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VstlTriggered.word(0U))) {
        Vtop___024root___stl_sequent__TOP__0(vlSelf);
    }
}

VL_ATTR_COLD void Vtop___024root___stl_sequent__TOP__0(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___stl_sequent__TOP__0\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.ALU__DOT__in = vlSelfRef.in;
    vlSelfRef.ALU__DOT__op = vlSelfRef.op;
    vlSelfRef.zero = vlSelfRef.ALU__DOT__zero;
    vlSelfRef.carry = vlSelfRef.ALU__DOT__carry;
    vlSelfRef.busy = vlSelfRef.ALU__DOT__busy;
    if ((8U & (IData)(vlSelfRef.op))) {
        if ((4U & (IData)(vlSelfRef.op))) {
            vlSelfRef.ALU__DOT__result = 0U;
        } else if ((2U & (IData)(vlSelfRef.op))) {
            vlSelfRef.ALU__DOT__result = 0U;
        } else if ((1U & (IData)(vlSelfRef.op))) {
            vlSelfRef.ALU__DOT__result = 0U;
        } else {
            vlSelfRef.ALU__DOT__result = 0U;
            vlSelfRef.ALU__DOT__ALU_ops__DOT__unnamedblk1__DOT__i = 0U;
            {
                while (VL_GTS_III(32, 8U, vlSelfRef.ALU__DOT__ALU_ops__DOT__unnamedblk1__DOT__i)) {
                    if ((1U & ((IData)(vlSelfRef.in) 
                               >> (0xfU & ((IData)(7U) 
                                           - vlSelfRef.ALU__DOT__ALU_ops__DOT__unnamedblk1__DOT__i))))) {
                        goto __Vlabel1;
                    } else {
                        vlSelfRef.ALU__DOT__result 
                            = (0xffffU & ((IData)(1U) 
                                          + (IData)(vlSelfRef.ALU__DOT__result)));
                    }
                    vlSelfRef.ALU__DOT__ALU_ops__DOT__unnamedblk1__DOT__i 
                        = ((IData)(1U) + vlSelfRef.ALU__DOT__ALU_ops__DOT__unnamedblk1__DOT__i);
                }
                __Vlabel1: ;
            }
        }
    } else {
        vlSelfRef.ALU__DOT__result = (0xffffU & ((4U 
                                                  & (IData)(vlSelfRef.op))
                                                  ? 
                                                 ((2U 
                                                   & (IData)(vlSelfRef.op))
                                                   ? 
                                                  ((1U 
                                                    & (IData)(vlSelfRef.op))
                                                    ? 
                                                   (~ 
                                                    ((0xffU 
                                                      & (IData)(vlSelfRef.in)) 
                                                     ^ 
                                                     (0xffU 
                                                      & ((IData)(vlSelfRef.in) 
                                                         >> 8U))))
                                                    : 
                                                   (~ 
                                                    (0xffU 
                                                     & ((IData)(vlSelfRef.in) 
                                                        | ((IData)(vlSelfRef.in) 
                                                           >> 8U)))))
                                                   : 
                                                  ((1U 
                                                    & (IData)(vlSelfRef.op))
                                                    ? 
                                                   (~ 
                                                    (0xffU 
                                                     & ((IData)(vlSelfRef.in) 
                                                        & ((IData)(vlSelfRef.in) 
                                                           >> 8U))))
                                                    : 
                                                   ((0xffU 
                                                     & (IData)(vlSelfRef.in)) 
                                                    ^ 
                                                    (0xffU 
                                                     & ((IData)(vlSelfRef.in) 
                                                        >> 8U)))))
                                                  : 
                                                 ((2U 
                                                   & (IData)(vlSelfRef.op))
                                                   ? 
                                                  ((1U 
                                                    & (IData)(vlSelfRef.op))
                                                    ? 
                                                   (0xffU 
                                                    & ((IData)(vlSelfRef.in) 
                                                       | ((IData)(vlSelfRef.in) 
                                                          >> 8U)))
                                                    : 
                                                   (0xffU 
                                                    & ((IData)(vlSelfRef.in) 
                                                       & ((IData)(vlSelfRef.in) 
                                                          >> 8U))))
                                                   : 
                                                  ((1U 
                                                    & (IData)(vlSelfRef.op))
                                                    ? 
                                                   ((0xffU 
                                                     & (IData)(vlSelfRef.in)) 
                                                    - 
                                                    (0xffU 
                                                     & ((IData)(vlSelfRef.in) 
                                                        >> 8U)))
                                                    : 
                                                   ((0xffU 
                                                     & (IData)(vlSelfRef.in)) 
                                                    + 
                                                    (0xffU 
                                                     & ((IData)(vlSelfRef.in) 
                                                        >> 8U)))))));
    }
    vlSelfRef.result = vlSelfRef.ALU__DOT__result;
}

VL_ATTR_COLD void Vtop___024root___eval_triggers__stl(Vtop___024root* vlSelf);

VL_ATTR_COLD bool Vtop___024root___eval_phase__stl(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_phase__stl\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VstlExecute;
    // Body
    Vtop___024root___eval_triggers__stl(vlSelf);
    __VstlExecute = vlSelfRef.__VstlTriggered.any();
    if (__VstlExecute) {
        Vtop___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__ico(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___dump_triggers__ico\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VicoTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VicoTriggered.word(0U))) {
        VL_DBG_MSGF("         'ico' region trigger index 0 is active: Internal 'ico' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__act(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___dump_triggers__act\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VactTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__nba(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___dump_triggers__nba\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VnbaTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vtop___024root___ctor_var_reset(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___ctor_var_reset\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelf->in = VL_RAND_RESET_I(16);
    vlSelf->op = VL_RAND_RESET_I(4);
    vlSelf->result = VL_RAND_RESET_I(16);
    vlSelf->zero = VL_RAND_RESET_I(1);
    vlSelf->carry = VL_RAND_RESET_I(1);
    vlSelf->busy = VL_RAND_RESET_I(1);
    vlSelf->ALU__DOT__in = VL_RAND_RESET_I(16);
    vlSelf->ALU__DOT__op = VL_RAND_RESET_I(4);
    vlSelf->ALU__DOT__result = VL_RAND_RESET_I(16);
    vlSelf->ALU__DOT__zero = VL_RAND_RESET_I(1);
    vlSelf->ALU__DOT__carry = VL_RAND_RESET_I(1);
    vlSelf->ALU__DOT__busy = VL_RAND_RESET_I(1);
    vlSelf->ALU__DOT__ALU_ops__DOT__unnamedblk1__DOT__i = VL_RAND_RESET_I(32);
}
