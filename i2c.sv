module I2C_Controller (
    input  wire scl,
    inout  wire sda,
    input reset,
    output wire [15:0] data_in, 
    output  wire [3:0]  op
);

reg state [2:0] = 0;
reg next_state[2:0] = 0;

edge_0 RisingEdgeDetector

always @ (posedge clock)
begin :
if (reset == 1'b1) begin
      state <=  0;
    end else begin
      state <=  next_state;
    end

assign next_state = fsm_function(state, req_0, req_1);
 //----------Function for Combo Logic-----------------
 function [2:0] fsm_function;
   input  [2:0]  state ;	
   input    req_0 ;
   input    req_1 ;
   case(state)
    0 : if (req_0 == 1'b1) begin
                 fsm_function = GNT0;
               end else if (req_1 == 1'b1) begin
                 fsm_function= GNT1;
               end else begin
                 fsm_function = 1;
               end
    1 : if (req_0 == 1'b1) begin
                 fsm_function = GNT0;
               end else begin
                 fsm_function = 1;
               end
    2 : if (req_1 == 1'b1) begin
                 fsm_function = GNT1;
           end else begin
                 fsm_function = 1;
               end
    default : fsm_function = 1;
   endcase
 endfunction
end
   

endmodule


module RisingEdgeDetector (
  input  logic clk,
  input  logic signal,
  output logic edge
);

  logic signalPrev;

  always_ff @(posedge clk) begin
    signalPrev <= signal;
    edge       <= (signal && !signalPrev);
  end

endmodule