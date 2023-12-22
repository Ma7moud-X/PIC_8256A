module IMR (
	input wire [7:0] cur_MASK, // FROM CONTROL LOGIC
	input wire MASK_reset, // FROM CONTROL LOGIC
	 
	output reg[7:0]  IMR  // To priority resolver 	

);
  always @(MASK_reset) begin
    IMR = 8'b0; 
  end
  
	always @(cur_MASK) begin
		IMR = cur_MASK;
	end

endmodule

