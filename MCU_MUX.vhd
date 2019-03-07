
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REG_MUX is
    Port ( Ain : in STD_LOGIC_VECTOR (7 downto 0);
           Bin : in STD_LOGIC_VECTOR (7 downto 0);
           Cin : in STD_LOGIC_VECTOR (7 downto 0);
           Din : in STD_LOGIC_VECTOR (7 downto 0);
           SEL : in STD_LOGIC_VECTOR (1 downto 0);
           Dout : out STD_LOGIC_VECTOR (7 downto 0));
end REG_MUX;

architecture Behavioral of REG_MUX is

begin
    Dout <= Ain when (SEL = "00") else
            Bin when (SEL = "01") else
            Cin when (SEL = "10") else
            Din when (SEL = "11") else
            "00000000";

end Behavioral;
