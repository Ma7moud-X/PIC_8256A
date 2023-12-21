library verilog;
use verilog.vl_types.all;
entity Priority_Resolver is
    port(
        IRR_reset       : in     vl_logic;
        IRR             : in     vl_logic_vector(7 downto 0);
        IMR             : in     vl_logic_vector(7 downto 0);
        ISR             : out    vl_logic_vector(7 downto 0);
        IRR_MASK        : out    vl_logic_vector(7 downto 0)
    );
end Priority_Resolver;
