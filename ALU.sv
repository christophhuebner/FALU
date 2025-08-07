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
    wire [3:0] clz_count;
    clz8 clz_inst (
                .in(in[15:8]),
                .count(clz_count[3:0])
            );
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


        //ADD 
        4'b0000:
            result = in[16-1:0] + in[(16*2)-1:16];
        //SUB
        4'b0001:
            result = in[16-1:0] - in[(16*2)-1:16];
        //AND
        4'b0010:
            result = in[16-1:0] & in[(16*2)-1:16];
        //OR
        4'b0011:
            result = in[16-1:0] | in[(16*2)-1:16];

        //XOR
        4'b0100:
            result = in[16-1:0] ^ in[(16*2)-1:16];

        //NAND
        4'b0101:
            result = ~(in[16-1:0] & in[(16*2)-1:16]);

        //NOR
        4'b0110:
            result = ~(in[16-1:0] | in[(16*2)-1:16]);
            
        //XNOR
        4'b0111:
            result = ~(in[16-1:0] ^ in[(16*2)-1:16]);

        //CLZ
        4'b1000: 
            result = { 12'b0, clz_count};


        default:
        result = 0;
    
        endcase
    end


endmodule
module clz8(
    input  wire [7:0] in,
    output reg  [3:0] count
);
    always_comb begin
        casez (in)
            8'b1???????: count = 0;
            8'b01??????: count = 1;
            8'b001?????: count = 2;
            8'b0001????: count = 3;
            8'b00001???: count = 4;
            8'b000001??: count = 5;
            8'b0000001?: count = 6;
            8'b00000001: count = 7;
            8'b00000000: count = 8;
            default:     count = 0;
        endcase
    end
endmodule