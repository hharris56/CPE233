library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Int_FlipFlop is
    Port ( I_SET    : in STD_LOGIC;
           CLK      : in STD_LOGIC;
           I_CLR    : in STD_LOGIC;
           DOUT     : out STD_LOGIC);
end Int_FlipFlop;

architecture Behavioral of Int_FlipFlop is

signal temp : STD_LOGIC;

begin
    process(Clk)
    begin
        if (rising_edge (CLK)) then
            if (I_CLR = '1') then
                temp <= '0';
            elsif (I_SET = '1') then
                temp <= '1';
            end if;
        end if;
    end process;
                

end Behavioral;
