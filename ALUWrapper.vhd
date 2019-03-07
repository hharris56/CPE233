

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUWrapper is
    Port ( CIN          : in STD_LOGIC;
           ALU_SEL      : in STD_LOGIC_VECTOR (3 downto 0);
           A            : in STD_LOGIC_VECTOR (8 downto 0);
           Ain          : in STD_LOGIC_VECTOR (7 downto 0);
           Bin          : in STD_LOGIC_VECTOR (7 downto 0);
           ALU_OPY_SEL  : in STD_LOGIC;
           Result       : out STD_LOGIC_VECTOR (7 downto 0);
           C            : out STD_LOGIC;
           Z            : out STD_LOGIC);
end ALUWrapper;

architecture Behavioral of ALUWrapper is

component ALU_MUX is
    Port ( Ain : in STD_LOGIC_VECTOR (7 downto 0);
           Bin : in STD_LOGIC_VECTOR (7 downto 0);
           SEL : in STD_LOGIC;
           Dout : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component ALU is
    Port ( CIN      : in STD_LOGIC;
           SEL      : in STD_LOGIC_VECTOR (3 downto 0);
           A        : in STD_LOGIC_VECTOR (7 downto 0);
           B        : in STD_LOGIC_VECTOR (7 downto 0);
           Result   : out STD_LOGIC_VECTOR (7 downto 0);
           C        : out STD_LOGIC;
           Z        : out STD_LOGIC);

end component;

signal MuxOut : STD_LOGIC_VECTOR (7 downto 0) := (others => 'Z');

begin

    AluMux: ALU_MUX port map( Ain => Ain,
                              Bin => Bin,
                              SEL => ALU_OPY_SEL,
                              Dout => MuxOut);
    
    ALU1: ALU port map( CIN => CIN,
                        SEL => ALU_SEL,
                        A => A,
                        B => MuxOut,
                        Result => Result,
                        C => C,
                        Z => Z);
    
end Behavioral;
