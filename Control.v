module Control_Logic (
	output reg INT, // to CPU
	output reg [7:0] cur_Mask, // to IMR (OCW1) 
	output reg [7:0]  Ds_to_data,
	output reg [2:0]ISR_DONE, // to isr duign AEOI @ the end of second INTA
	output reg [2:0] EOI_and_Rotate, // to resolver ans ISR to enable rotate if needed
	output reg Mask_reset, // to IMR to reset during initilization
	output reg ISR_reset, // to ISR for IR7 input to be assigned priority 7 
	output reg IRR_reset, // to IRR for IR7 input to be 0 
	output reg Cascade_reset, // to Cascade for the slave mode address to set to 7 //its address (also known as the interrupt vector) is set to 7
	output reg SNGL, // to Cascade if 1 sngl if 0 cascade
	output reg LTIM, // TO IRR, 1 for level 0 for edge
	output reg INTA_1, // to priority_resolver to set the ist @ the first INTA
	output reg INTA_FREEZE, //TO IRR duingthe INTA
	output reg INTA_2, // to Cascade
	
        input wire [2:0] ID, // from Cascade to compare in case of slave
	input wire [2:0]n, // from resolver to handel the rotating
	input wire [2:0] WR_cur, // from Read_Write_logic
	input wire [2:0] ISR,  // from ISR, the index of the one we are working on
	input wire [7:0] Ds, // Ds from data_bus
	input wire [7:0]  IRR_resolver, // from Resolver
	input wire [7:0] IRR,// from IRR
    input wire [7:0]  ISR_READ,  // form ISR
	input wire Master_Slave, // from Cascade
    input wire NO_ICW4, // from read write to set the default if no ICW4
	input wire INTA, // from CPU
	input wire RD_flag   // from data

);

    reg RD_cur,EOI_cur;
	reg INTA_NUM;
    reg [7:0]priorityVector [7:0];
	reg [1:0] BUFFERED_cur;
	reg [2:0] My_ID; // from ICW3, My id as a slave
	reg [7:0] IR_Cascade;
	reg Higher;
	
	integer shift;

	parameter aeoi = 1'b1, eoi = 1'b0;
	parameter irr = 1'b0, isr = 1'b1; // what RD read

	parameter NON_BUFFERED = 2'b00 , BUFFERED_SLAVE = 2'b01, BUFFERED_MASTER = 2'b10;
	parameter ICW1 = 3'b000, ICW2 = 3'b001, ICW3 = 3'b010, ICW4 = 3'b011,
			  OCW1 = 3'b100, OCW2 = 3'b101, OCW3 = 3'b110;
			  
	// i'm not handling the Specefic EOI 
	parameter NON_SPECIFIC_EOI = 3'b001,
			  SPECIFIC_EOI = 3'b011,
		      ROTATE_NON_SPECIFIC_EOI = 3'b101,
			  ROTATE_AEOI_SET = 3'b100,
			  ROTATE_AEOI_CLEAR = 3'b111;
	
	always @(n) begin
		shift = n;
	end
  
	always @* begin
        if (|IRR_resolver) begin // Check if any interrupt is pending
            
			Higher=1'b0;
			// check if there is IRR higher than current ISR
			if (IRR_resolver[(0+shift)%8] && ((0+shift)%8) < ISR) Higher = 1'b1;
			else if (IRR_resolver[(1+shift)%8] && ((1+shift)%8) < ISR) Higher = 1'b1;
			else if (IRR_resolver[(2+shift)%8] && ((2+shift)%8) < ISR) Higher = 1'b1;
			else if (IRR_resolver[(3+shift)%8] && ((3+shift)%8) < ISR) Higher = 1'b1;
			else if (IRR_resolver[(4+shift)%8] && ((4+shift)%8) < ISR) Higher = 1'b1;
			else if (IRR_resolver[(5+shift)%8] && ((5+shift)%8) < ISR) Higher = 1'b1;
			else if (IRR_resolver[(6+shift)%8] && ((6+shift)%8) < ISR) Higher = 1'b1;
			else if (IRR_resolver[(7+shift)%8] && ((7+shift)%8) < ISR) Higher = 1'b1;
			
			// if AEOI the IST is already reset so no need to wait before new INT
			// if after waiting for (100 nano in our case) the ISR isn't reset (an EOI didn't occure) that' CPU problem
			// i'm testing with 30 nano second between steps so i will make the wait to be around 100 nanosecond may change after the test
			if(EOI_and_Rotate == NON_SPECIFIC_EOI && Higher) begin
				INT = 1'b0;
				#1500; // wait for 1.5 nano then rise the INT to handle the next request 
				////////////////////////////////////////////////////////////////
				//   We should use a clk for the delay but i couldn't do it  // 
				///////////////////////////////////////////////////////////////
			end

            INT = 1'b1; // Assert INT signal
        end
    end
    
	// handle EOI and AEOI then continue here
   always @(INTA or EOI_and_Rotate) begin
	
		if(INTA == 1'b1) begin
			if(INTA_NUM == 1'b0) begin
			    INTA_FREEZE = 1'b1;
				INTA_NUM = 1'b1;
				INTA_1 = 1'b1;
				INTA_2 = 1'b1;
			end else if (INTA_NUM == 1'b1 && SNGL ) begin // SNGL
				INTA_NUM = 1'b0;
				INTA_1 = 1'b0;
				Ds_to_data = priorityVector[ISR];
			end else if (INTA_NUM == 1'b1 && Master_Slave ) begin // Master
				INTA_NUM = 1'b0;
			    INTA_1 = 1'b0;
				if(!IR_Cascade[ISR])// if the interrupt we are working on is a slave don't send any thing to data the slave will do it, if it's I/O device send the address
					Ds_to_data = priorityVector[ISR];
			end
			else if (INTA_NUM == 1'b1 && ID == My_ID ) begin // Slave
				INTA_NUM = 1'b0;
				INTA_1 = 1'b0;
				Ds_to_data = priorityVector[ISR];
			end
		
		end
		else if(INTA == 1'b0 && INTA_NUM == 1'b0) begin // end of INT
		  
		  if(aeoi) begin
			ISR_DONE = ISR;
		  end else if( eoi && EOI_and_Rotate == NON_SPECIFIC_EOI )begin
			 ISR_DONE = ISR;
		  end
		  
		  INTA_2 = 1'b0;
		  INTA_FREEZE = 1'b0; // unfreeze IRR
		  INT = 1'b0;
		end
   end
   
	
	always @(RD_flag) begin
		if(RD_flag == 1'b1) begin
			case(RD_cur) 
				irr : Ds_to_data = IRR;
				isr : Ds_to_data = ISR_READ;
			endcase
		end
	end
	
	
	always @ (WR_cur or Ds) begin	
		case (WR_cur)
			ICW1 :
			    begin
						INTA_FREEZE= 1'b0;
						cur_Mask = 8'b0;
						INT = 1'b0;
						Mask_reset = 1'b1;
						ISR_reset = 1'b1;
						IRR_reset = 1'b1;
						Cascade_reset = 1'b1;
						RD_cur = irr;
						SNGL = Ds[1];
						LTIM = Ds[3];
						INTA_NUM = 1'b0;
						if(NO_ICW4)begin
							BUFFERED_cur = NON_BUFFERED;
							EOI_cur = eoi;
						end
				end
			ICW2 :
			     begin
					       priorityVector[7] = {Ds[7:3], 3'b111}; // Priority 7
					       priorityVector[6] = {Ds[7:3], 3'b110}; // Priority 6
			         	   priorityVector[5] = {Ds[7:3], 3'b101}; // Priority 5
					       priorityVector[4] = {Ds[7:3], 3'b100}; // Priority 4
			         	   priorityVector[3] = {Ds[7:3], 3'b011}; // Priority 3
            			   priorityVector[2] = {Ds[7:3], 3'b010}; // Priority 2
	           			   priorityVector[1] = {Ds[7:3], 3'b001}; // Priority 1
			         	   priorityVector[0] = {Ds[7:3], 3'b000}; // Priority 0
						   
						   Mask_reset = 1'b0;
						   ISR_reset = 1'b0;
						   IRR_reset = 1'b0;
						   Cascade_reset = 1'b0;
				end
  					
			ICW3 :
					begin	 
						if(Master_Slave == 1'b1)  // Master
							IR_Cascade = Ds;
						 else                     // Slave
							My_ID = Ds[2:0];
					end
						
			ICW4 :
			begin
					if(Ds[1])
						EOI_cur = aeoi;
					else 
						EOI_cur = eoi;
						
					// we are not supporting buffered mode but just for reference
					if(!Ds[3])
						BUFFERED_cur = NON_BUFFERED;
					else if(Ds[3] && Ds[2])
						BUFFERED_cur = BUFFERED_MASTER;
					else 
						BUFFERED_cur = BUFFERED_SLAVE;
					end			
			OCW1 :
					cur_Mask = Ds;
			OCW2 :
					EOI_and_Rotate = {Ds[7] , Ds[6] ,Ds[5] }; 
			OCW3 :
					if(Ds[0] & Ds[1]) 
						RD_cur = isr;
					else if (!Ds[0] && Ds[1])					
						RD_cur = irr;
					else begin
					end
		endcase
	
	end
endmodule




module Control_Logic_tb();

	// INPUT
	reg [2:0] ID;              // from Cascade to compare in case of slave
	reg [2:0] n; 		   	   // from resolver to handel the rotating
	reg [2:0] WR_cur; 		   // from Read_Write_logic
	reg [2:0] ISR;             // from ISR, the index of the one we are working on
	reg [7:0] Ds;              // Ds from data_bus
	reg [7:0] IRR_resolver;    // from Resolver
	reg [7:0] IRR;             // from IRR
    reg [7:0] ISR_READ;        // form ISR
	reg Master_Slave;          // from Cascade
    reg NO_ICW4;               // from read write to set the default if no ICW4
	reg INTA;                  // from CPU
	reg RD_flag;


	// OUTPUT
	wire INTA_2;
	wire INT;                  // to CPU
	wire [7:0] cur_Mask;       // to IMR (OCW1) 
	wire [7:0]  Ds_to_data;
	wire [2:0]ISR_DONE;        // to isr duign AEOI @ the end of second INTA
	wire [2:0] EOI_and_Rotate; // to resolver ans ISR to enable rotate if needed
	wire Mask_reset;           // to IMR to reset during initilization
	wire ISR_reset;            // to ISR for IR7 input to be assigned priority 7 
	wire IRR_reset;            // to IRR for IR7 input to be 0 
	wire Cascade_reset;        // to Cascade for the slave mode address to set to 7 //its address (also known as the interrupt vector) is set to 7
	wire SNGL;                 // to Cascade if 1 sngl if 0 cascade
	wire LTIM;                 // TO IRR, 1 for level 0 for edge
	wire INTA_1;               // to priority_resolver to set the ist @ the first INTA
	wire INTA_FREEZE;


Control_Logic test (
				// IN
				.ID(ID),
				.n(n),
				.WR_cur(WR_cur),
				.ISR(ISR),
				.Ds(Ds),
				.IRR_resolver(IRR_resolver),
				.IRR(IRR),
				.ISR_READ(ISR_READ),
				.Master_Slave(Master_Slave),
				.NO_ICW4(NO_ICW4),
				.INTA(INTA),
				.RD_flag(RD_flag),

				// OUT
				.INTA_2(INTA_2),
				.INT(INT),
				.cur_Mask(cur_Mask), 
				.Ds_to_data(Ds_to_data),
				.ISR_DONE(ISR_DONE),
				.EOI_and_Rotate(EOI_and_Rotate),
				.Mask_reset(Mask_reset),
				.ISR_reset(ISR_reset), 
				.IRR_reset(IRR_reset), 
				.Cascade_reset(Cascade_reset),
				.SNGL(SNGL),
				.LTIM(LTIM),
				.INTA_1(INTA_1),
				.INTA_FREEZE(INTA_FREEZE)
				
);

initial begin

	// Initilization ,,,,, NO Cascade, Level triggered
    WR_cur = 3'b000; // ICW1
	Ds = 8'b00011011;
	RD_flag = 1'b0; // no reading
	NO_ICW4 = 1'b0; // there is ICW4
    #1000; // 1 nano
    
	WR_cur = 3'b001; // ICW2
	Ds = 8'b10101000; // 10101 : vector table
    #1000;
    
	WR_cur = 3'b011; // ICW4
	Ds = 8'b00000011; // AUTO EOI
    #1000;
	
	WR_cur = 3'b100; // OCW1
	Ds = 8'b00000010; // masking bit number 1
    #1000;	
	
	WR_cur = 3'b101; // OCW2
	Ds = 8'b01000000; // no operation (NO Rotate or EOI)
	#1000;
	
	// no need for OCW3 for now : default reading -> IR
	
	IRR = 8'b00000110;
	RD_flag = 1'b1;    // Ds_to_data = IR
	#1000;
	
	n = 0;
	IRR_resolver = 8'b00000100;
	ISR = 2;
	#1000;
	
	INTA = 1'b1; // FIRST ACK
	#1000;
	
	INTA = 1'b0;
	#1000;
	
	INTA = 1'b1; // SECOND ACK
	#1000;
	
	INTA = 1'b0; // END OF INTERRUPT
	IRR_resolver = 8'b00000000;
	ISR = 0;
	#1000;
	
    $finish;
end

initial begin
  $monitor("Time: %t, WR_cur: %b %b %b,  RD_flag: %b,  NO_ICW4: %b\nIRR: %b %b %b %b %b %b %b %b,  ISR_READ: %b %b %b %b %b %b %b %b, --> Ds_to_data: %b %b %b %b %b %b %b %b  
	IRR_resolver: %b %b %b %b %b %b %b %b, ISR: %b %b %b,  n: %b %b %b,     INT: %b, INTA: %b\n OUTPUT
	cur_Mask: %b %b %b %b %b %b %b %b,   ISR_DONE: %b %b %b, EOI_and_Rotate: %b %b %b,     Mask_reset: %b, IRR_reset: %b, ISR_reset: %b, Cascade_reset: %b
	SNGL: %b, LTIM: %b, INTA_1: %b, INTA_FREEZE: %b,    INTA_2: %b ",
	
	$time,WR_cur[2],WR_cur[1],WR_cur[0],RD_flag,NO_ICW4,IRR[7],IRR[6],IRR[5],IRR[4],IRR[3],IRR[2],IRR[1],IRR[0],ISR_READ[7],ISR_READ[6],ISR_READ[5],ISR_READ[4],ISR_READ[3],ISR_READ[2],ISR_READ[1],ISR_READ[0],
	Ds_to_data[7],Ds_to_data[6],Ds_to_data[5],Ds_to_data[4],Ds_to_data[3],Ds_to_data[2],Ds_to_data[1],Ds_to_data[0],IRR_resolver[7],IRR_resolver[6],IRR_resolver[5],IRR_resolver[4],IRR_resolver[3],IRR_resolver[2],
	IRR_resolver[1],IRR_resolver[0],ISR[2],ISR[1],ISR[0],n[2],n[1],n[0],INT,INTA,cur_Mask[7],cur_Mask[6],cur_Mask[5],cur_Mask[4],cur_Mask[3],cur_Mask[2],cur_Mask[1],cur_Mask[0],
	ISR_DONE[2],ISR_DONE[1],ISR_DONE[0],EOI_and_Rotate[2],EOI_and_Rotate[1],EOI_and_Rotate[0],Mask_reset,IRR_reset,ISR_reset,Cascade_reset,SNGL,LTIM,INTA_1,INTA_FREEZE,INTA_2
	);
    
	
	$timeformat(-9, 1, " ns", 10);
end

endmodule






