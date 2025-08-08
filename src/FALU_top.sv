
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
    reg signed [15:0] result;
    reg zero;
    reg busy;
    wire signed [15:0] data_in;
    wire signed [3:0] op;
    reg divide;
    wire signed [7:0] dividend;
    wire signed [7:0] divisor;
    wire signed [7:0] quotient;
    wire signed [7:0] remainder;
    wire division_done;
    wire division_busy;

    ALU alu_inst (
        .data_in(data_in),
        .op(op),
        .result(result),
        .zero(zero),            // Connect to appropriate output
        .busy(busy)             // Connect to appropriate output
    );

    I2C_Controller i2c_inst (
        .scl(i2c_clk),
        .sda_i(i2c_sda_i),
        .sda_o(i2c_sda_o),
        .reset(reset),
        .data_out(data_in),
        .op(op),
        .result(result),
        .start(start),
        .w_r(wr)
    );

    divu_int div_inst (
        .clk(clk),
        .rst(reset),
        .start(divide), // Start division if operation is 'Div'
        .busy(division_busy),
        .done(division_done),
        .valid(),
        .dbz(),
        .a(dividend), // Dividend
        .b(divisor),  // Divisor
        .val(quotient),      // Quotient
        .rem(remainder)             // Remainder (not used here)
    );
    
    always @(posedge clk) begin
        if (!reset) begin
            result <= 0;
            zero <= 0;
        end else begin
           //does FALU need to do something here?
            if(op==4'b1101 | division_busy)begin
                divide <= 1; // Set divide flag for division operation
                divisor_abs = data_in[7] ? -data_in[7:0] : data_in[7:0];
                dividend_abs = data_in[15] ? -data_in[15:8] : data_in[15:8];
                if (division_done) begin
                    divide <= 0; 
                    result[7:0] <= quotient;
                    result[15:8] <= remainder;
                    result[7:0] <= (data_in[7] ^ data_in[15]) ? -quotient : quotient;
                    result[15:8] <= data_in[15] ? -remainder : remainder;
                end
        end
    end
    end


endmodule
