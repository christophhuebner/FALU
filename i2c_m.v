module i2c_m_controller(
	input wire clk,
	input wire rst,
	input op,
	input wire [15:0] data_in,
    input wire [3:0] op_code,
	input wire enable,
	output wire rw,

	output reg [19:0] data_out,
	output wire ready,
    output wire start,

	input i2c_sda_i,
    output i2c_sda_o,
	output wire i2c_scl
	);


	localparam DIVIDE_BY = 4;

  reg [3:0] state = 0;
	reg [19:0] saved_data;
	reg [4:0] counter;
	reg [7:0] counter2 = 0;
	reg i2c_clk = 1;

	assign ready = ((rst == 0) && (state == 0)) ? 1 : 0;
    assign i2c_scl = i2c_clk;
	
	always @(posedge clk) begin
		if (counter2 == (DIVIDE_BY/2) - 1) begin
			i2c_clk <= ~i2c_clk;
			counter2 <= 0;
		end
		else counter2 <= counter2 + 1;
	end 
	
	always @(posedge i2c_clk, posedge rst) begin
		if(rst == 1) begin
			state <= 0;
            counter <= 0;
            start <= 0;
		end		
		else begin
			case(state)
				0: begin
					if (enable) begin
						state <= 1;
						saved_data <= {op_code,data_in};
                        rw <= op;
					end
					else state <= 0;
				end

				1: begin
					state <= 2;
                    start <= 1;
				end

				2: begin
						if(op == 0) begin 
                            counter <= 19;
                            state <= 3; 
                            end
						else begin 
                            counter <= 15;
                            state <= 4; 
                            end
				end

				3: begin
					if(counter == 0) begin
						state <= 5;
                    end else begin 
                        i2c_sda_o <= saved_data[counter];
                        counter <= counter - 1;
                    end
				end
				
				4: begin
					data_out[counter] <= i2c_sda_i;
					if (counter == 0) state <= 5;
					else counter <= counter - 1;
				end
				

				5: begin
					state <= 0;
                    start <= 0;

				end
                default: state <= 0;
			endcase
		end
	end

endmodule