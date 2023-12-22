library verilog;
use verilog.vl_types.all;
entity IRR is
    port(
        IRR             : in     vl_logic_vector(7 downto 0);
        LTIM            : in     vl_logic;
        IRR_reset       : in     vl_logic;
        INTA_FREEZE     : in     vl_logic;
        INTA_1          : in     vl_logic_vector(7 downto 0);
        IRR_priority    : out    vl_logic_vector(7 downto 0);
        IRR_control     : out    vl_logic_vector(7 downto 0)
    );
end IRR;
