
module Read_Write_Logic (
	  input wire RD, //from CPU
	  input wire WR, //from CPU
	  input wire A0, //from CPU
	  input wire CS, //from CPU
	  input wire [7:0] Ds, // Ds from data_bus
	  
	  output reg [2:0] WR_cur, // to Control Logic
	  output reg RD_flag, // flag to data bus
	  output reg WR_flag  // flag to data bus 
);
	
	
	reg ICW_4, ICW_3; // ICW3-4 or not ?
	reg I_or_O;// 1 for ICW, 0 for OCW
	reg [1:0]cur_I;
	
	
	parameter IC2 = 2'b00, IC3 = 2'b01, IC4 = 2'b10;
	parameter ICW1 = 3'b000, ICW2 = 3'b001, ICW3 = 3'b010, ICW4 = 3'b011,
		        OCW1 = 3'b100, OCW2 = 3'b101, OCW3 = 3'b110;


	always @ * begin
		if(CS == 1'b0) begin
			
			// when RD low send a flag to data bus, in data bus manager that when the flag = 1 look at RD_cur
			RD_flag = ~RD;
			WR_flag = ~WR;
			
			// when WR low -> either ICWs or OCWs 
			if (WR == 1'b0) begin
				if(A0 == 1'b0 && Ds[4] == 1'b1) begin  // ICW1
				    ICW_3 = ~Ds[1];
					ICW_4 = Ds[0];
					I_or_O = 1'b1;
					cur_I = IC2;
					WR_cur = ICW1;
				end
				else if (I_or_O == 1'b1 && cur_I == IC2) begin // ICW2
					WR_cur = ICW2;
					
					if(ICW_3 ) 
						cur_I = IC3;
					else if (ICW_4)
						cur_I = IC4;
					else begin
						I_or_O = 0; // no ICW3 or 4, check for new initilization or OCWs
					end
					
				end
				else if (I_or_O == 1'b1 && cur_I == IC3) begin  // ICW3
					WR_cur = ICW3;		

					if (ICW_4)
						cur_I = IC4;
					else begin
						I_or_O = 0; // no ICW4, check for new initilization or OCWs
					end
					
				end
				else if ( I_or_O == 1'b1 && cur_I == IC4)begin  // ICW4
					WR_cur = ICW4;		
					
					I_or_O = 0; // end of initilization					
				end
				else if ( I_or_O == 1'b0 && A0 == 1'b1)  // OCW1
					WR_cur = OCW1;				 
				else if ( I_or_O == 1'b0 && A0 == 1'b0 && Ds[3] == 1'b0 && Ds[4] == 1'b0 )  // OCW2
					WR_cur = OCW2;				 
				else if ( I_or_O == 1'b0 && A0 == 1'b0 && Ds[3] == 1'b1 && Ds[4] == 1'b0)  // OCW3
					WR_cur = OCW3;						
			end
		end
	end
	
endmodule
