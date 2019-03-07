library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity PCWrapper is
    Port ( RST_IN       : in STD_LOGIC;
           PC_LD_IN     : in STD_LOGIC;
           PC_INC_IN    : in STD_LOGIC;
           CLK          : in STD_LOGIC;
           MUX_SEL      : in STD_LOGIC_VECTOR (1 downto 0);
           FROM_IMM     : in STD_LOGIC_VECTOR (9 downto 0);
           FROM_STACK   : in STD_LOGIC_VECTOR (9 downto 0);
           Dout         : out STD_LOGIC_VECTOR (9 downto 0));
end PCWrapper;

architecture Behavioral of PCWrapper is

component Counter is

    Port ( RST      : in STD_LOGIC;
           PC_LD    : in STD_LOGIC;
           PC_INC   : in STD_LOGIC;
           CLK      : in STD_LOGIC;
           DIN      : in STD_LOGIC_VECTOR (9 downto 0);
           PC_OUT   : out STD_LOGIC_VECTOR (9 downto 0));
end component;

component MUX_4x1 is

    Port ( Ain  : in STD_LOGIC_VECTOR (9 downto 0);
           Bin  : in STD_LOGIC_VECTOR (9 downto 0);
           Cin  : in STD_LOGIC_VECTOR (9 downto 0);
           Din  : in STD_LOGIC_VECTOR (9 downto 0);
           SEL  : in STD_LOGIC_VECTOR (1 downto 0);
           Dout : out STD_LOGIC_VECTOR (9 downto 0));
           
end component;

signal MuxOut : STD_LOGIC_VECTOR (9 downto 0) := (others => 'Z');

begin

    Mux1: MUX_4x1 port map ( Ain => FROM_IMM,
                             Bin => FROM_STACK,
                             Cin => "1111111111",
                             Din => (others => 'Z'),
                             SEL => MUX_SEL,
                             Dout => MuxOut);
    
    Counter1: Counter port map ( RST => RST_IN,
                                 PC_LD => PC_LD_IN,
                                 PC_INC => PC_INC_IN,
                                 CLK => CLK,
                                 DIN => MuxOut,
                                 PC_OUT => Dout);


end Behavioral;
