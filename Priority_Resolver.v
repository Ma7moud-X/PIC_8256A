

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



