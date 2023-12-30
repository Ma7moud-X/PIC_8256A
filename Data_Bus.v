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


module Data_bus_tb();

	reg RD_flag;
	reg WR_flag;
	reg [7:0] Ds_from_control;
	
	wire [7:0] Ds;
	//reg [7:0] Ds_IN;
	//wire [7:0] Ds_OUT;
	
	// No need for Ds_to_W_R as it = Ds_from_control
	wire [7:0] Ds_to_Control;
	wire RD_flag_control;


Data_bus test (
				.RD_flag(RD_flag),
				.WR_flag(WR_flag),
				.Ds_from_control(Ds_from_control),
				
				.Ds(Ds),
				//.Ds_IN(Ds_IN),
				//.Ds_OUT(Ds_OUT),
				
				.Ds_to_Control(Ds_to_Control),
				.RD_flag_control(RD_flag_control)
);

  reg [7:0] t;
  assign Ds = WR_flag ? t : 8'bz;

initial begin
	// Write
    WR_flag = 1'b1;
	RD_flag = 1'b0;
	t = 8'b11110000;
    #1000; // 1 nano
    
	// Read
    WR_flag = 1'b0;
	RD_flag = 1'b1;
	Ds_from_control = 8'b00001111;
    #1000;
    
	WR_flag = 1'b0;
	RD_flag = 1'b1;
	Ds_from_control = 8'b11111111;
    #1000;

  WR_flag = 1'b0;
	RD_flag = 1'b0;
	Ds_from_control = 8'b11110000;
    #1000;	
    $finish;
end

initial begin
    $monitor("Time: %t, RD_flag: %b, WR_flag: %b,   Ds_from_control: %b %b %b %b %b %b %b %b,   OUTPUT  Ds: %b %b %b %b %b %b %b %b,  RD_flag_control: %b,   Ds_to_Control: %b %b %b %b %b %b %b %b",
	$time,RD_flag,WR_flag,Ds_from_control[7],Ds_from_control[6],Ds_from_control[5],Ds_from_control[4],Ds_from_control[3],Ds_from_control[2],Ds_from_control[1],Ds_from_control[0],
	Ds[7],Ds[6],Ds[5],Ds[4],Ds[3],Ds[2],Ds[1],Ds[0],RD_flag_control,Ds_to_Control[7],Ds_to_Control[6],Ds_to_Control[5],Ds_to_Control[4],Ds_to_Control[3],Ds_to_Control[2],Ds_to_Control[1],Ds_to_Control[0]);
    
	
	$timeformat(-9, 1, " ns", 10);
end

endmodule