module FALU_top # (
)(
    input wire clk,
    input wire reset,
    input wire start,
    input wire wr,
    input wire i2c_clk,
    input wire i2c_sda_i,
    output wire i2c_sda_o
);

    // Top-level registers for final outputs
    reg  signed [15:0] result;
    reg                zero;

    reg                busy;
    wire signed [15:0] data_in;
    wire signed [3:0]  op;

    reg                divide;
    reg  signed [7:0]  dividend;
    reg  signed [7:0]  divisor;
    wire signed [7:0]  quotient;
    wire signed [7:0]  remainder;
    wire               division_done;
    wire               division_busy;

    // ALU output wires
    wire signed [15:0] alu_result;
    wire               alu_zero;

    ALU alu_inst (
        .data_in(data_in),
        .op(op),
        .result(alu_result),
        .zero(alu_zero),
        .busy(busy)
    );

    I2C_Controller i2c_inst (
        .scl(i2c_clk),
        .sda_i(i2c_sda_i),
        .sda_o(i2c_sda_o),
        .reset(reset),
        .data_out(data_in),
        .op(op),
        .result(result), // top-level result is sent to I2C
        .start(start),
        .w_r(wr)
    );

    divu_int div_inst (
        .clk(clk),
        .rst(reset),
        .start(divide),
        .busy(division_busy),
        .done(division_done),
        .valid(),
        .dbz(),
        .a(dividend),
        .b(divisor),
        .val(quotient),
        .rem(remainder)
    );
    
    always @(posedge clk) begin
        if (!reset) begin
            result <= 0;
            zero   <= 0;
            divide <= 0;
        end else begin
            if (op == 4'b1101) begin
                // Division operation
                divide   <= 1;
                divisor  <= data_in[7]  ? -data_in[7:0]   : data_in[7:0];
                dividend <= data_in[15] ? -data_in[15:8]  : data_in[15:8];

                if (division_done) begin
                    divide <= 0;
                    result[7:0]   <= (data_in[7] ^ data_in[15]) ? -quotient : quotient;
                    result[15:8]  <= data_in[15] ? -remainder : remainder;
                    zero          <= (quotient == 0);
                end
            end else begin
                // Normal ALU operation
                result <= alu_result;
                zero   <= alu_zero;
                divide <= 0;
            end
        end
    end

endmodule
