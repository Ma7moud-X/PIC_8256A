module Data_bus (

	input wire [7:0] Ds_IN,  // D0 - D7 from CPU
	output reg [7:0] Ds_OUT,  // D0 - D7 to CPU

	input wire RD_flag, // flag from Write/Read logic
	input wire WR_flag, // flag from Write/Read logic
	input wire[7:0]  Ds_from_control,

	output reg [7:0] Ds_to_W_R, // D0 - D7 to Write/Read logic
	output reg [7:0] Ds_to_Control, // D0 - D7 to Control logic
	output reg RD_flag_control // ask contrl for data
		
);
   

    always @(RD_flag or WR_flag or Ds_IN) begin
        if (RD_flag == 1'b1) begin
			   RD_flag_control = 1'b1;
        end if (WR_flag == 1'b1) begin //seond Ds received from CPU to control and to write/read modules
            Ds_to_Control = Ds_IN;
			      Ds_to_W_R = Ds_IN;
        end 
    end
	
	always @(Ds_from_control or RD_flag)begin
	   Ds_OUT = RD_flag ? Ds_from_control : 8'bz;
	end

  
endmodule 
