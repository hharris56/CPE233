library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FLAGWrapper is
    Port ( C            : in STD_LOGIC;
           Z            : in STD_LOGIC;
           FLG_C_SET    : in STD_LOGIC;
           FLG_C_CLR    : in STD_LOGIC;
           FLG_C_LD     : in STD_LOGIC;
           FLG_Z_LD     : in STD_LOGIC;
           FLG_LD_SEL   : in STD_LOGIC;
           FLG_SHAD_LD  : in STD_LOGIC;
           CLK          : in STD_LOGIC;
           C_FLG        : out STD_LOGIC;
           Z_FLG        : out STD_LOGIC);
end FLAGWrapper;

architecture Behavioral of FLAGWrapper is

component Flags
        Port ( IN_FLAG  : in STD_LOGIC;
               FLG_LD   : in STD_LOGIC;
               FLG_SET  : in STD_LOGIC;
               FLG_CLR  : in STD_LOGIC;
               CLK      : in STD_LOGIC;
               FLG_OUT  : out STD_LOGIC);
end component;

component SHAD_FLAG
    Port ( IN_FLG   : in STD_LOGIC;
           LD       : in STD_LOGIC;
           CLK      : in STD_LOGIC;
           OUT_FLG  : out STD_LOGIC);
end component;

component FLAG_MUX
    Port ( Ain : in STD_LOGIC;
           Bin : in STD_LOGIC;
           SEL : in STD_LOGIC;
           Dout : out STD_LOGIC);
end component;

signal C_IN, Z_IN: STD_LOGIC;
signal C_OUT, Z_OUT: STD_LOGIC;
signal SHAD_C_OUT, SHAD_Z_OUT : STD_LOGIC;

begin

MUX_C : FLAG_MUX port map ( Ain => C,
                            Bin => SHAD_C_OUT,
                            SEL => FLG_LD_SEL,
                            Dout => C_IN);

MUX_Z : FLAG_MUX port map ( Ain => Z,
                            Bin => SHAD_Z_OUT,
                            SEL => FLG_LD_SEL,
                            Dout => Z_IN);

FLAG_C : Flags port map ( IN_FLAG => C,
                          FLG_LD => FLG_C_LD,
                          FLG_SET => FLG_C_SET,
                          FLG_CLR => FLG_C_CLR,
                          CLK => CLK,
                          FLG_OUT => C_OUT);

FLAG_Z : Flags port map ( IN_FLAG => Z,
                          FLG_LD => FLG_Z_LD,
                          FLG_SET => '0',
                          FLG_CLR => '0',
                          CLK => CLK,
                          FLG_OUT => Z_OUT);

SHAD_C : SHAD_FLAG port map ( IN_FLG => C_OUT,
                              LD     => FLG_SHAD_LD,
                              CLK    => CLK,
                              OUT_FLG => C_FLG);
                         
SHAD_Z : SHAD_FLAG port map ( IN_FLG => Z_OUT,
                              LD     => FLG_SHAD_LD,
                              CLK    => CLK,
                              OUT_FLG => Z_FLG);

C_FLG <= C_OUT;
Z_FLG <= Z_OUT;
end Behavioral;
