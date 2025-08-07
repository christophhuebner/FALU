`include "ALU.sv"
`include "i2c.sv"

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
    
    ALU alu_inst (
        .data_in(data_in),
        .op(op),
        .result(result),
        .zero(zero),            // Connect to appropriate output
        .busy(busy)             // Connect to appropriate output
    );

    I2C_Controller i2c_inst (
        .scl(i2c_clk),
        .sda(i2c_sda),
        .reset(reset),
        .data_in(data_in),
        .op(op)
    );
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
