library verilog;
use verilog.vl_types.all;
entity Data_bus is
    port(
        Ds_IN           : in     vl_logic_vector(7 downto 0);
        Ds_OUT          : out    vl_logic_vector(7 downto 0);
        RD_flag         : in     vl_logic;
        WR_flag         : in     vl_logic;
        Ds_from_control : in     vl_logic_vector(7 downto 0);
        Ds_to_W_R       : out    vl_logic_vector(7 downto 0);
        Ds_to_Control   : out    vl_logic_vector(7 downto 0);
        RD_flag_control : out    vl_logic
    );
end Data_bus;
