library verilog;
use verilog.vl_types.all;
entity ISR is
    generic(
        ROTATE_NON_SPECIFIC_EOI: vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi1);
        ROTATE_AEOI_SET : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0);
        ROTATE_AEOI_CLEAR: vl_logic_vector(0 to 2) := (Hi1, Hi1, Hi1)
    );
    port(
        ISR             : in     vl_logic_vector(7 downto 0);
        ISR_reset       : in     vl_logic;
        ISR_DONE        : in     vl_logic_vector(2 downto 0);
        n               : in     vl_logic_vector(2 downto 0);
        rotate          : in     vl_logic_vector(2 downto 0);
        ISR_Control     : out    vl_logic_vector(2 downto 0);
        ISR_cur         : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ROTATE_NON_SPECIFIC_EOI : constant is 1;
    attribute mti_svvh_generic_type of ROTATE_AEOI_SET : constant is 1;
    attribute mti_svvh_generic_type of ROTATE_AEOI_CLEAR : constant is 1;
end ISR;
