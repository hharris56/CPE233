
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Reg_File is
    Port ( WR       : in STD_LOGIC;
           ADRX     : in STD_LOGIC_VECTOR (4 downto 0);
           ADRY     : in STD_LOGIC_VECTOR (4 downto 0);
           CLK      : in STD_LOGIC;
           DX_Out   : out STD_LOGIC_VECTOR (7 downto 0);
           DY_Out   : out STD_LOGIC_VECTOR (7 downto 0);
           Din      : in STD_LOGIC_VECTOR (7 downto 0));
end Reg_File;

architecture Behavioral of Reg_File is
	TYPE memory is array (0 to 31) of std_logic_vector(7 downto 0);
    SIGNAL REG: memory := (others=>(others=>'0'));
begin

process(clk)
begin
        if (rising_edge(clk)) then
            if (WR = '1') then
                REG(conv_integer(ADRX)) <= Din;
            end if;
        end if;
end process;

DX_Out <= REG(conv_integer(ADRX));     
DY_Out <= REG(conv_integer(ADRY));

end Behavioral;
