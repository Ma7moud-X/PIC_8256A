																				
module Cascade_Buffer (	
	
	inout wire [2:0] CAS, //OUT : Master, IN : Slave
	input wire SP_EN, // from and to CPU, OUT : Buffered (not supported), IN : Cascade, SP = 1 for master, SP = 0 for slave
  input wire Cascade_reset, // From control for the slave mode address to set to priority 7 //its address (also known as the interrupt vector) is set to 7
	input wire SNGL, // from control : if 1 sngl if 0 Cascade
	input wire ISR, // from ISR to knew which one i'm working on now to send to slaves
	
	output reg Master_Slave, // to control // 1 master, 0 slave
	output reg [2:0] ID // to control to copmare IDs when slave 
	
);

  reg cas;
  
  
	always @ (SP_EN) begin
		if(SNGL == 1'b0)
		  Master_Slave = SP_EN;
	end
	
	always @ (CAS) begin
		if(Master_Slave) begin // Master
			if(ISR == 0) cas = 3'b000;
			else if(ISR == 1) cas = 3'b001;
			else if(ISR == 1) cas = 3'b010;
			else if(ISR == 1) cas = 3'b011;
			else if(ISR == 1) cas = 3'b100;
			else if(ISR == 1) cas = 3'b101;
			else if(ISR == 1) cas = 3'b110;
			else cas = 3'b111;
		end else begin         // SLave
			ID = CAS;
		end
	end
	
	assign CAS = cas;


endmodule

