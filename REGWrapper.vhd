library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REGWrapper is
    Port ( RF_WR : in STD_LOGIC;
           CLK : in STD_LOGIC;
           RF_WR_SEL : in STD_LOGIC_VECTOR (1 downto 0);
           Ain : in STD_LOGIC_VECTOR (7 downto 0);
           Bin : in STD_LOGIC_VECTOR (7 downto 0);
           Cin : in STD_LOGIC_VECTOR (7 downto 0);
           Din : in STD_LOGIC_VECTOR (7 downto 0);
           ADRX : in STD_LOGIC_VECTOR (4 downto 0);
           ADRY : in STD_LOGIC_VECTOR (4 downto 0);
           DX_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           DY_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end REGWrapper;

architecture Behavioral of REGWrapper is

component REG_MUX
    Port ( Ain : in STD_LOGIC_VECTOR (7 downto 0);
           Bin : in STD_LOGIC_VECTOR (7 downto 0);
           Cin : in STD_LOGIC_VECTOR (7 downto 0);
           Din : in STD_LOGIC_VECTOR (7 downto 0);
           SEL : in STD_LOGIC_VECTOR (1 downto 0);
           Dout : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component Reg_File
    Port ( WR       : in STD_LOGIC;
           ADRX     : in STD_LOGIC_VECTOR (4 downto 0);
           ADRY     : in STD_LOGIC_VECTOR (4 downto 0);
           CLK      : in STD_LOGIC;
           DX_Out   : out STD_LOGIC_VECTOR (7 downto 0);
           DY_Out   : out STD_LOGIC_VECTOR (7 downto 0);
           Din      : in STD_LOGIC_VECTOR (7 downto 0));
end component;

signal MuxOut : STD_LOGIC_VECTOR (7 downto 0);

begin

Mux1: REG_MUX port map( Ain => Ain,
                        Bin => Bin,
                        Cin => Cin,
                        Din => Din,
                        SEL => RF_WR_SEL,
                        Dout => MuxOut);

Reg1: Reg_File port map( WR => RF_WR,
                         ADRX => ADRX,
                         ADRY => ADRY,
                         CLK => CLK,
                         Din => MuxOut,
                         DX_Out => DX_Out,
                         DY_Out => DY_Out);

end Behavioral;
