library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is
    Port ( CIN      : in STD_LOGIC;
           SEL      : in STD_LOGIC_VECTOR (3 downto 0);
           A        : in STD_LOGIC_VECTOR (7 downto 0);
           B        : in STD_LOGIC_VECTOR (7 downto 0);
           Result   : out STD_LOGIC_VECTOR (7 downto 0);
           C        : out STD_LOGIC;
           Z        : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is

signal  temp : STD_LOGIC_VECTOR (8 downto 0);

begin
    
    process (A, B, SEL, CIN)
    begin
    
    case SEL is
        when "0000" => temp <= ('0' & A) + B;
        when "0001" => temp <= ('0' & A) + B + CIN;
        when "0010" => temp <= ('0' & A) - B;
        when "0011" => temp <= ('0' & A) - B - CIN;
        when "0100" => temp <= ('0' & A) - B;
        when "0101" => temp <= ('0' & A) AND ('0' & B);
        when "0110" => temp <= ('0' & A) OR ('0' & B);
        when "0111" => temp <= ('0' & A) XOR ('0' & B);
        when "1000" => temp <= ('0' & A) AND ('0' & B);
        when "1001" => temp <= A & Cin;
        when "1010" => temp <= A(0) & Cin & A(7 downto 1);
        when "1011" => temp <= A(7 downto 0) & A(7);
        when "1100" => temp <= A(0) & A(0) & A(7 downto 1);
        when "1101" => temp <= A(0) & A(7) & A(7 downto 1);
        when "1110" => temp <= '0' & B;
        when "1111" => temp <= "00000000";
        when others => temp <= (others => '0');
    end case;
    end process;
    
    C <= temp(9);
    Z <= '1' when (temp = "000000000" or temp = "100000000") else '0';
    Result <= temp(7 downto 0);

end Behavioral;
