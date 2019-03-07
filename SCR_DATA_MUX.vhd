
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity SCR_DATA_MUX is
    Port ( Ain : in STD_LOGIC_VECTOR (7 downto 0);
           Bin : in STD_LOGIC_VECTOR (9 downto 0);
           SEL : in STD_LOGIC;
           Dout : out STD_LOGIC_VECTOR (9 downto 0));
end SCR_DATA_MUX;

architecture Behavioral of SCR_DATA_MUX is

begin
    
    Dout <= ("00" & Ain) when (SEL = '0') else
            Bin when (SEl = '1') else
            "0000000000";


end Behavioral;
