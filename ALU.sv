module ALU #(
    parameter WIDTH = 8
)(
    input wire [(WIDTH*2)-1:0] in, // First operand
    input  wire [3:0]       op,   // Operation selector
    output reg  [(WIDTH*2)-1:0] result,
    output reg              zero, // Zero flag
    output reg              carry, // Carry flag
    output reg              busy
);

    // ALU logic implementation here
    always_comb begin : ALU_ops
        case(op)
        //ADD 
        4'b0000: result = in[WIDTH-1:0] + in[(WIDTH*2)-1:WIDTH];
        //SUB
        4'b0001: result = in[WIDTH-1:0] - in[(WIDTH*2)-1:WIDTH];
        //AND
        4'b0010: result = in[WIDTH-1:0] & in[(WIDTH*2)-1:WIDTH];
        //OR
        4'b0011: result = in[WIDTH-1:0] | in[(WIDTH*2)-1:WIDTH];

        //XOR
        4'b0100: result = in[WIDTH-1:0] ^ in[(WIDTH*2)-1:WIDTH];

        //NAND
        4'b0101: result = ~(in[WIDTH-1:0] & in[(WIDTH*2)-1:WIDTH]);
        //NOR
        4'b0110: result = ~(in[WIDTH-1:0] | in[(WIDTH*2)-1:WIDTH]);
        //XNOR
        4'b0111: result = ~(in[WIDTH-1:0] ^ in[(WIDTH*2)-1:WIDTH]);

        //CLZ
        4'b1000: begin
            integer i;
            result = 0;
            for (i = 0; i < WIDTH; i = i + 1) begin
                if (in[WIDTH-1-i] == 1'b0) begin
                    result = result + 1;
                end else begin
                    break;
                end
            end
        end


        
        default: result = 0;
    endcase
    end
    if
endmodule

