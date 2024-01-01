																				
module Cascade_Buffer (	
	
	inout wire [2:0] CAS, 

	input wire SP_EN, // from and to CPU, OUT : Buffered (not supported), IN : Cascade, SP = 1 for master, SP = 0 for slave
    input wire Cascade_reset, // From control for the slave mode address to set to priority 7 //its address (also known as the interrupt vector) is set to 7
	input wire SNGL, // from control : if 1 sngl if 0 Cascade
	input wire [2:0]ISR, // from ISR to knew which one i'm working on now to send to slaves
	input wire INTA_2,
	output reg Master_Slave, // to control // 1 master, 0 slave
	output reg [2:0] ID // to control to copmare IDs when slave 
	
);
	
	always @(Cascade_reset) begin
		if(Cascade_reset) begin
			ID = 7;
		end
	end
    
	always @ (SP_EN or SNGL) begin
		if(SNGL == 1'b0)
		  Master_Slave = SP_EN;
	end
	
	always @* begin
	    if(!Cascade_reset)begin
			if(!Master_Slave) begin // Slave
				ID = CAS;
			end
		end
	end
	
	assign CAS = !Cascade_reset && Master_Slave && !SNGL && INTA_2  ? ISR : 3'bz ;

endmodule

 

 

module Cascade_Buffer_tb();

	// input
	reg Cascade_reset;
	reg [2:0] ISR;
	reg SP_EN;
	reg SNGL;
  reg INTA_2;

	// inout
	wire [2:0] CAS;
	
	// output
	wire [2:0] ID;
	wire Master_Slave;
	
Cascade_Buffer test (
		// input
		.Cascade_reset(Cascade_reset),
		.ISR(ISR),
		.SP_EN(SP_EN),
		.SNGL(SNGL),
		.INTA_2(INTA_2),
		// inout
		.CAS(CAS),
		// output
		.ID(ID),
		.Master_Slave(Master_Slave)
);

	reg [2:0] t;
	assign CAS = !Cascade_reset && !Master_Slave && !SNGL ? t : 3'bz ;

initial begin
    Cascade_reset = 1'b1;
    #1000; // 1 nano
    
	// SNGL
    Cascade_reset = 1'b0;
	SNGL = 1'b1;
	SP_EN = 1'b1; // to check that it doesn't affect Master_Slave 
    #1000;
        
	// Cascade : Master
	SNGL = 1'b0;
	SP_EN = 1'b1;
	ISR = 3;
    #1000;
   
	// Cascade : Slave
	SP_EN = 1'b0;
	t = 4;
    #1000;
       
end

initial begin
    $monitor("Time: %t, Cascade_reset: %b, SNGL: %b, SP_EN: %b,   ISR: %b %b %b,  INOUT  CAS: %b %b %b   OUTPUT  Master_Slave: %b,   ID:  %b %b %b",
    $time,Cascade_reset,SNGL,SP_EN,ISR[2],ISR[1],ISR[0],CAS[2],CAS[1],CAS[0],
    Master_Slave,ID[2],ID[1],ID[0]);

    $timeformat(-9, 1, " ns", 10);
end

endmodule	
	








