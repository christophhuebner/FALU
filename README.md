# 🧮 FALU – A Custom Arithmetic Logic Unit
## Team FAUzL - ZIS *

FALU (Fancy ALU) is a **custom-designed Arithmetic Logic Unit** implemented in Verilog with a flexible interface and extended functionality beyond standard ALUs. It supports not only the typical arithmetic and logic operations, but also more advanced functions like population count, approximate log, and even a tiny “sort” operation.

---

## ✨ Features
- **16 operations** controlled by a 4-bit `opcode`
- **Inputs**: two 8-bit operands (`a`, `b`) depending on operation
- **Output**: 16-bit result
- **Custom serial I/O protocol** (write 20 bits: `opcode[3:0] + a[7:0] + b[7:0]`, read 16 bits result)
- **Synthesizable** for FPGA implementation
- **Cocotb testbench** for simulation and verification

---

## 🔢 Supported Operations

| Done? | Opcode | Operation                  | Notes |
|:-----:|:------:|:---------------------------|:------|
| ✅     | 0000   | ADD                        | `a + b` |
| ✅     | 0001   | SUB                        | `a - b` |
| ✅     | 0010   | AND                        | `a & b` |
| ✅     | 0011   | OR                         | `a \| b` |
| ✅     | 0100   | XOR                        | `a ^ b` |
| ✅     | 0101   | NAND                       | `~(a & b)` |
| ✅     | 0110   | NOR                        | `~(a \| b)` |
| ✅     | 0111   | XNOR                       | `~(a ^ b)` |
| ✅     | 1000   | CLZ(x)                     | Count leading zeros |
| ✅     | 1001   | MAC                        | Multiply–Accumulate |
| ✅     | 1010   | Sort(x)                    | Sort bits/bytes (impl-specific) |
| ✅     | 1011   | Approximate log(x)         | Fast log estimation |
| ✅     | 1100   | CTZ(x)                     | Count trailing zeros |
| ✅     | 1101   | Division(x)                | Integer division |
| ✅     | 1110   | Multiplication(x)          | `a * b` |
| ✅     | 1111   | Hamming Distance/Weight(x) | Bit population count |

---

## 🛠️ Simulation

### Prerequisites
- [Python 3.8+](https://www.python.org/)
- [Cocotb](https://www.cocotb.org/)
- [Verilator](https://www.veripool.org/verilator/)

## 📡 Interfacing

### Custom Serial Protocol
- **Write (20 bits)**: `[opcode(4), a(8), b(8)]`
- **Read (16 bits)**: `result[15:0]`
- Driven by `scl` clock input
- `start` + `w_r` signals control read/write direction


\* FAUzL - Z Is Silent 