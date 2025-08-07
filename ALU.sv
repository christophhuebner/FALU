module ALU #(

)(
    input wire [15:0] in, // First operand
    input  wire [3:0]       op,   // Operation selector
    output reg  [15:0] result,
    output reg              zero, // Zero flag
    output reg              carry, // Carry flag
    output reg              busy
);
    integer i;

    // ALU logic implementation here
    always_comb begin : ALU_ops
    carry = 0;
    i = 0;
        case(op)

        //mac
        4'b1001:
        {carry,result} = in[15:12] * in[11:8] + in[7:0];
        //sort
        4'b1010:
        //hd/hw
        4'b1111: 
        result = in[15] & in[7] + in[14] & in[6] + in[13] & in[5] + in[12] & in[4] + in[11] & in[3] + in[10] & in[2] + in[9] & in[1] + in[8] & in[0];
        default: result = 0;

    endcase
    end
endmodule

