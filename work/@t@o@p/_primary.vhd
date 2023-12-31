library verilog;
use verilog.vl_types.all;
entity TOP is
    port(
        CS              : in     vl_logic;
        WR              : in     vl_logic;
        RD              : in     vl_logic;
        A0              : in     vl_logic;
        IR              : in     vl_logic_vector(7 downto 0);
        INTA            : in     vl_logic;
        SP_EN           : in     vl_logic;
        D               : inout  vl_logic_vector(7 downto 0);
        CAS             : inout  vl_logic_vector(2 downto 0);
        INT             : out    vl_logic
    );
end TOP;
