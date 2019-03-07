library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity INTWrapper is
    Port ( INT : in STD_LOGIC;
           I_SET : in STD_LOGIC;
           I_CLR : in STD_LOGIC;
           CLK : in STD_LOGIC;
           INT_OUT : out STD_LOGIC);
end INTWrapper;

architecture Behavioral of INTWrapper is

component Int_FlipFlop
    Port (  I_SET   : in STD_LOGIC;
            CLK     : in STD_LOGIC;
            I_CLR   : in STD_LOGIC;
            DOUT    : out STD_LOGIC);
end component;

signal I_OUT : STD_LOGIC;
begin

Flip: Int_FlipFLop port map ( I_SET => I_SET,
                              CLK   => CLK,
                              I_CLR => I_CLR,
                              DOUT  => I_OUT);
                              
    INT_OUT <= (INT AND I_OUT);

end Behavioral;
