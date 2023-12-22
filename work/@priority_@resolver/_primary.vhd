library verilog;
use verilog.vl_types.all;
entity Priority_Resolver is
    generic(
        ROTATE_NON_SPECIFIC_EOI: vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi1);
        ROTATE_AEOI_SET : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0);
        ROTATE_AEOI_CLEAR: vl_logic_vector(0 to 2) := (Hi1, Hi1, Hi1)
    );
    port(
        IRR_reset       : in     vl_logic;
        IRR             : in     vl_logic_vector(7 downto 0);
        IMR             : in     vl_logic_vector(7 downto 0);
        INTA_1          : in     vl_logic;
        Rotate          : in     vl_logic_vector(2 downto 0);
        n               : out    vl_logic;
        ISR             : out    vl_logic_vector(7 downto 0);
        IRR_MASK        : out    vl_logic_vector(7 downto 0);
        IRR_INTA_1      : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ROTATE_NON_SPECIFIC_EOI : constant is 1;
    attribute mti_svvh_generic_type of ROTATE_AEOI_SET : constant is 1;
    attribute mti_svvh_generic_type of ROTATE_AEOI_CLEAR : constant is 1;
end Priority_Resolver;
