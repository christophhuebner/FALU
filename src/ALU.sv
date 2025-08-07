module ALU (
    input wire signed [15:0] data_in, // First operand
    input wire signed [3:0] op,   // Operation selector
    output reg signed [15:0] result,
    output wire              zero, // Zero flag
    output wire              busy
);
    



    wire [3:0] clz_count;

    clz8 clz_inst (
                .data_in(data_in[15:8]),
                .count(clz_count[3:0])
            );

    wire [3:0] ctz_count;
    
    ctz8 ctz_inst (
                .data_in(data_in[15:8]),
                .count(ctz_count[3:0])
            );
    // ALU logic implementation here

    always_comb begin : ALU_ops
    
        zero = 0;
        case(op)

        //mac
        4'b1001:
        result = data_in[15:12] * data_in[11:8] + {8'b0, data_in[7:0]};
        //sort
        4'b1010:
        if (data_in[15:8] < data_in[7:0]) begin
            result = {data_in[7:0], data_in[15:8]};
        end else  begin
            result = data_in;
        end
        //hd/hw
        4'b1111: 
        result =16'b0 + ((data_in[15] ^ data_in[7]) +
                (data_in[14] ^ data_in[6]) +
                (data_in[13] ^ data_in[5]) +
                (data_in[12] ^ data_in[4]) +
                (data_in[11] ^ data_in[3]) +
                (data_in[10] ^ data_in[2]) +
                (data_in[9]  ^ data_in[1]) +
                (data_in[8]  ^ data_in[0]));

        //ADD 
        4'b0000:
            result = $signed(data_in[7:0]) + $signed(data_in[15:8]);

        //SUB
        4'b0001:
            result = $signed(data_in[7:0]) - $signed(data_in[15:8]);

        //AND
        4'b0010:
            result = {8'b0, data_in[7:0] & data_in[15:8]};
        //OR
        4'b0011:
            result = {8'b0, data_in[7:0] | data_in[15:8]};

        //XOR
        4'b0100:
            result = {8'b0, data_in[7:0] ^ data_in[15:8]};

        //NAND
        4'b0101:
           result = {8'b0, ~(data_in[7:0] & data_in[15:8])};

        //NOR
        4'b0110:
            result = {8'b0, ~(data_in[7:0] | data_in[15:8])};
        //XNOR
        4'b0111:
            result = {8'b0, ~(data_in[7:0] ^ data_in[15:8])};

        //CLZ
        4'b1000: 
            result = { 12'b0, clz_count};
        //CTZ
        4'b1100:
            result = { 12'b0, ctz_count};
        //Mult
        4'b1110:
        result = $signed(data_in[15:8]) * $signed(data_in[7:0]);

        //Div
        4'b1101: begin
            if (data_in[7:0] != 0) begin
                result = $signed(data_in[15:8]) / $signed(data_in[7:0]);
            end else begin
                result = 16'hFFFF; // Division by zero, return max value
            end
        end

        //
        default:
        result = 0;
    
        endcase
        if (result == 0) begin
            zero = 1;
        end
    end


endmodule


module clz8(
    input wire  [7:0] data_in,
    output reg  [3:0] count
);
    always_comb begin
        casez (data_in)
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


module ctz8(
    input wire  [7:0] data_in,
    output reg  [3:0] count
);
    always_comb begin
        casez (data_in)
            8'b???????1: count = 0;
            8'b??????10: count = 1;
            8'b?????100: count = 2;
            8'b????1000: count = 3;
            8'b???10000: count = 4;
            8'b??100000: count = 5;
            8'b?1000000: count = 6;
            8'b10000000: count = 7;
            8'b00000000: count = 8;
            default:     count = 0;
        endcase
    end
endmodule