module I2C_Controller (
    input  wire scl,
    inout  wire sda,
    input reset,
    input[15:0] result,
    output wire [15:0] data_out, 
    output  wire [3:0]  op
);

	localparam READ_ADDR = 0;
	localparam SEND_ACK = 1;
	localparam READ_DATA = 2;
	localparam WRITE_DATA = 3;
	localparam SEND_ACK2 = 4;
	
	
	reg [4:0] counter;
	reg [3:0] state = 0;
	reg [19:0] data_in = 0;
	reg sda_out = 0;
	reg sda_in = 0;
	reg start = 0;
	reg write_enable = 0;
   

   assign sda = (write_enable == 1) ? sda_out : 'bz;
	
	always @(negedge sda) begin
		if ((start == 0) && (scl == 1)) begin
			start <= 1;	
			counter <= 7;
		end
	end
	
	always @(posedge sda) begin
		if ((start == 1) && (scl == 1)) begin
			state <= READ_ADDR;
			start <= 0;
			write_enable <= 0;
		end
	end
	
	always @(posedge scl) begin
		if (start == 1) begin
			case(state)
				READ_ADDR: begin
					op <= sda;
					state <= SEND_ACK;					
				end
				
				SEND_ACK: begin
						
						if(op == 0) begin
                            counter <= 19; 
							state <= READ_DATA;
						end
						else begin
                            counter <= 15;
                        state <= WRITE_DATA;
                        end
					
				end
				
				READ_DATA: begin
					data_in[counter] <= sda;
					if(counter == 0) begin
						state <= SEND_ACK2;
					end else counter <= counter - 1;
				end
				
				SEND_ACK2: begin
					state <= READ_ADDR;		
                    op <= data_in[19:16];
                    data_out <= data_in[15:0];

				end
				
				WRITE_DATA: begin
					if(counter == 0) state <= READ_ADDR;
					else counter <= counter - 1;		
				end
				
			endcase
		end
	end
	
	always @(negedge scl) begin
		case(state)
			
			READ_ADDR: begin
				write_enable <= 0;			
			end
			
			SEND_ACK: begin
				sda_out <= 0;
				write_enable <= 1;	
			end
			
			READ_DATA: begin
				write_enable <= 0;
			end
			
			WRITE_DATA: begin
				sda_out <= result[counter];
				write_enable <= 1;
			end
			
			SEND_ACK2: begin
				sda_out <= 0;
				write_enable <= 1;
			end
		endcase
	end

endmodule
