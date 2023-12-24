
module IRR (
		input wire [7:0] IRR, //IR0 - IR7  From I/O
		input wire LTIM, // From control, 1 for level 0 for edge
		input wire IRR_reset, // From control for IR7 input to be 0 
		input wire INTA_FREEZE, // From control to freeze IRR
		input wire [7:0] INTA_1, // From priority_resolver to set the one we are working on
		
		output reg [7:0]  IRR_priority, // to priority resolver 
		output reg [7:0]  IRR_control // to control logic
	);
    
    reg [7:0] IRR_prev;  // Store previous value of IRR for edge detection


    always @(IRR_reset) begin
		if(IRR_reset) begin
			IRR_prev = 8'b0;
			IRR_priority = 8'b0;
			IRR_control = 8'b0;
		end
	end
	
	always @(INTA_1) begin
        IRR_priority = IRR_priority & (~INTA_1) ;
        IRR_control =  IRR_control  & (~INTA_1) ;
    end 
	
	
	 // the oring between the input value and the old value so that if there is an interrupt we didn't handle yet it should still be there
    always @(IRR) begin
		if (LTIM && INTA_FREEZE == 1'b0) begin
            // Level-triggered mode
            IRR_priority = IRR | IRR_priority;
			IRR_control = IRR | IRR_control;
        end else if (!LTIM && INTA_FREEZE == 1'b0) begin
            // Edge-triggered mode
			IRR_priority = (IRR & (~IRR_prev)) | IRR_priority;
			IRR_control = (IRR & (~IRR_prev)) | IRR_control;
            IRR_prev = IRR;  // Update the previous value for edge detection
        end
    end
	
endmodule