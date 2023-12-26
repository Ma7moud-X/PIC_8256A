
module IMR (
	input wire [7:0] cur_MASK, // FROM CONTROL LOGIC
	input wire MASK_reset, // FROM CONTROL LOGIC
	 
	output reg[7:0]  IMR  // To priority resolver 	

);
    always @(MASK_reset) begin
      if(MASK_reset)
        IMR = 8'b0; 
    end
  
	always @(cur_MASK) begin
		IMR = cur_MASK;
	end

endmodule




module IMR_tb();

	reg [7:0]cur_MASK;
	reg MASK_reset;
	
	wire [7:0] IMR;
	
IMR test (
		// input
		.cur_MASK(cur_MASK),
		.MASK_reset(MASK_reset),
		// output
		.IMR(IMR)
);

initial begin
    MASK_reset = 1'b1;
    #1000; // 1 nano
    
    MASK_reset = 1'b0;
	cur_MASK = 8'b11110000;
    #1000;
        
	cur_MASK = 8'b00001111;
    #1000;
    
    $finish;
end

initial begin
    $monitor("Time: %t, MASK_reset: %b,    cur_MASK: %b %b %b %b %b %b %b %b,    IMR: %b %b %b %b %b %b %b %b",
    $time,MASK_reset,cur_MASK[7],cur_MASK[6],cur_MASK[5],cur_MASK[4],cur_MASK[3],cur_MASK[2],cur_MASK[1],cur_MASK[0],
	IMR[7],IMR[6],IMR[5],IMR[4],IMR[3],IMR[2],IMR[1],IMR[0]);

    $timeformat(-9, 1, " ns", 10);
end

endmodule	
	

