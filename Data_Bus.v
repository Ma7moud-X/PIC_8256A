
module Data_bus (

	inout wire [7:0] Ds,  // D0 - D7 from CPU
	
	input wire RD_flag, // flag from Write/Read logic
	input wire WR_flag, // flag from Write/Read logic
	input wire[7:0]  Ds_from_control,

	output reg [7:0] Ds_to_W_R, // D0 - D7 to Write/Read logic
	output reg [7:0] Ds_to_Control, // D0 - D7 to Control logic
	output wire RD_flag_control // ask contrl for data
		
);
    reg [7:0] buffer_data;


    always @* begin
        if (RD_flag == 1'b1) begin
            buffer_data = Ds_from_control;
        end else if (WR_flag == 1'b1) begin //seond Ds received from CPU to control and to write/read modules
            Ds_to_Control = Ds;
			Ds_to_W_R = Ds;
        end 
    end

    // Assign buffer_data to the bidirectional Ds bus
    assign Ds = buffer_data;
	

endmodule 
