// SPDX-FileCopyrightText: © 2025 XXX Authors
// SPDX-License-Identifier: Apache-2.0

// Adapted from the Tiny Tapeout template

`default_nettype none

module heichips25_template (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
assign uo_out[7:1] = 7'b00000000; // Initialize outputs to zero
assign uio_oe = 8'b00000000; // Disable all IOs
assign uio_out = 8'b00000000; // Initialize IO outputs to zero
FALU_top falutop (
    .clk(clk),
    .reset(~rst_n),  // Active low reset
    .start(ui_in[0]),  // Start signal from ui_in[0]
    .wr(ui_in[1]),     // Write signal from ui_in[1]
    .i2c_clk(ui_in[2]),  // I2C clock input
    .i2c_sda_i(ui_in[3]), // I2C data input
    .i2c_sda_o(uo_out[0]) // I2C data output
);


endmodule
module FALU_top(
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
    reg [15:0] alu_data_in;
    reg [3:0] alu_op;
    ALU alu_inst (
        .data_in(alu_data_in),
        .op(alu_op),
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
        if (reset) begin
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
                alu_data_in <= data_in;
                alu_op      <= op;
                result <= alu_result;
                zero   <= alu_zero;
                divide <= 0;
            end
        end
    end

endmodule
module ALU (
    input wire signed [15:0] data_in,  // First operand
    input wire [3:0] op,  // Operation selector
    output reg signed [15:0] result,
    output reg zero,  // Zero flag
    output wire busy
);

  typedef enum logic [3:0] {
    OP_ADD     = 4'b0000,  // 0
    OP_SUB     = 4'b0001,  // 1
    OP_AND     = 4'b0010,  // 2
    OP_OR      = 4'b0011,  // 3
    OP_XOR     = 4'b0100,  // 4
    OP_NAND    = 4'b0101,  // 5
    OP_NOR     = 4'b0110,  // 6
    OP_XNOR    = 4'b0111,  // 7
    OP_CLZ     = 4'b1000,  // 8
    OP_MAC     = 4'b1001,  // 9
    OP_SORT    = 4'b1010,  // 10
    OP_LOG     = 4'b1011,  // 11
    OP_CTZ     = 4'b1100,  // 12
    OP_DIV     = 4'b1101,  // 13
    OP_MUL     = 4'b1110,  // 14
    OP_HAMMING = 4'b1111   // 15
  } alu_op_t;

  alu_op_t op_sel;

  wire [3:0] clz_count;
  wire [3:0] ctz_count;

  clz8 clz_inst (
      .data_in(data_in[15:8]),
      .count  (clz_count[3:0])
  );

  ctz8 ctz_inst (
      .data_in(data_in[15:8]),
      .count  (ctz_count[3:0])
  );

  wire [7:0] log_approx;

  logarithm_approx log_inst (
      .a(data_in[15:8]),
      .log_approx(log_approx)
  );

  // ALU logic implementation here

  always_comb begin : ALU_ops

    zero   <= '0;
    result = '0;
    op_sel = alu_op_t'(op);

    case (op_sel)

      //MAC operation
      OP_MAC: result = data_in[15:12] * data_in[11:8] + {8'b0, data_in[7:0]};

      //Sorting Operation
      OP_SORT: result = data_in[15:8] < data_in[7:0] ? {data_in[7:0], data_in[15:8]} : data_in;

      //Hamming distance
      OP_HAMMING:
      result = 16'b0 + (
                        (data_in[15] ^ data_in[7]) +
                        (data_in[14] ^ data_in[6]) +
                        (data_in[13] ^ data_in[5]) +
                        (data_in[12] ^ data_in[4]) +
                        (data_in[11] ^ data_in[3]) +
                        (data_in[10] ^ data_in[2]) +
                        (data_in[9]  ^ data_in[1]) +
                        (data_in[8]  ^ data_in[0])
                        );

      //ADD 
      OP_ADD: result = $signed(data_in[7:0]) + $signed(data_in[15:8]);

      //SUB
      OP_SUB: result = $signed(data_in[7:0]) - $signed(data_in[15:8]);

      //AND
      OP_AND: result = {8'b0, data_in[7:0] & data_in[15:8]};

      //OR
      OP_OR: result = {8'b0, data_in[7:0] | data_in[15:8]};

      //XOR
      OP_XOR: result = {8'b0, data_in[7:0] ^ data_in[15:8]};

      //NAND
      OP_NAND: result = {8'b0, ~(data_in[7:0] & data_in[15:8])};

      //NOR
      OP_NOR: result = {8'b0, ~(data_in[7:0] | data_in[15:8])};

      //XNOR
      OP_XNOR: result = {8'b0, ~(data_in[7:0] ^ data_in[15:8])};

      //CLZ
      OP_CLZ: result = {12'b0, clz_count};

      //CTZ
      OP_CTZ: result = {12'b0, ctz_count};

      //Multiplication
      OP_MUL: result = $signed(data_in[15:8]) * $signed(data_in[7:0]);

      // Approx Logarithm
      OP_LOG: result = {8'b0, log_approx};


      //Default
      default: result = 0;

    endcase  // op_sel

    if (result == 0) begin
      zero <= 1;
    end

  end  // ALU_Ops


endmodule


module clz8 (
    input  wire [7:0] data_in,
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


module ctz8 (
    input  wire [7:0] data_in,
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


module lod8 (
    input  wire [7:0] data_in,
    output reg  [2:0] count
);
  always_comb begin
    casez (data_in)
      8'b1???????: count = 7;  // Leading 1 at bit 7
      8'b01??????: count = 6;  // Leading 1 at bit 6
      8'b001?????: count = 5;
      8'b0001????: count = 4;
      8'b00001???: count = 3;
      8'b000001??: count = 2;
      8'b0000001?: count = 1;
      8'b00000001: count = 0;  // Leading 1 at bit 0 (LSB)
      8'b00000000: count = 8;  // No bits set
      default:     count = 8;  // fallback
    endcase
  end
endmodule



module logarithm_approx (
    input  wire [7:0] a,
    output reg  [7:0] log_approx  // 4 integer bits + 4 fractional bits fixed point
);

  // Position of leading one (0 to 7)
  reg [3:0] position;

  lod8 leadingone (
      .data_in(a),
      .count  (position)
  );

  logic [7:0] shifted;
  logic [3:0] frac;

  always_comb begin
    // Default assignments (prevents latches)
    shifted = 0;
    frac = 0;
    log_approx = 0;

    if (a != 0) begin
      shifted = a << (7 - position);
      frac = shifted[6:3];
      log_approx = (position << 4) + frac;
    end
  end
endmodule
module divu_int ( 
    input wire logic clk,              // clock
    input wire logic rst,              // reset
    input wire logic start,            // start calculation
    output     logic busy,             // calculation in progress
    output     logic done,             // calculation is complete (high for one tick)
    output     logic valid,            // result is valid
    output     logic dbz,              // divide by zero
    input wire logic [7:0] a,    // dividend (numerator)
    input wire logic [7:0] b,    // divisor (denominator)
    output     logic [7:0] val,  // result value: quotient
    output     logic [7:0] rem   // result: remainder
    );

    logic [7:0] b1;             // copy of divisor
    logic [7:0] quo, quo_next;  // intermediate quotient
    logic [8:0] acc, acc_next;    // accumulator (1 bit wider)
    logic [$clog2(8)-1:0] i;      // iteration counter

    // division algorithm iteration
    always_comb begin
        if (acc >= {1'b0, b1}) begin
            acc_next = acc - b1;
            {acc_next, quo_next} = {acc_next[7:0], quo, 1'b1};
        end  else begin
            {acc_next, quo_next} = {acc, quo} << 1;
        end
    end

    // calculation control
    always_ff @(posedge clk) begin
        done <= 0;
        if (start) begin
            valid <= 0;
            i <= 0;
            if (b == 0) begin  // catch divide by zero
                busy <= 0;
                done <= 1;
                dbz <= 1;
            end else begin
                busy <= 1;
                dbz <= 0;
                b1 <= b;
                {acc, quo} <= {{8{1'b0}}, a, 1'b0};  // initialize calculation
            end
        end else if (busy) begin
            if (i == 7) begin  // we're done
                busy <= 0;
                done <= 1;
                valid <= 1;
                val <= quo_next;
                rem <= acc_next[8:1];  // undo final shift
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
module I2C_Controller (
    input  wire scl,
    input  wire sda_i,
    input wire reset,
    input reg [15:0] result,
    input wire start,
    input wire w_r,
    output reg [15:0] data_out, 
    output  reg [3:0]  op,
	output  reg sda_o
);
	
	reg [4:0] counter;
    reg [1:0] state = 0;
	reg [19:0] data_in = 0;
   

	always @(posedge scl) begin
		if (reset == 1) begin
			state <= 0;
			counter <= 0;
			data_in <= 0;
		end else begin
			case(state)			
				0: begin
                  if (start == 1) begin
                    if(w_r == 0) begin
                        counter <= 19; 
                        state <= 1;
                    end
                    else begin
                        counter <= 16;
                    state <= 2;
                    end
                  end
				end
				1: begin
					data_in[counter] <= sda_i;
					if(counter == 0) begin
						state <= 3;
					end else counter <= counter - 1;
				end
				2: begin
					if(counter == 0) state <= 0;
					else begin 
                    sda_o <= result[counter-1];
					counter <= counter - 1;
                end	
                end
                  3: begin
					state <= 0;	
                   op <= data_in[19:16];
                    data_out <= data_in[15:0];
            	end				
			endcase
		end
	end
endmodule
