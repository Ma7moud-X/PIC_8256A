module ISR (
		input wire [7:0] ISR,// from resolver
		input wire ISR_reset, // from control to set CUR = 0
		input wire [2:0]ISR_DONE, // after the second INTA duing AEOI
		input wire [2:0] n, // from resolver to handel the rotating
		input wire [2:0] rotate, // from control logic
		
		output reg  [2:0]ISR_Control, // to control logic
		output reg  [7:0] ISR_cur // to control for reading
);

  integer Done,shift,R;
  parameter ROTATE_NON_SPECIFIC_EOI = 3'b101,
			ROTATE_AEOI_SET = 3'b100,
			ROTATE_AEOI_CLEAR = 3'b111;
  
  // if in rotate there is some state that we will not set it you need to handel it
  always @(ISR_DONE) begin
		// if ROTATE_AEOI_SET : don't clear it
		Done = ISR_DONE;
		if( !R || !(rotate == ROTATE_AEOI_SET)) 
			ISR_cur = ISR_cur & (~ (1 << Done)); 

   end
  
  always @(ISR_reset) begin
			if(ISR_reset) begin
			   ISR_cur = 8'b0;
			   ISR_Control = 7;
			   shift = 0;
			   R = 0;
			end
	end
	always @(rotate) begin
		if(rotate == ROTATE_NON_SPECIFIC_EOI || rotate == ROTATE_AEOI_SET || rotate == ROTATE_AEOI_CLEAR)
			R=1;
		else 
			R= 0;
	end
	
	always@(n)begin
	    shift = n;
	  end
	
  always @(ISR) begin
	ISR_cur = ISR_cur | ISR;
  end
  
  always @*begin
    if (ISR_cur[(0+shift)%8]) ISR_Control = ((0+shift)%8); 
    else if (ISR_cur[(1+shift)%8]) ISR_Control = ((1+shift)%8); 
    else if (ISR_cur[(2+shift)%8]) ISR_Control = ((2+shift)%8); 
    else if (ISR_cur[(3+shift)%8]) ISR_Control = ((3+shift)%8); 
    else if (ISR_cur[(4+shift)%8]) ISR_Control = ((4+shift)%8); 
    else if (ISR_cur[(5+shift)%8]) ISR_Control = ((5+shift)%8); 
    else if (ISR_cur[(6+shift)%8]) ISR_Control = ((6+shift)%8);
    else ISR_Control = ((7+shift)%8);
  end
endmodule 