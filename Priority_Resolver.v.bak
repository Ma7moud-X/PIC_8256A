module Priority_Resolver (
	input wire IRR_reset, 
	input wire[7:0] IRR,// IR0 - IR7 from IRR
	input wire[7:0] IMR,

	output reg [7:0] ISR, // to ISR
	output reg [7:0] IRR_MASK // to control
);
    reg [7:0] CUR_ISR;
      
      
    // return to default priority
    always @(IRR_reset) begin
     if(IRR_reset)begin
		CUR_ISR = 8'b0;
     end
    end

    reg highest_priority;
    assign IRR = IRR & (~IMR);
    
    always @(IRR,IMR,ISR) begin
        IRR_MASK = IRR; // the one we send to control logic to send to CPU if the CPU want it
        // Update highest_priority based on the masked IRR
        if (IRR[0]) highest_priority = 0;
        else if (IRR[1]) highest_priority = 1; 
        else if (IRR[2]) highest_priority = 2; 
        else if (IRR[3]) highest_priority = 3; 
        else if (IRR[4]) highest_priority = 4; 
        else if (IRR[5]) highest_priority = 5; 
        else if (IRR[6]) highest_priority = 6; 
        else highest_priority = 7;

        // Update ISR directly with highest_priority
        CUR_ISR = (1 << highest_priority);
    end
    
endmodule


