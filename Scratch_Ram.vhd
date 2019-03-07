library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Scratch_Ram is
    Port ( DATA_IN  : in STD_LOGIC_VECTOR (9 downto 0);
           WE       : in STD_LOGIC;
           ADDR     : in STD_LOGIC_VECTOR (7 downto 0);
           CLK      : in STD_LOGIC;
           DATA_OUT : out STD_LOGIC_VECTOR (9 downto 0));
end Scratch_Ram;

architecture Behavioral of Scratch_Ram is

type memory is ARRAY(255 downto 0) of STD_LOGIC_VECTOR(9 downto 0);
signal RAM : memory := (others => (others => '0'));

begin

    process (CLK, WE)
    begin
    
    if (rising_edge(CLK)) then
        if (WE = '1') then
            RAM(conv_integer(ADDR)) <= DATA_IN;
        end if;
    end if;
    end process;

    DATA_OUT <= RAM(conv_integer(ADDR));

end Behavioral;
