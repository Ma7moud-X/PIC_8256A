module ISR (
		input wire [7:0] ISR,// from resolver
		input wire ISR_reset, // from control to set CUR = 0
		
		output reg  ISR_Control // to control logic
);
  reg [7:0]ISR_cur;


  always @(ISR_reset) begin
			if(ISR_reset) begin
			   ISR_cur = 8'b0;
			   ISR_Control = 7;
			end
	end
	
  always @(ISR)begin
    ISR_cur = ISR_cur | ISR;
    if (ISR_cur[0]) ISR_Control = 1; 
    else if (ISR_cur[1]) ISR_Control = 1; 
    else if (ISR_cur[2]) ISR_Control = 2; 
    else if (ISR_cur[3]) ISR_Control = 3; 
    else if (ISR_cur[4]) ISR_Control = 4; 
    else if (ISR_cur[5]) ISR_Control = 5; 
    else if (ISR_cur[6]) ISR_Control = 6;
    else ISR_Control = 7;
  end
endmodule