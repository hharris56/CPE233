library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Stack_Pointer is
    Port ( RST      : in STD_LOGIC;
           SP_LD    : in STD_LOGIC;
           SP_INCR  : in STD_LOGIC;
           SP_DECR  : in STD_LOGIC;
           CLK      : in STD_LOGIC;
           Din      : in STD_LOGIC_VECTOR (7 downto 0);
           Dout     : out STD_LOGIC_VECTOR (7 downto 0));
end Stack_Pointer;

architecture Behavioral of Stack_Pointer is

signal temp : STD_LOGIC_VECTOR (7 downto 0);

begin

    process (CLK)
    begin
        if (RST ='1') then
            temp <= "00000000";
        elsif (rising_edge (CLK)) then
            if (SP_LD = '1') then
                temp <= Din;
            elsif (SP_INCR = '1') then
                temp <= temp + 1;
            elsif (SP_DECR = '1') then
                temp <= temp - 1;
            end if;
        end if;
    end process;

end Behavioral;
