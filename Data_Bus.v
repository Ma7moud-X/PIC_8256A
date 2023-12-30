module Data_bus (

	inout wire [7:0] Ds,
	
	input wire RD_flag, // flag from Write/Read logic
	input wire WR_flag, // flag from Write/Read logic
	input wire[7:0]  Ds_from_control,

	output reg [7:0] Ds_to_W_R, // D0 - D7 to Write/Read logic
	output reg [7:0] Ds_to_Control, // D0 - D7 to Control logic
	output reg RD_flag_control // ask contrl for data
		
);
   

    always @* begin
        if (RD_flag) begin
			   RD_flag_control = 1'b1;
        end else if (WR_flag) begin //seond Ds received from CPU to control and to write/read modules
            Ds_to_Control = Ds;
			Ds_to_W_R = Ds;
        end 
    end
	
	   assign Ds = RD_flag ? Ds_from_control : 8'bz;


  
endmodule
