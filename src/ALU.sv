module ALU (
    input wire signed [15:0] data_in,  // First operand
    input wire [3:0] op,  // Operation selector
    output reg signed [15:0] result,
    output wire zero,  // Zero flag
    output wire busy
);

  typedef enum logic [3:0] {
    OP_ADD   = 4'b0000,
    OP_SUB   = 4'b0001,
    OP_AND   = 4'b0010,
    OP_OR    = 4'b0011,
    OP_XOR   = 4'b0100,
    OP_NAND  = 4'b0101,
    OP_NOR   = 4'b0110,
    OP_XNOR  = 4'b0111,
    OP_CLZ   = 4'b1000,
    OP_MAC   = 4'b1001,
    OP_SORT  = 4'b1010,
    OP_DIV   = 4'b1101,
    OP_CTZ   = 4'b1100,
    OP_MUL   = 4'b1110,
    OP_HAMMING = 4'b1111
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
  // ALU logic implementation here

  always_comb begin : ALU_ops

    zero   = '0;
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

      //Default
      default: result = 0;

    endcase  // op_sel

    if (result == 0) begin
      zero = 1;
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
