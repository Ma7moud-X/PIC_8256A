library verilog;
use verilog.vl_types.all;
entity Read_Write_Logic is
    generic(
        IC2             : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        IC3             : vl_logic_vector(0 to 1) := (Hi0, Hi1);
        IC4             : vl_logic_vector(0 to 1) := (Hi1, Hi0);
        ICW1            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        ICW2            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        ICW3            : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        ICW4            : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        OCW1            : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0);
        OCW2            : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi1);
        OCW3            : vl_logic_vector(0 to 2) := (Hi1, Hi1, Hi0)
    );
    port(
        RD              : in     vl_logic;
        WR              : in     vl_logic;
        A0              : in     vl_logic;
        CS              : in     vl_logic;
        Ds              : in     vl_logic_vector(7 downto 0);
        NO_ICW4         : out    vl_logic;
        WR_cur          : out    vl_logic_vector(2 downto 0);
        RD_flag         : out    vl_logic;
        WR_flag         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IC2 : constant is 1;
    attribute mti_svvh_generic_type of IC3 : constant is 1;
    attribute mti_svvh_generic_type of IC4 : constant is 1;
    attribute mti_svvh_generic_type of ICW1 : constant is 1;
    attribute mti_svvh_generic_type of ICW2 : constant is 1;
    attribute mti_svvh_generic_type of ICW3 : constant is 1;
    attribute mti_svvh_generic_type of ICW4 : constant is 1;
    attribute mti_svvh_generic_type of OCW1 : constant is 1;
    attribute mti_svvh_generic_type of OCW2 : constant is 1;
    attribute mti_svvh_generic_type of OCW3 : constant is 1;
end Read_Write_Logic;
