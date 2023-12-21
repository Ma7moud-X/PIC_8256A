library verilog;
use verilog.vl_types.all;
entity ISR is
    port(
        ISR             : in     vl_logic_vector(7 downto 0);
        ISR_reset       : in     vl_logic;
        ISR_Control     : out    vl_logic
    );
end ISR;
