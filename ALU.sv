module ALU (
    input wire [15:0] data_in, // First operand
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
    zero = 0;
        case(op)

        //mac
        4'b1001:
        {carry,result} = data_in[15:12] * data_in[11:8] + {8'b0, data_in[7:0]};
        //sort
        4'b1010:
        if (data_in[15:8] < data_in[7:0]) begin
            result = {data_in[7:0], data_in[15:8]};
        end else  begin
            result = data_in;
        end
        //hd/hw
        4'b1111: 
        result = data_in[15] & data_in[7] + data_in[14] & data_in[6] + data_in[13] & data_in[5] + data_in[12] & data_in[4] + data_in[11] & data_in[3] + data_in[10] & data_in[2] + data_in[9] & data_in[1] + data_in[8] & data_in[0];


        //ADD 
        4'b0000:
            result = data_in[7:0] + data_in[15:8];
        //SUB
        4'b0001:
            result = data_in[7:0] - data_in[15:8];
        //AND
        4'b0010:
            result = data_in[7:0] & data_in[15:8];
        //OR
        4'b0011:
            result = data_in[7:0] | data_in[15:8];

        //XOR
        4'b0100:
            result = data_in[7:0] ^ data_in[15:8];

        //NAND
        4'b0101:
            result = ~(data_in[7:0] & data_in[15:8]);
        //NOR
        4'b0110:
            result = ~(data_in[7:0] | data_in[15:8]);
        //XNOR
        4'b0111:
            result = ~(data_in[7:0] ^ data_in[15:8]);

        //CLZ
        4'b1000: begin
            integer i;
            result = 0;
            for (i = 0; i < 8; i = i + 1) begin
                if (in[7-i] == 1'b0) begin
                    result = result + 1;
                end else begin
                    break;
                end
            end
        end

        default:
        result = 0;
    
        endcase
        if (result == 0 & carry ==0) begin
            zero = 1;
        end
    end


endmodule