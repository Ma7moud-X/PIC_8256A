

module Control_Logic (
	output reg INT, // to CPU
	output reg [7:0] cur_Mask, // to IMR (OCW1) 
	output reg Mask_reset, // to IMR to reset during initilization
	output reg ISR_reset, // to ISR for IR7 input to be assigned priority 7 
	output reg IRR_reset, // to IRR for IR7 input to be 0 
	output reg Cascade_reset, // to Cascade for the slave mode address to set to 7 //its address (also known as the interrupt vector) is set to 7
	output reg SNGL, // to Cascade if 1 sngl if 0 cascade
	output reg LTIM, // TO IRR, 1 for level 0 for edge
	output reg[7:0]  Ds_to_data,
	output reg [1:0] BUFFERED_cur, // to Cascade ,             didn't handle it there yet, copy parameters
	output reg INTA_1, // to priority_resolver to set the ist @ the first INTA
	output reg INTA_FREEZE, //TO IRR duingthe INTA
	output reg ISR_DONE, // to isr duign AEOI @ the end of second INTA
	output reg [2:0] EOI_and_Rotate, // to resolver ans ISR to enable rotate if needed
  
    input wire n, // from resolver to handel the rotating
	input wire INTA, // from CPU
	input wire [2:0] WR_cur, // from Read_Write_logic
	input wire [7:0] Ds, // Ds from data_bus
	input wire[7:0]  IRR_resolver, // from Resolver
	input wire[7:0] IRR,// from IRR
    input wire[7:0]  ISR,  // form ISR 	
	input wire RD_flag   // from data

);

    reg RD_cur,EOI_cur;
	reg INTA_NUM;
    reg [7:0]priorityVector [7:0];

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
  
	reg Higher=1'b0;
  
	always @* begin
        if (|IRR_resolver) begin // Check if any interrupt is pending
            
			// check if there is IRR higher than current ISR
			if (IRR_resolver[(0+n)%8] && ((0+n)%8) < ISR) Higher = 1'b1;
			else if (IRR_resolver[(1+n)%8] && ((1+n)%8) < ISR) Higher = 1'b1;
			else if (IRR_resolver[(2+n)%8] && ((2+n)%8) < ISR) Higher = 1'b1;
			else if (IRR_resolver[(3+n)%8] && ((3+n)%8) < ISR) Higher = 1'b1;
			else if (IRR_resolver[(4+n)%8] && ((4+n)%8) < ISR) Higher = 1'b1;
			else if (IRR_resolver[(5+n)%8] && ((5+n)%8) < ISR) Higher = 1'b1;
			else if (IRR_resolver[(6+n)%8] && ((6+n)%8) < ISR) Higher = 1'b1;
			else if (IRR_resolver[(7+n)%8] && ((7+n)%8) < ISR) Higher = 1'b1;
			
			// if AEOI the IST is already reset so no need to wait before new INT
			// if after waiting for (100 nano in our case) the ISR isn't reset (an EOI didn't occure) that' CPU problem
			// i'm testing with 30 nano second between steps so i will make the wait to be around 100 nanosecond may change after the test
			if(EOI_and_Rotate == NON_SPECIFIC_EOI || Higher) begin
				INT = 1'b0;
				#3000; // wait for 3 nano then rise the INT to handle the next request 
				////////////////////////////////////////////////////////////////
				//   We should use a clk for the delay but i couldn't do it   // 
				///////////////////////////////////////////////////////////////
			end


            INT = 1'b1; // Assert INT signal
        end else begin
            INT = 1'b0; // Clear INT signal
        end
    end
    
	// handle EOI and AEOI then continue here
   always @(INTA or EOI_and_Rotate) begin
     if(INTA == 1'b1) begin
        if(INTA_NUM == 1'b0) begin
          INTA_FREEZE = 1'b1;
			INTA_NUM = 1'b1;
			INTA_1 = 1'b1;
		
		end else if (INTA_NUM == 1'b1) begin
			INTA_NUM = 1'b0;
			Ds_to_data = priorityVector[ISR];
		end
		end
		else begin // end of INT
		  if(aeoi) begin
			ISR_DONE = ISR;
		  end else if( eoi && EOI_and_Rotate == NON_SPECIFIC_EOI )begin
			 ISR_DONE = ISR;
		  end
		  
		  INTA_FREEZE = 1'b0; // unfreeze IRR
		  
		end
   end
	
	
	
	always @ (WR_cur,RD_flag) begin
		
		if(RD_flag == 1'b1) begin
			case(RD_cur) 
				irr : Ds_to_data = IRR;
				isr : Ds_to_data = ISR;
			endcase
		end
		
		
		case (WR_cur)
			ICW1 :
			    begin
						Mask_reset = 1'b1;
						ISR_reset = 1'b1;
						IRR_reset = 1'b1;
						Cascade_reset = 1'b1;
						RD_cur = irr;
						SNGL = Ds[1];
						LTIM = Ds[3];
						INTA_NUM = 1'b0;
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
            end
  

					
			//ICW3 :
					
					// ICW3 code
//					two modes :    master : when SP = 1 or in buffered mode when M/S = 1 in ICW4
//				
//					  a 1 is set for each slave in the system then the master will release byte 1 of the call sequence and will enable the slave to release byte 2 through the cascade lines
//					  
//					  slave : SP = 0 or in buffered mode M/S = 0 in ICW4 (bits 2-0 identify the slave.
//					  it compares its cascade input with these bits and if they are equal bytes 2 are released
//					  // the master send the id if (2-0 bits "it's id") equal to what master send it release 2				
					
			ICW4 :
			begin
					if(Ds[1])
						EOI_cur = aeoi;
					else 
						EOI_cur = eoi;
						
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








