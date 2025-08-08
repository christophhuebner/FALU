module I2C_Controller (
    input  wire scl,
    input  wire sda_i,
    input reset,
    input[15:0] result,
    input start,
    input w_r,
    output reg [15:0] data_out, 
    output  reg [3:0]  op,
	output  wire sda_o,
);
	
	reg [4:0] counter;
    reg [1:0] state = 0;
	reg [19:0] data_in = 0;
   
	
	always @(posedge scl) begin
		if (reset ==1) begin
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
                        counter <= 15;
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
					else begin counter <= counter - 1;
                    sda_o <= result[counter];
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
