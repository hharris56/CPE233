
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_MUX is
    Port ( Ain : in STD_LOGIC_VECTOR (7 downto 0);
           Bin : in STD_LOGIC_VECTOR (7 downto 0);
           SEL : in STD_LOGIC;
           Dout : out STD_LOGIC_VECTOR (7 downto 0));
end ALU_MUX;

architecture Behavioral of ALU_MUX is

begin 
    Dout <= Ain when (SEL = '0') else
            Bin when (SEL = '1') else
            "00000000" ;

end Behavioral;
