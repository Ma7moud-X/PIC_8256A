

module Priority_Resolver (
	input wire IRR_reset,
	input wire[7:0] IRR, // IR0 - IR7 from IRR
	input wire[7:0] IMR, // Mask from IMR
	input wire INTA_1, // from control
	input wire [2:0] Rotate, // from control
	
	output reg [2:0]n, // to ISR & control to handle the rotating
	output reg [7:0] ISR_IRR, // to ISR & to IRR to reset the bit we are handling now
	output reg [7:0] IRR_MASKED // to control
);
      reg [7:0] CUR_ISR;
	  integer highest_priority,shift;

	  // to check if rotate or usual
	  parameter ROTATE_NON_SPECIFIC_EOI = 3'b101,
				ROTATE_AEOI_SET = 3'b100,
				ROTATE_AEOI_CLEAR = 3'b111;
						  
						  
     always @(INTA_1 or CUR_ISR) begin
       if(INTA_1)
          ISR_IRR = CUR_ISR; // @ the first INTA set the corresponding ISR bit, and reset the corresponding IRR bit 
     end 
      
    // return to default priority
    always @(IRR_reset) begin
     if(IRR_reset)begin
		CUR_ISR = 8'b0;
		IRR_MASKED = 8'b0;
		ISR_IRR = 8'b10000000;
		shift = 0;
		n = 0;
     end
    end

	
    always @* begin
	
        IRR_MASKED = IRR& (~IMR); // the one we send to control logic to send to CPU if the CPU want it
        
		// Update highest_priority based on the masked IRR
		
		
        if (IRR_MASKED[(0+shift)%8]) highest_priority = ((0+shift)%8);
        else if (IRR_MASKED[(1+shift)%8]) highest_priority = ((1+shift)%8); 
        else if (IRR_MASKED[(2+shift)%8]) highest_priority = ((2+shift)%8); 
        else if (IRR_MASKED[(3+shift)%8]) highest_priority = ((3+shift)%8); 
        else if (IRR_MASKED[(4+shift)%8]) highest_priority = ((4+shift)%8); 
        else if (IRR_MASKED[(5+shift)%8]) highest_priority = ((5+shift)%8); 
        else if (IRR_MASKED[(6+shift)%8]) highest_priority = ((6+shift)%8); 
        else highest_priority = ((7+shift)%8);

        // Update ISR with highest_priority
        CUR_ISR = (1 << highest_priority);
		
		if(Rotate == ROTATE_AEOI_CLEAR || Rotate == ROTATE_AEOI_SET || Rotate == ROTATE_NON_SPECIFIC_EOI)
			shift = 1 + highest_priority;
		else 
			shift = 0;
		
        n = shift;
			
    end
    
endmodule

module Priority_Resolver_tb();

	reg [7:0]IRR;
	reg [7:0]IMR;
	reg [2:0]Rotate;
	reg IRR_reset;
	reg INTA_1;
	
	wire [7:0] ISR_IRR;
	wire [7:0] IRR_MASKED;
	wire [2:0]n;
	
Priority_Resolver test (
		// input
		.IRR(IRR),
		.IMR(IMR),
		.Rotate(Rotate),
		.IRR_reset(IRR_reset),
		.INTA_1(INTA_1),
		// output
		.ISR_IRR(ISR_IRR),
		.IRR_MASKED(IRR_MASKED),
		.n(n)
);

initial begin
    IRR_reset = 1'b1;
	IRR = 8'b0;
	IMR = 8'b0;
	INTA_1=1'b0;
    #1000; // 1 nano
    
	// MASKING IRR
    IRR_reset = 1'b0;
	IRR = 8'b11110000;
	IMR = 8'b11000000;
    #1000;
        
	// First INTA
	INTA_1 = 1'b1;
	IRR = 8'b11110000;
	IMR = 8'b10000000;
    #1000;
    
	INTA_1 = 1'b0;
    #1000;
       
	// Rotate
	Rotate = 3'b100;
    #1000;
    
    INTA_1 = 1'b1;
    IRR = 8'b01110000;
    #1000;

end

initial begin
    $monitor("Time: %t, reset: %b, INTA_1: %b,    IRR: %b %b %b %b %b %b %b %b,    IMR: %b %b %b %b %b %b %b %b,    Rotate: %b %b %b    OUTPUT   n: %d %d %d,    ISR_IRR: %b %b %b %b %b %b %b %b,    IRR_MASKED: %b %b %b %b %b %b %b %b",
    $time,IRR_reset,INTA_1,IRR[7],IRR[6],IRR[5],IRR[4],IRR[3],IRR[2],IRR[1],IRR[0] ,IMR[7],IMR[6],IMR[5],IMR[4],IMR[3],IMR[2],IMR[1],IMR[0],Rotate[2],Rotate[1],Rotate[0],
    n[2],n[1],n[0],ISR_IRR[7],ISR_IRR[6],ISR_IRR[5],ISR_IRR[4],ISR_IRR[3],ISR_IRR[2],ISR_IRR[1],ISR_IRR[0],IRR_MASKED[7],IRR_MASKED[6],IRR_MASKED[5],IRR_MASKED[4],IRR_MASKED[3],IRR_MASKED[2],IRR_MASKED[1],IRR_MASKED[0]);

    $timeformat(-9, 1, " ns", 10);
end

endmodule

