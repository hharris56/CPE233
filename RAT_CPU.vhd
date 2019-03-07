library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RAT_CPU is
    Port ( INT          : in STD_LOGIC;
           RESET        : in STD_LOGIC;
           Cin          : in STD_LOGIC;
           Zin          : in STD_LOGIC;
           CLK          : in STD_LOGIC;
           IN_PORT      : in STD_LOGIC_VECTOR (7 downto 0);
           IO_STRB      : out STD_LOGIC;
           OUT_PORT     : out STD_LOGIC_VECTOR (7 downto 0);
           PORT_ID      : out STD_LOGIC_VECTOR (7 downto 0));       
end RAT_CPU;

architecture Behavioral of RAT_CPU is

component MCU_Wrapper
    Port ( IN_PORT      : in STD_LOGIC_VECTOR (7 downto 0);
           CLK          : in STD_LOGIC;
           PC_RST       : in STD_LOGIC;
           PC_LD        : in STD_LOGIC;
           PC_INC       : in STD_LOGIC;
           PC_MUX_SEL   : in STD_LOGIC_VECTOR (1 downto 0);
           RF_WR_SEL    : in STD_LOGIC_VECTOR (1 downto 0);
           RF_WR        : in STD_LOGIC;
           ALU_SEL      : in STD_LOGIC_VECTOR (3 downto 0);
           ALU_OPY_SEL  : in STD_LOGIC;
           FLG_C_SET    : in STD_LOGIC;
           FLG_C_CLR    : in STD_LOGIC;
           FLG_C_LD     : in STD_LOGIC;
           FLG_Z_LD     : in STD_LOGIC;
           FLG_LD_SEL   : in STD_LOGIC;
           FLG_SHAD_LD  : in STD_LOGIC;
           SP_RST       : in STD_LOGIC;
           SP_LD        : in STD_LOGIC;
           SP_INCR      : in STD_LOGIC;
           SP_DECR      : in STD_LOGIC;
           SCR_DATA_SEL : in STD_LOGIC;
           SCR_WE       : in STD_LOGIC;
           SCR_ADDR_SEL : in STD_LOGIC_VECTOR (1 downto 0);
           IR_OUT       : out STD_LOGIC_VECTOR (17 downto 0);
           PORT_ID      : out STD_LOGIC_VECTOR (7 downto 0);
           OUT_PORT     : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component Control
    Port (  CLK           : in   STD_LOGIC;
            C             : in   STD_LOGIC;
            Z             : in   STD_LOGIC;
            INT           : in   STD_LOGIC;
            RST           : in   STD_LOGIC;
            OPCODE_HI_5   : in   STD_LOGIC_VECTOR (4 downto 0);
            OPCODE_LO_2   : in   STD_LOGIC_VECTOR (1 downto 0);
       
            PC_LD         : out  STD_LOGIC;
            PC_INC        : out  STD_LOGIC;
            PC_RESET      : out  STD_LOGIC;      
            PC_MUX_SEL    : out  STD_LOGIC_VECTOR (1 downto 0);
            SP_LD         : out  STD_LOGIC;
            SP_RESET      : out  STD_LOGIC;
            SP_INC        : out  STD_LOGIC;
            SP_DEC        : out  STD_LOGIC;
            RF_WR         : out  STD_LOGIC;
            RF_WR_SEL     : out  STD_LOGIC_VECTOR (1 downto 0);
            ALU_OPY_SEL   : out  STD_LOGIC;
            ALU_SEL       : out  STD_LOGIC_VECTOR (3 downto 0);
            SCR_WR        : out  STD_LOGIC;
            SCR_DATA_SEL  : out  STD_LOGIC;
            SCR_ADDR_SEL  : out  STD_LOGIC_VECTOR (1 downto 0);
            C_FLAG_SEL    : out  STD_LOGIC_VECTOR (1 downto 0);
            C_FLAG_LD     : out  STD_LOGIC;
            C_FLAG_SET    : out  STD_LOGIC;
            C_FLAG_CLR    : out  STD_LOGIC;
            Z_FLAG_SEL    : out  STD_LOGIC_VECTOR (1 downto 0);
            Z_FLAG_LD     : out  STD_LOGIC;
            FLG_LD_SEL    : out  STD_LOGIC;
            FLG_SHAD_LD   : out  STD_LOGIC;
            I_FLAG_SET    : out  STD_LOGIC;
            I_FLAG_CLR    : out  STD_LOGIC;
            IO_OE         : out  STD_LOGIC);
end component;

component INTWrapper
    Port (  INT     : in STD_LOGIC;
            I_SET   : in STD_LOGIC;
            I_CLR   : in STD_LOGIC;
            CLK     : in STD_LOGIC;
            INT_OUT : out STD_LOGIC);
end component;

signal IRout : STD_LOGIC_VECTOR (17 downto 0);
signal Int_set , Int_clr, IntOut : STD_LOGIC;
signal PC_LD_S , PC_INC_S, RST_S : STD_LOGIC;
signal SP_LD_S, SP_INCR_S, SP_DECR_S : STD_LOGIC;
signal RF_WR_S : STD_LOGIC;
signal ALU_OPY_SEL_S : STD_LOGIC;
signal SCR_WR_S, SCR_DATA_SEL_S : STD_LOGIC;
signal FLG_C_LD_S, FLG_C_SET_S, FLG_C_CLR_S, FLG_Z_LD_S, FLG_LD_SEL_S, FLG_SHAD_LD_S : STD_LOGIC;
signal PC_MUX_SEL_S, RF_WR_SEL_S, SCR_ADDR_SEL_S  : STD_LOGIC_VECTOR (1 downto 0);
signal ALU_SEL_S : STD_LOGIC_VECTOR (3 downto 0);

begin

INTW: INTWrapper port map (  INT     => INT,
                             I_SET   => Int_set,
                             I_CLR   => Int_clr,
                             CLK     => CLK,
                             INT_OUT => IntOut);


CPU: Control port map(   CLK           => CLK,
                              C             => Cin,
                              Z             => Zin,
                              INT           => IntOut,
                              RST           => RESET,
                              OPCODE_HI_5   => IRout (17 downto 13),
                              OPCODE_LO_2   => IRout (1 downto 0),

                              PC_LD         => PC_LD_S,
                              PC_INC        => PC_INC_S,
                              PC_RESET      => RST_S,
                              PC_MUX_SEL    => PC_MUX_SEL_S,
                              SP_LD         => SP_LD_S,
                              SP_RESET      => RST_S,
                              SP_INC        => SP_INCR_S,
                              SP_DEC        => SP_DECR_S,
                              RF_WR         => RF_WR_S,
                              RF_WR_SEL     => RF_WR_SEL_S,
                              ALU_OPY_SEL   => ALU_OPY_SEL_S,
                              ALU_SEL       => ALU_SEL_S,
                              SCR_WR        => SCR_WR_S,
                              SCR_DATA_SEL  => SCR_DATA_SEL_S,
                              SCR_ADDR_SEL  => SCR_ADDR_SEL_S,
                              C_FLAG_LD     => FLG_C_LD_S,
                              C_FLAG_SET    => FLG_C_SET_S,
                              C_FLAG_CLR    => FLG_C_CLR_S,
                              Z_FLAG_LD     => FLG_Z_LD_S,
                              FLG_LD_SEL    => FLG_LD_SEL_S,
                              FLG_SHAD_LD   => FLG_SHAD_LD_S,
                              I_FLAG_SET    => Int_set,
                              I_FLAG_CLR    => Int_clr,
                              IO_OE         => IO_STRB);

MCUW: MCU_Wrapper port map( IN_PORT      => IN_PORT,
                            CLK          => CLK,
                            PC_RST       => RST_S,
                            PC_LD        => PC_LD_S,
                            PC_INC       => PC_INC_S,
                            PC_MUX_SEL   => PC_MUX_SEL_S,
                            RF_WR_SEL    => RF_WR_SEL_S,
                            RF_WR        => RF_WR_S,
                            ALU_SEL      => ALU_SEL_S,
                            ALU_OPY_SEL  => ALU_OPY_SEL_S,
                            FLG_C_SET    => FLG_C_SET_S,
                            FLG_C_CLR    => FLG_C_CLR_S,
                            FLG_C_LD     => FLG_C_LD_S,
                            FLG_Z_LD     => FLG_Z_LD_S,
                            FLG_LD_SEL   => FLG_LD_SEL_S,
                            FLG_SHAD_LD  => FLG_SHAD_LD_S,
                            SP_RST       => RST_S,
                            SP_LD        => SP_LD_S,
                            SP_INCR      => SP_INCR_S,
                            SP_DECR      => SP_DECR_S,
                            SCR_DATA_SEL => SCR_DATA_SEL_S,
                            SCR_WE       => SCR_WR_S,
                            SCR_ADDR_SEL => SCR_ADDR_SEL_S,
                            IR_OUT       => IRout,
                            PORT_ID      => PORT_ID,
                            OUT_PORT     => OUT_PORT);

end Behavioral;