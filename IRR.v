module IRR (
		input wire [7:0] IRR, //IR0 - IR7  From I/O
		input wire LTIM, // from control , 1 for level 0 for edge
		input wire IRR_reset, // from control for IR7 input to be 0 
		
		output reg[7:0]  IRR_priority, // to priority resolver 
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
	
	 // the oring between the input value and the old value so that if there is an interrupt we didn't handle yet it should still be there
    always @(IRR) begin
	
        if (LTIM) begin
            // Level-triggered mode
            IRR_priority <= IRR | IRR_priority;
	        IRR_control <= IRR | IRR_control;
        end else begin
            // Edge-triggered mode
			IRR_priority = (IRR & (~IRR_prev)) | IRR_priority;
			IRR_control = (IRR & (~IRR_prev)) | IRR_control;
            IRR_prev <= IRR;  // Update the previous value for edge detection
        end
    end
	
endmodule
