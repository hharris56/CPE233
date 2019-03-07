library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity SCRWrapper is
    Port ( SCR_DATA_SEL : in STD_LOGIC;
           SCR_DATA_Ain : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_DATA_Bin : in STD_LOGIC_VECTOR (9 downto 0);
           SCR_WE       : in STD_LOGIC;
           SCR_MUX_Ain  : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_MUX_Bin  : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_MUX_Cin  : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_MUX_Din  : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_MUX_SEL  : in STD_LOGIC_VECTOR (1 downto 0);
           CLK          : in STD_LOGIC;
           DATA_OUT     : out STD_LOGIC_VECTOR (9 downto 0));
end SCRWrapper;

architecture Behavioral of SCRWrapper is

component SCR_DATA_MUX is
    Port ( Ain : in STD_LOGIC_VECTOR (7 downto 0);
           Bin : in STD_LOGIC_VECTOR (9 downto 0);
           SEL : in STD_LOGIC;
           Dout : out STD_LOGIC_VECTOR (9 downto 0));
end component;

component SCR_MUX is
    Port ( Ain : in STD_LOGIC_VECTOR (7 downto 0);
           Bin : in STD_LOGIC_VECTOR (7 downto 0);
           Cin : in STD_LOGIC_VECTOR (7 downto 0);
           Din : in STD_LOGIC_VECTOR (7 downto 0);
           SEL : in STD_LOGIC_VECTOR (1 downto 0);
           Dout : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component Scratch_Ram is
    Port ( DATA_IN  : in STD_LOGIC_VECTOR (9 downto 0);
           WE       : in STD_LOGIC;
           ADDR     : in STD_LOGIC_VECTOR (7 downto 0);
           CLK      : in STD_LOGIC;
           DATA_OUT : out STD_LOGIC_VECTOR (9 downto 0));
end component;

signal SCR_DATA : STD_LOGIC_VECTOR (9 downto 0);
signal Mux : STD_LOGIC_VECTOR (7 downto 0);

begin

DATA_MUX : SCR_DATA_MUX port map( Ain => SCR_DATA_Ain,
                                  Bin => SCR_DATA_Bin,
                                  SEL => SCR_DATA_SEL,
                                  Dout => SCR_DATA);

SCR_MUX1 : SCR_MUX port map( Ain => SCR_MUX_Ain,
                             Bin => SCR_MUX_Bin,
                             Cin => SCR_MUX_Cin,
                             Din => SCR_MUX_Din,
                             SEL => SCR_MUX_SEL,
                             Dout => Mux);
                          
SCR : Scratch_Ram port map ( DATA_IN => SCR_DATA,
                             WE => SCR_WE,
                             ADDR => Mux,
                             CLK => CLK,
                             DATA_OUT => DATA_OUT);
                             
end Behavioral;
