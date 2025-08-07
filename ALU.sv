module ALU #(
    parameter WIDTH = 8
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire [3:0]       op,   // Operation selector
    output reg  [(WIDTH*2)-1:0] result,
    output reg              zero, // Zero flag
    output reg              carry, // Carry flag
    output reg              busy
);

    // ALU logic implementation here

endmodule

// ALU operations table
// 0000: ADD
// 0001: SUB
// 0010: AND
// 0011: OR
// 0100: XOR
// 0101: NAND
// 0110: NOR
// 0111: XNOR
