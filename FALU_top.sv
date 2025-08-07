module FALU_top # (
    parameter WIDTH = 8
)(
    

);


    ALU #(

        .WIDTH(WIDTH)

    ) alu_inst (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .zero(zero),
        .carry(carry)
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
