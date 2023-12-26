module Priority_Resolver (
	input wire IRR_reset,
	input wire[7:0] IRR,// IR0 - IR7 from IRR
	input wire[7:0] IMR,
	input wire INTA_1, // from control
	input wire [2:0] Rotate, // from control
	
	output reg n, // to ISR & control to handle the rotating
	output reg [7:0] ISR, // to ISR
	output reg [7:0] IRR_MASK, // to control
	output reg [7:0] IRR_INTA_1 // to IRR to reset the bit we are handling now	
);
    reg [7:0] CUR_ISR;
      
	  // to check if rotate or usual
	  parameter ROTATE_NON_SPECIFIC_EOI = 3'b101,
				ROTATE_AEOI_SET = 3'b100,
				ROTATE_AEOI_CLEAR = 3'b111;
						  
						  
     always @(INTA_1) begin
       if(INTA_1==1'b1)begin
        ISR = CUR_ISR; // @ the first INTA set the corresponding ISR bit 
        IRR_INTA_1 = CUR_ISR;
      end
   end 
      
    // return to default priority
    always @(IRR_reset) begin
     if(IRR_reset)begin
		CUR_ISR = 8'b0;
		n = 0;
     end
    end

    reg highest_priority;
    assign IRR = IRR & (~IMR);
    
    always @(IRR,IMR,ISR) begin
        IRR_MASK = IRR; // the one we send to control logic to send to CPU if the CPU want it
        // Update highest_priority based on the masked IRR
        if (IRR[(0+n)%8]) highest_priority = ((0+n)%8);
        else if (IRR[(1+n)%8]) highest_priority = ((1+n)%8); 
        else if (IRR[(2+n)%8]) highest_priority = ((2+n)%8); 
        else if (IRR[(3+n)%8]) highest_priority = ((3+n)%8); 
        else if (IRR[(4+n)%8]) highest_priority = ((4+n)%8); 
        else if (IRR[(5+n)%8]) highest_priority = ((5+n)%8); 
        else if (IRR[(6+n)%8]) highest_priority = ((6+n)%8); 
        else highest_priority = ((7+n)%8);

        // Update ISR directly with highest_priority
        CUR_ISR = (1 << highest_priority);
		if(Rotate == ROTATE_AEOI_CLEAR || Rotate == ROTATE_AEOI_SET || Rotate == ROTATE_NON_SPECIFIC_EOI)
			n = 1 + CUR_ISR;
    end
    
endmodule


