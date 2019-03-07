library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Flags is
    Port ( IN_FLAG  : in STD_LOGIC;
           FLG_LD   : in STD_LOGIC;
           FLG_SET  : in STD_LOGIC;
           FLG_CLR  : in STD_LOGIC;
           CLK      : in STD_LOGIC;
           FLG_OUT  : out STD_LOGIC);
end Flags;

architecture Behavioral of Flags is

begin
    
    process (CLK)
    begin
        if (rising_edge(CLK)) then
            if (FLG_LD = '1') then
                FLG_OUT <= IN_FLAG;
            elsif (FLG_SET = '1') then
                FLG_OUT <= '1';
            elsif (FLG_CLR = '1') then
                FlG_OUT <= '0';
            end if;
         end if;
    end process;

end Behavioral;
