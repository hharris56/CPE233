library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FLAG_MUX is
    Port ( Ain : in STD_LOGIC;
           Bin : in STD_LOGIC;
           SEL : in STD_LOGIC;
           Dout : out STD_LOGIC);
end FLAG_MUX;

architecture Behavioral of FLAG_MUX is

begin
    Dout <= Ain when (SEL = '0') else
            Bin when (SEL = '1') else
            '0';

end Behavioral;