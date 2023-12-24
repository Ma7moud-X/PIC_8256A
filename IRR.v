
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




module IRR_tb();

	reg [7:0]IRR;
	reg LTIM;
	reg IRR_reset;
	reg INTA_FREEZE;
	reg [7:0]INTA_1;
	
	wire [7:0] IRR_control;
	wire [7:0] IRR_priority;
	
IRR test (
		// input
		.IRR(IRR),
		.LTIM(LTIM),
		.IRR_reset(IRR_reset),
		.INTA_FREEZE(INTA_FREEZE),
		.INTA_1(INTA_1),
		// output
		.IRR_control(IRR_control),
		.IRR_priority(IRR_priority)
);

initial begin
    IRR_reset = 1'b1;
	LTIM = 1'b1;
	INTA_FREEZE = 1'b0;
    #1000; // 1 nano
    
	// Level & Edge
    IRR_reset = 1'b0;
	LTIM = 1'b1; // level
	IRR = 8'b11111111;
    #1000;
        
	LTIM = 1'b1; // level
	IRR = 8'b00001111;
    #1000;
    
	LTIM = 1'b1; // level
	IRR = 8'b11110000;
    #1000;
       
	LTIM = 1'b0; // edge
	IRR = 8'b00000000;
    #1000;
    
	LTIM = 1'b0; // edge
	IRR = 8'b11110000;
    #1000;
    
	LTIM = 1'b0; // edge
	IRR = 8'b11000000;
    #1000;
	
	//INTA_1 .. set the bit we are handling now
	LTIM = 1'b1; // level
	IRR = 8'b11111100;
	#1000;
	
	LTIM = 1'b1; // level
	IRR = 8'b00000000;
	INTA_1 = 8'b11110000;
	#1000;
	
	
	// Freeze
	INTA_FREEZE = 1'b1;
	LTIM = 1'b1; // level
	IRR = 8'b11111111;
	#1000;
	
	INTA_FREEZE = 1'b1;
	LTIM = 1'b1; // level
	IRR = 8'b00001111;
	#1000;
	

    $finish;
end

initial begin
    $monitor("Time: %t, reset: %b, LTIM: %b, INTA_FREEZE: %b      IRR: %b %b %b %b %b %b %b %b,      IRR_control: %b %b %b %b %b %b %b %b", $time,IRR_reset,LTIM,INTA_FREEZE,IRR[7],IRR[6],IRR[5],IRR[4],IRR[3],IRR[2],IRR[1],IRR[0] ,IRR_control[7],IRR_control[6],IRR_control[5],IRR_control[4],IRR_control[3],IRR_control[2],IRR_control[1],IRR_control[0]);
    $timeformat(-9, 1, " ns", 10);
end

endmodule	







