module divu_int # ( // 8 of numbers in bits
    input wire logic clk,              // clock
    input wire logic rst,              // reset
    input wire logic start,            // start calculation
    output     logic busy,             // calculation in progress
    output     logic done,             // calculation is complete (high for one tick)
    output     logic valid,            // result is valid
    output     logic dbz,              // divide by zero
    input wire logic [8-1:0] a,    // dividend (numerator)
    input wire logic [8-1:0] b,    // divisor (denominator)
    output     logic [8-1:0] val,  // result value: quotient
    output     logic [8-1:0] rem   // result: remainder
    );

    logic [8-1:0] b1;             // copy of divisor
    logic [8-1:0] quo, quo_next;  // intermediate quotient
    logic [8:0] acc, acc_next;    // accumulator (1 bit wider)
    logic [$clog2(8)-1:0] i;      // iteration counter

    reg divisor_sign; 
    reg dividend_sign;
    reg [8-1:0] dividend_abs;
    reg [8-1:0] divisor_abs;
    // division algorithm iteration
    always_comb begin
        if (acc >= {1'b0, b1}) begin
            acc_next = acc - b1;
            {acc_next, quo_next} = {acc_next[8-1:0], quo, 1'b1};
        end else begin
            {acc_next, quo_next} = {acc, quo} << 1;
        end
    end

    // calculation control
    always_ff @(posedge clk) begin
        done <= 0;
        if (start) begin
            divisor_sign <= b[7];
            dividend_sign <= a[7];
            divisor_abs = divisor_sign ? -b : b;
            dividend_abs = dividend_sign ? -a : a;
            valid <= 0;
            i <= 0;
            if (b == 0) begin  // catch divide by zero
                busy <= 0;
                done <= 1;
                dbz <= 1;
            end else begin
                busy <= 1;
                dbz <= 0;
                b1 <= divisor_abs; // use absolute value of divisor for copy
                {acc, quo} <= {{8{1'b0}}, dividend_abs, 1'b0};  // initialize calculation
            end
        end else if (busy) begin
            if (i == 8-1) begin  // we're done
                busy <= 0;
                done <= 1;
                valid <= 1;
                val <= quo_next;
                rem <= acc_next[8:1];  // undo final shift
                val <= (reg_divisor_sign ^ reg_dividend_sign) ? -quo_next : quo_next;
                rem <= reg_divisor_sign ? -acc_next[8:1] : acc_next[8:1];
            end else begin  // next iteration
                i <= i + 1;
                acc <= acc_next;
                quo <= quo_next;
            end
        end
        if (rst) begin
            busy <= 0;
            done <= 0;
            valid <= 0;
            dbz <= 0;
            val <= 0;
            rem <= 0;
        end
    end
endmodule