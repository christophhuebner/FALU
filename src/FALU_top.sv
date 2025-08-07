`include "ALU.sv"
`include "i2c.sv"
`include "divu_int.sv"
module FALU_top # (
)(
    input wire clk,
    input wire reset,
    input wire i2c_clk,
    inout wire i2c_sda
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
    ALU alu_inst (
        .data_IN(data_in),
        .op(op),
        .result(result),
        .zero(zero),            // Connect to appropriate output
        .busy(busy)             // Connect to appropriate output
    );

    I2C_Controller i2c_inst (
        .scl(i2c_clk),
        .sda(i2c_sda),
        .reset(reset),
        .data_out(data_in),
        .op(op)
    );
    divu_int div_inst (
        .clk(clk),
        .rst(reset),
        .start(divide), // Start division if operation is 'Div'
        .busy(),
        .done(),
        .valid(),
        .dbz(),
        .a(dividend), // Dividend
        .b(divisor),  // Divisor
        .val(result),      // Quotient
        .rem()             // Remainder (not used here)
    );
    always @(posedge clk) begin
        if (!reset) begin
            result <= 0;
            zero <= 0;
        end else begin
           //does FALU need to do something here?
               // Perform ALU operations
               alu_inst.data_in <= data_in;
               alu_inst.op <= op;
            if(op==4'b1101)begin
                divide <= 1; // Set divide flag for division operation
                dividend <= data_in[15:8];
                divisor <= data_in[7:0];

        end
    end
    end
    /*
    I2C_Controller i2c_input (
        .clk(clk),
        .data_in(),
        .data_out()
    );

    I2C_Controller i2c_output (
        .clk(clk),
        .data_in(),
        .data_out()
    );

    */


endmodule
