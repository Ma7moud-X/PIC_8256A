library verilog;
use verilog.vl_types.all;
entity IMR is
    port(
        cur_MASK        : in     vl_logic_vector(7 downto 0);
        MASK_reset      : in     vl_logic;
        IMR             : out    vl_logic_vector(7 downto 0)
    );
end IMR;
