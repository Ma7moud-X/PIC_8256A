    `include "IRR.v";
	`include "Priority_Resolver.v";
	`include "ISR.v";
	`include "IMR.v";
	`include "Control.v";
	`include "Read_Write_Logic.v";
	`include "Data_Bus.v";
	`include "Cascade.v";


	module TOP (
		  input reg CS,
		  input reg WR,
		  input reg RD,
		  input reg A0,
		  input reg [7:0] IR,
		  input reg INTA,
		  input reg SP_EN,
		  
		  inout wire [7:0] D,
		  inout wire [2:0] CAS,
		  output wire INT
	);

    
		//cascade
		wire [2:0] ID;
		wire Master_Slave;
		
		//IRR		
		wire [7:0] IRR_control;
		wire [7:0] IRR_priority;
		
		//resolver
		wire [7:0] ISR_IRR;
		wire [7:0] IRR_MASKED;
		wire [2:0] n;
		
		// ISR
		wire [7:0] ISR_cur;
		wire [2:0] ISR_Control;
		
		//IMR				
		wire [7:0] IMR;
		
		//Read_write		
		wire NO_ICW4;
		wire [2:0] WR_cur;
		wire RD_flag;
		wire WR_flag;
		
		//data bus
		wire [7:0] Ds_to_W_R;
		wire [7:0] Ds_to_Control;
		wire RD_flag_control;
		
		//control		
		wire [7:0] cur_MASK;       // to IMR (OCW1) 
		wire [7:0]  Ds_to_data;
		wire [2:0]  ISR_DONE;        // to isr duign AEOI @ the end of second INTA
		wire [2:0] EOI_and_Rotate; // to resolver ans ISR to enable rotate if needed
		wire Mask_reset;           // to IMR to reset during initilization
		wire ISR_reset;            // to ISR for IR7 input to be assigned priority 7 
		wire IRR_reset;            // to IRR for IR7 input to be 0 
		wire Cascade_reset;        // to Cascade for the slave mode address to set to 7 //its address (also known as the interrupt vector) is set to 7
		wire SNGL;                 // to Cascade if 1 sngl if 0 cascade
		wire LTIM;                 // TO IRR, 1 for level 0 for edge
		wire INTA_1;               // to priority_resolver to set the ist @ the first INTA
		wire INTA_FREEZE;


		
	

	Cascade_Buffer Cascade_Buffer_1(
		// input
		.Cascade_reset(Cascade_reset),
		.ISR(ISR_Control),
		.SP_EN(SP_EN),
		.SNGL(SNGL),
		// inout
		.CAS(CAS),
		// output
		.ID(ID),
		.Master_Slave(Master_Slave)
	);

    IRR IRR_1(
        // input
		.IRR(IR),
		.LTIM(LTIM),
		.IRR_reset(IRR_reset),
		.INTA_FREEZE(INTA_FREEZE),
		.INTA_1(ISR_IRR),
		// output
		.IRR_control(IRR_control),
		.IRR_priority(IRR_priority)
    );

    Priority_Resolver Priority_Resolver_1(
        // input
		.IRR(IRR_priority),
		.IMR(IMR),
		.Rotate(EOI_and_Rotate),
		.IRR_reset(IRR_reset),
		.INTA_1(INTA_1),
		// output
		.ISR_IRR(ISR_IRR),
		.IRR_MASKED(IRR_MASKED),
		.n(n)
    );

    ISR ISR_1(
       	 // input
		.ISR(ISR_IRR),
		.ISR_reset(ISR_reset),
		.ISR_DONE(ISR_DONE),
		.n(n),
		.rotate(EOI_and_Rotate),
		// output
		.ISR_cur(ISR_cur),
		.ISR_Control(ISR_Control)
    );
	
	IMR IMR_1(
		 // input
		.cur_MASK(cur_MASK),
		.MASK_reset(MASK_reset),
		// output
		.IMR(IMR)
	);

    Read_Write_Logic Read_Write_Logic_1(
        .RD(RD),
		.WR(WR),
		.A0(A0),
		.CS(CS),
		.Ds(Ds_to_W_R),
				
		.NO_ICW4(NO_ICW4),
		.WR_cur(WR_cur),
		.RD_flag(RD_flag),
		.WR_flag(WR_flag)
    );

    Control_Logic Control_Logic_1(
         // IN
		 .ID(ID),
		 .n(n),
		 .WR_cur(WR_cur),
		 .ISR(ISR_Control),
		 .Ds(Ds_to_Control),
		 .IRR_resolver(IRR_MASKED),
		 .IRR(IRR_control),
		 .ISR_READ(ISR_cur),
		 .Master_Slave(Master_Slave),
		 .NO_ICW4(NO_ICW4),
		 .INTA(INTA),
		 .RD_flag(RD_flag_control),

		 // OUT
		 .INT(INT),
		 .cur_Mask(cur_MASK), 
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

    Data_bus Data_bus_1(
         .RD_flag(RD_flag),
		 .WR_flag(WR_flag),
		 .Ds_from_control(Ds_to_data),
				
		 .Ds(D),
				
		 .Ds_to_Control(Ds_to_Control),
		 .RD_flag_control(RD_flag_control),
		 .Ds_to_W_R(Ds_to_W_R)
    );

endmodule









// No Cascade
module TOP_tb_1();
	
	// input
	reg CS;
	reg WR;
	reg RD;
	reg A0;
	reg [7:0] IR;
	reg INTA;
	reg SP_EN;
	// inout
	wire [7:0] D;
	wire [2:0] CAS;
	// output
	wire INT;
	
TOP test (
		// input
		.CS(CS),
		.WR(WR),
		.RD(RD),
		.A0(A0),
		.IR(IR),
		.INTA(INTA),
		.SP_EN(SP_EN),
		// inout
		.D(D),
		.CAS(CAS),
		// output
		.INT(INT)
);

reg [7:0] t_D;
  assign D = !WR && !CS ? t_D : 8'bz;
  reg [2:0] t_CAS;
	assign CAS = !SP_EN? t_CAS : 3'bz ;



initial begin
   
	// Initilization ,,,,,, Level triggered
	t_D = 8'b00011011; // ICW1 : ICW3 & ICW4
	CS = 1'b0;
	WR = 1'b0;
	RD = 1'b1;
	A0 = 1'b0;
    #1000;
    
	A0 = 1'b1;
	t_D = 8'b10101000; // ICW2: 10101 -> vector table
    #1000;
    
	t_D = 8'b00000010; // ICW4 : Auto EOI
    #1000;	
	
	t_D = 8'b10000000; // OCW1 : Mask
	#1000
	
	// Reading IR
	IR = 8'b00001000;
	WR = 1'b1;
	RD = 1'b1;
	CS = 1'b1;
	#1000;
	
	// INT
	CS = 1'b1;
	#1000;
	
	INTA = 1'b1; // First ACK
	#1000;
	
	INTA = 1'b0;
	#1000;
	
	INTA = 1'b1; // Second ACK
	#1000;
	
	IR = 8'b0;
    INTA = 1'b0; // END OF INTERRUPT
	#1000;

end

initial begin
    $monitor("Time: %t, CS: %b, WR: %b, RD: %b, A0: %b,    IR: %b %b %b %b %b %b %b %b\n SP_EN: %b, INT: %b, INTA: %b,   CAS: %b %b %b,
    D: %b %b %b %b %b %b %b %b\n",
    $time,CS,WR,RD,A0,IR[7],IR[6],IR[5],IR[4],IR[3],IR[2],IR[1],IR[0],SP_EN,INT,INTA,CAS[2],CAS[1],CAS[0],
    D[7],D[6],D[5],D[4],D[3],D[2],D[1],D[0]);
    $timeformat(-9, 1, " ns", 10);
end

endmodule	
	




// Slave
module TOP_tb_2();
	
	// input
	reg CS;
	reg WR;
	reg RD;
	reg A0;
	reg [7:0] IR;
	reg INTA;
	reg SP_EN;
	// inout
	wire [7:0] D;
	wire [2:0] CAS;
	// output
	wire INT;
	
TOP test (
		// input
		.CS(CS),
		.WR(WR),
		.RD(RD),
		.A0(A0),
		.IR(IR),
		.INTA(INTA),
		.SP_EN(SP_EN),
		// inout
		.D(D),
		.CAS(CAS),
		// output
		.INT(INT)
);

  reg [7:0] t_D;
  assign D = !WR && !CS ? t_D : 8'bz;
  reg [2:0] t_CAS;
	assign CAS = !SP_EN? t_CAS : 3'bz ;

initial begin
   
	// Initilization ,,,,,, Slave, Level triggered
	CS = 1'b0;
	WR = 1'b0;
	RD = 1'b1;
	A0 = 1'b0;
	t_D = 8'b00011001; // ICW1 : ICW3 & ICW4
    #1000;
    
	A0 = 1'b1;
	t_D = 8'b10101001; // ICW2: 10101 -> vector table
    #1000;
    
  A0 = 1'b1;
	t_D = 8'b00000010; // ICW3 : Slave : ID -> 2
    #1000;	
	
	t_D = 8'b00000010; // ICW4 : Auto EOI
	SP_EN = 1'b0; // Slave
	
    #1000;	
	
	// Reading IR
	IR = 8'b00000100;
	WR = 1'b1;
	RD = 1'b1;
	CS = 1'b1;
	SP_EN = 1'b0; // Slave
	t_CAS = 2;
	#1000;
	
	// INT
	CS = 1'b1;
	#1000;
	
	INTA = 1'b1; // First ACK
	#1000;
	
	INTA = 1'b0;
	#1000;
	
	INTA = 1'b1; // Second ACK
	#1000;
	
	IR = 8'b00000000;
    INTA = 1'b0; // END OF INTERRUPT
	#1000;

end

initial begin
    $monitor("Time: %t, CS: %b, WR: %b, RD: %b, A0: %b,    IR: %b %b %b %b %b %b %b %b\n SP_EN: %b, INT: %b, INTA: %b,   CAS: %b %b %b,
    D: %b %b %b %b %b %b %b %b\n",
    $time,CS,WR,RD,A0,IR[7],IR[6],IR[5],IR[4],IR[3],IR[2],IR[1],IR[0],SP_EN,INT,INTA,CAS[2],CAS[1],CAS[0],
    D[7],D[6],D[5],D[4],D[3],D[2],D[1],D[0]);
    
    

    $timeformat(-9, 1, " ns", 10);
end

endmodule	
	









