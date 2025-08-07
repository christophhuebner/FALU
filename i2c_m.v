module i2c_m_controller(
	input wire clk,
	input wire rst,
	input op,
	input wire [7:0] data_in,
	input wire enable,
	output wire rw,

	output reg [7:0] data_out,
	output wire ready,
    output wire start,

	input i2c_sda_i,
    output i2c_sda_o,
	output wire i2c_scl
	);

	localparam IDLE = 0;
	localparam START = 1;
	localparam ADDRESS = 2;
	localparam READ_ACK = 3;
	localparam WRITE_DATA = 4;
	localparam WRITE_ACK = 5;
	localparam READ_DATA = 6;
	localparam READ_ACK2 = 7;
	localparam STOP = 8;
	
	localparam DIVIDE_BY = 4;

	reg [7:0] state;
	reg [7:0] saved_data;
	reg [7:0] counter;
	reg [7:0] counter2 = 0;
	reg write_enable;
	reg i2c_clk = 1;

	assign ready = ((rst == 0) && (state == IDLE)) ? 1 : 0;
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
			state <= IDLE;
            counter <= 0;
		end		
		else begin
			case(state)
			
				IDLE: begin
					if (enable) begin
						state <= START;
						saved_data <= data_in;
					end
					else state <= IDLE;
				end

				START: begin
					state <= 3;
                    start <= 1;
				end

				3: begin
					if (i2c_sda == 0) begin
						if(op == 0) begin 
                            counter <= 19;
                            state <= WRITE_DATA; 
                            rw <= 0;
                            end
						else begin 
                            counter <= 15;
                            state <= READ_DATA; 
                            rw <= 1;
                            end
					end else state <= STOP;
				end

				WRITE_DATA: begin
					if(counter == 0) begin
						state <= STOP;
                    end else begin 
                        counter <= counter - 1;
                        i2c_sda_o <= saved_data[counter];
                    end
				end
				


				READ_DATA: begin
					data_out[counter] <= i2c_sda_i;
					if (counter == 0) state <= STOP;
					else counter <= counter - 1;
				end
				

				STOP: begin
					state <= IDLE;
                    start <= 0;

				end
			endcase
		end
	end

endmodule