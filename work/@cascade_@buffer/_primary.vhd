library verilog;
use verilog.vl_types.all;
entity Cascade_Buffer is
    port(
        CAS             : inout  vl_logic_vector(2 downto 0);
        SP_EN           : in     vl_logic;
        Cascade_reset   : in     vl_logic;
        SNGL            : in     vl_logic;
        ISR             : in     vl_logic_vector(2 downto 0);
        INTA_2          : in     vl_logic;
        Master_Slave    : out    vl_logic;
        ID              : out    vl_logic_vector(2 downto 0)
    );
end Cascade_Buffer;
