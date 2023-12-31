library verilog;
use verilog.vl_types.all;
entity Control_Logic is
    generic(
        aeoi            : vl_logic := Hi1;
        eoi             : vl_logic := Hi0;
        irr             : vl_logic := Hi0;
        isr             : vl_logic := Hi1;
        NON_BUFFERED    : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        BUFFERED_SLAVE  : vl_logic_vector(0 to 1) := (Hi0, Hi1);
        BUFFERED_MASTER : vl_logic_vector(0 to 1) := (Hi1, Hi0);
        ICW1            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        ICW2            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        ICW3            : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        ICW4            : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        OCW1            : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0);
        OCW2            : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi1);
        OCW3            : vl_logic_vector(0 to 2) := (Hi1, Hi1, Hi0);
        NON_SPECIFIC_EOI: vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        SPECIFIC_EOI    : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        ROTATE_NON_SPECIFIC_EOI: vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi1);
        ROTATE_AEOI_SET : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0);
        ROTATE_AEOI_CLEAR: vl_logic_vector(0 to 2) := (Hi1, Hi1, Hi1)
    );
    port(
        INT             : out    vl_logic;
        cur_Mask        : out    vl_logic_vector(7 downto 0);
        Ds_to_data      : out    vl_logic_vector(7 downto 0);
        ISR_DONE        : out    vl_logic_vector(2 downto 0);
        EOI_and_Rotate  : out    vl_logic_vector(2 downto 0);
        Mask_reset      : out    vl_logic;
        ISR_reset       : out    vl_logic;
        IRR_reset       : out    vl_logic;
        Cascade_reset   : out    vl_logic;
        SNGL            : out    vl_logic;
        LTIM            : out    vl_logic;
        INTA_1          : out    vl_logic;
        INTA_FREEZE     : out    vl_logic;
        INTA_2          : out    vl_logic;
        ID              : in     vl_logic_vector(2 downto 0);
        n               : in     vl_logic_vector(2 downto 0);
        WR_cur          : in     vl_logic_vector(2 downto 0);
        \ISR\           : in     vl_logic_vector(2 downto 0);
        Ds              : in     vl_logic_vector(7 downto 0);
        IRR_resolver    : in     vl_logic_vector(7 downto 0);
        \IRR\           : in     vl_logic_vector(7 downto 0);
        ISR_READ        : in     vl_logic_vector(7 downto 0);
        Master_Slave    : in     vl_logic;
        NO_ICW4         : in     vl_logic;
        INTA            : in     vl_logic;
        RD_flag         : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of aeoi : constant is 1;
    attribute mti_svvh_generic_type of eoi : constant is 1;
    attribute mti_svvh_generic_type of irr : constant is 1;
    attribute mti_svvh_generic_type of isr : constant is 1;
    attribute mti_svvh_generic_type of NON_BUFFERED : constant is 1;
    attribute mti_svvh_generic_type of BUFFERED_SLAVE : constant is 1;
    attribute mti_svvh_generic_type of BUFFERED_MASTER : constant is 1;
    attribute mti_svvh_generic_type of ICW1 : constant is 1;
    attribute mti_svvh_generic_type of ICW2 : constant is 1;
    attribute mti_svvh_generic_type of ICW3 : constant is 1;
    attribute mti_svvh_generic_type of ICW4 : constant is 1;
    attribute mti_svvh_generic_type of OCW1 : constant is 1;
    attribute mti_svvh_generic_type of OCW2 : constant is 1;
    attribute mti_svvh_generic_type of OCW3 : constant is 1;
    attribute mti_svvh_generic_type of NON_SPECIFIC_EOI : constant is 1;
    attribute mti_svvh_generic_type of SPECIFIC_EOI : constant is 1;
    attribute mti_svvh_generic_type of ROTATE_NON_SPECIFIC_EOI : constant is 1;
    attribute mti_svvh_generic_type of ROTATE_AEOI_SET : constant is 1;
    attribute mti_svvh_generic_type of ROTATE_AEOI_CLEAR : constant is 1;
end Control_Logic;
