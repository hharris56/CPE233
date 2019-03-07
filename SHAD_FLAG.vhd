

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SHAD_FLAG is
    Port ( IN_FLG   : in STD_LOGIC;
           LD       : in STD_LOGIC;
           CLK      : in STD_LOGIC;
           OUT_FLG  : out STD_LOGIC);
end SHAD_FLAG;

architecture Behavioral of SHAD_FLAG is

begin
    process (CLK)
    begin
        if (rising_edge(CLK)) then
            if (LD = '1') then
                OUT_FLG <= IN_FLG;
            else
                OUT_FLG <= '0';
            end if;
        end if;
    end process;

end Behavioral;
