

module ISR (
		input wire [7:0] ISR,// from resolver
		input wire ISR_reset, // from control to set CUR = 0
		input wire [2:0]ISR_DONE, // after the second INTA duing AEOI
		input wire [2:0] n, // from resolver to handel the rotating
		input wire [2:0] rotate, // from control logic
		
		output reg  [2:0]ISR_Control, // to control logic and to Cascade
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

 

module ISR_tb();

	// input
	reg [7:0] ISR;
	reg ISR_reset;
	reg [2:0] ISR_DONE;
	reg [2:0] n;
	reg [2:0] rotate;

	// output
	wire [7:0] ISR_cur;
	wire [2:0] ISR_Control;
	
ISR test (
		// input
		.ISR(ISR),
		.ISR_reset(ISR_reset),
		.ISR_DONE(ISR_DONE),
		.n(n),
		.rotate(rotate),
		// output
		.ISR_cur(ISR_cur),
		.ISR_Control(ISR_Control)
);



initial begin
    ISR_reset = 1'b1;
	ISR = 8'b0;
    #1000; // 1 nano
    
	// MASKING IRR
    ISR_reset = 1'b0;
	ISR = 8'b00000110;
	n = 3'b000;
    #1000;
        
	// Second INTA
	ISR_DONE = 3'b001;
    #1000;
    
	
	// Rotate
	ISR = 8'b00011100;
	n = 3'b011;
	rotate = 3'b100;
    #1000;
       
	// Don't clear
	ISR_DONE = 3'b011;
	n = 3'b100;
    #1000;

    $finish;
end

initial begin
    $monitor("Time: %t, ISR_reset: %b,    ISR: %b %b %b %b %b %b %b %b,    ISR_DONE: %b %b %b,   N: %b %b %b,   Rotate: %b %b %b,    OUTPUT    ISR_cur: %b %b %b %b %b %b %b %b,    ISR_Control: %b %b %b",
    $time,ISR_reset,ISR[7],ISR[6],ISR[5],ISR[4],ISR[3],ISR[2],ISR[1],ISR[0],ISR_DONE[2],ISR_DONE[1],ISR_DONE[0],n[2],n[1],n[0],rotate[2],rotate[1],rotate[0],
    ISR_cur[7],ISR_cur[6],ISR_cur[5],ISR_cur[4],ISR_cur[3],ISR_cur[2],ISR_cur[1],ISR_cur[0],ISR_Control[2],ISR_Control[1],ISR_Control[0]);

    $timeformat(-9, 1, " ns", 10);
end

endmodule	
	









