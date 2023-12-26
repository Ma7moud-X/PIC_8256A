



module ISR (
		input wire [7:0] ISR,// from resolver
		input wire ISR_reset, // from control to set CUR = 0
		input wire ISR_DONE, // after the second INTA duing AEOI
		input wire n, // from resolver to handel the rotating
		input wire [2:0] rotate, // from control logic
		
		
		output reg  ISR_Control // to control logic
);
  reg [7:0]ISR_cur;
  parameter ROTATE_NON_SPECIFIC_EOI = 3'b101,
			ROTATE_AEOI_SET = 3'b100,
			ROTATE_AEOI_CLEAR = 3'b111;
  
  // if in rotate there is some state that we will not set it you need to handel it
  always @(ISR_DONE) begin
	
	// if ROTATE_AEOI_SET : don't clear it
   if( rotate == ROTATE_NON_SPECIFIC_EOI || rotate == ROTATE_AEOI_CLEAR) 
    ISR_cur = ISR_cur & (~ (1 << ISR_DONE)); 
   end
  
  always @(ISR_reset) begin
			if(ISR_reset) begin
			   ISR_cur = 8'b0;
			   ISR_Control = 7;
			end
	end
	
  always @(ISR)begin
    ISR_cur = ISR_cur | ISR;
    if (ISR_cur[(0+n)%8]) ISR_Control = ((0+n)%8); 
    else if (ISR_cur[(1+n)%8]) ISR_Control = ((1+n)%8); 
    else if (ISR_cur[(2+n)%8]) ISR_Control = ((2+n)%8); 
    else if (ISR_cur[(3+n)%8]) ISR_Control = ((3+n)%8); 
    else if (ISR_cur[(4+n)%8]) ISR_Control = ((4+n)%8); 
    else if (ISR_cur[(5+n)%8]) ISR_Control = ((5+n)%8); 
    else if (ISR_cur[(6+n)%8]) ISR_Control = ((6+n)%8);
    else ISR_Control = ((7+n)%8);
  end
endmodule 



