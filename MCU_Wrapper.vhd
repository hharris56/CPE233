
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity MCU_Wrapper is
    Port ( IN_PORT      : in STD_LOGIC_VECTOR (7 downto 0);
           CLK          : in STD_LOGIC;
           PC_RST       : in STD_LOGIC;
           PC_LD        : in STD_LOGIC;
           PC_INC       : in STD_LOGIC;
           PC_MUX_SEL   : in STD_LOGIC_VECTOR (1 downto 0);
           RF_WR_SEL    : in STD_LOGIC_VECTOR (1 downto 0);
           RF_WR        : in STD_LOGIC;
           ALU_SEL      : in STD_LOGIC_VECTOR (3 downto 0);
           ALU_OPY_SEL  : in STD_LOGIC;
           FLG_C_SET    : in STD_LOGIC;
           FLG_C_CLR    : in STD_LOGIC;
           FLG_C_LD     : in STD_LOGIC;
           FLG_Z_LD     : in STD_LOGIC;
           FLG_LD_SEL   : in STD_LOGIC;
           FLG_SHAD_LD  : in STD_LOGIC;
           SP_RST       : in STD_LOGIC;
           SP_LD        : in STD_LOGIC;
           SP_INCR      : in STD_LOGIC;
           SP_DECR      : in STD_LOGIC;
           SCR_DATA_SEL : in STD_LOGIC;
           SCR_WE       : in STD_LOGIC;
           SCR_ADDR_SEL : in STD_LOGIC_VECTOR (1 downto 0);
           IR_OUT       : out STD_LOGIC_VECTOR (7 downto 0);
           PORT_ID      : out STD_LOGIC_VECTOR (7 downto 0);
           OUT_PORT     : out STD_LOGIC_VECTOR (7 downto 0));
end MCU_Wrapper;

architecture Behavioral of MCU_Wrapper is

component PCWrapper
    Port ( RST_IN       : in STD_LOGIC;
           PC_LD_IN     : in STD_LOGIC;
           PC_INC_IN    : in STD_LOGIC;
           CLK          : in STD_LOGIC;
           MUX_SEL      : in STD_LOGIC_VECTOR (1 downto 0);
           FROM_IMM     : in STD_LOGIC_VECTOR (9 downto 0);
           FROM_STACK   : in STD_LOGIC_VECTOR (9 downto 0);
           Dout         : out STD_LOGIC_VECTOR (9 downto 0));
end component;

component prog_rom
   port ( ADDRESS : in std_logic_vector(9 downto 0); 
          INSTRUCTION : out std_logic_vector(17 downto 0); 
          CLK : in std_logic); 
end component;

component REGWrapper
    Port ( RF_WR        : in STD_LOGIC;
           CLK          : in STD_LOGIC;
           RF_WR_SEL    : in STD_LOGIC_VECTOR (1 downto 0);
           Ain          : in STD_LOGIC_VECTOR (7 downto 0);
           Bin          : in STD_LOGIC_VECTOR (7 downto 0);
           Cin          : in STD_LOGIC_VECTOR (7 downto 0);
           Din          : in STD_LOGIC_VECTOR (7 downto 0);
           ADRX         : in STD_LOGIC_VECTOR (4 downto 0);
           ADRY         : in STD_LOGIC_VECTOR (4 downto 0);
           DX_OUT       : out STD_LOGIC_VECTOR (7 downto 0);
           DY_OUT       : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component ALUWrapper
    Port ( CIN          : in STD_LOGIC;
           ALU_SEL      : in STD_LOGIC_VECTOR (3 downto 0);
           A            : in STD_LOGIC_VECTOR (8 downto 0);
           Ain          : in STD_LOGIC_VECTOR (7 downto 0);
           Bin          : in STD_LOGIC_VECTOR (7 downto 0);
           ALU_OPY_SEL  : in STD_LOGIC;
           Result       : out STD_LOGIC_VECTOR (7 downto 0);
           C            : out STD_LOGIC;
           Z            : out STD_LOGIC);
end component;

component FLAGWrapper
    Port ( C            : in STD_LOGIC;
           Z            : in STD_LOGIC;
           FLG_C_SET    : in STD_LOGIC;
           FLG_C_CLR    : in STD_LOGIC;
           FLG_C_LD     : in STD_LOGIC;
           FLG_Z_LD     : in STD_LOGIC;
           FLG_LD_SEL   : in STD_LOGIC;
           FLG_SHAD_LD  : in STD_LOGIC;
           CLK          : in STD_LOGIC;
           C_FLG        : out STD_LOGIC;
           Z_FLG        : out STD_LOGIC);
end component;

component Stack_Pointer
    Port ( RST      : in STD_LOGIC;
           SP_LD    : in STD_LOGIC;
           SP_INCR  : in STD_LOGIC;
           SP_DECR  : in STD_LOGIC;
           CLK      : in STD_LOGIC;
           Din      : in STD_LOGIC_VECTOR (7 downto 0);
           Dout     : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component SCRWrapper
    Port ( SCR_DATA_SEL : in STD_LOGIC;
           SCR_DATA_Ain : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_DATA_Bin : in STD_LOGIC_VECTOR (9 downto 0);
           SCR_WE       : in STD_LOGIC;
           SCR_MUX_Ain  : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_MUX_Bin  : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_MUX_Cin  : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_MUX_Din  : in STD_LOGIC_VECTOR (7 downto 0);
           SCR_MUX_SEL  : in STD_LOGIC_VECTOR (1 downto 0);
           CLK          : in STD_LOGIC;
           DATA_OUT     : out STD_LOGIC_VECTOR (9 downto 0));
end component;

signal IMMED, STACK, PC_COUNT : STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
signal IR : STD_LOGIC_VECTOR (17 downto 0);
signal ALU_A, SCR_B, SP_C, DX, DY : STD_LOGIC_VECTOR (7 downto 0);
signal C_FLG_OUT, Z_FLG_OUT, ALU_C, ALU_Z : STD_LOGIC;
signal ALU_RESULT : STD_LOGIC_VECTOR (7 downto 0);
signal SP_OUT, SP_OUT2 : STD_LOGIC_VECTOR (7 downto 0);
signal SCR_OUT : STD_LOGIC_VECTOR (9 downto 0);
begin

PC: PCWrapper port map( RST_IN      => PC_RST,
                        PC_LD_IN    => PC_LD,
                        PC_INC_IN   => PC_INC,
                        CLK         => CLK,
                        MUX_SEL     => PC_MUX_SEL,
                        FROM_IMM    => IMMED,
                        FROM_STACK  => STACK,
                        Dout        => PC_COUNT);

P_Rom: prog_rom port map( ADDRESS       => PC_COUNT,
                          INSTRUCTION   => IR,
                          CLK           => CLK);

Reg: REGWrapper port map ( RF_WR     => RF_WR,
                           CLK       => CLK,
                           RF_WR_SEL => RF_WR_SEL,
                           Ain       => ALU_A,
                           Bin       => SCR_B,
                           Cin       => SP_C,
                           Din       => IN_PORT,
                           ADRX      => IR(12 downto 8),
                           ADRY      => IR(7 downto 3),
                           DX_OUT    => DX,
                           DY_OUT    => DY);

ALU: ALUWrapper port map (  CIN         => C_FLG_OUT,
                            ALU_SEL     => ALU_SEL,
                            A           => DX,
                            Ain         => DY,
                            Bin         => IR(7 downto 0),
                            ALU_OPY_SEL => ALU_OPY_SEL,
                            Result      => ALU_RESULT,
                            C           => ALU_C,
                            Z           => ALU_Z);

FLG: FLAGWrapper port map ( C            => ALU_C,
                            Z            => ALU_Z,
                            FLG_C_SET    => FLG_C_SET,
                            FLG_C_CLR    => FLG_C_CLR,
                            FLG_C_LD     => FLG_C_LD,
                            FLG_Z_LD     => FLG_Z_LD,
                            FLG_LD_SEL   => FLG_LD_SEL,
                            FLG_SHAD_LD  => FLG_SHAD_LD,
                            CLK          => CLK,
                            C_FLG        => C_FLG_OUT,
                            Z_FLG        => Z_FLG_OUT);

SP: Stack_Pointer port map ( RST      => SP_RST,
                             SP_LD    => SP_LD,
                             SP_INCR  => SP_INCR,
                             SP_DECR  => SP_DECR,
                             CLK      => CLK,
                             Din      => DX,
                             Dout     => SP_OUT);

SCR: SCRWrapper port map (SCR_DATA_SEL => SCR_DATA_SEL,
                          SCR_DATA_Ain => DX,
                          SCR_DATA_Bin => PC_COUNT,
                          SCR_WE       => SCR_WE,
                          SCR_MUX_Ain  => DY,
                          SCR_MUX_Bin  => IR (7 downto 0),
                          SCR_MUX_Cin  => SP_OUT,
                          SCR_MUX_Din  => SP_OUT2,
                          SCR_MUX_SEL  => SCR_ADDR_SEL,
                          CLK          => CLK,
                          DATA_OUT     => SCR_OUT);
SP_OUT2 <= SP_OUT - 1;
OUT_PORT <= DX;
PORT_ID <= IR(7 downto 0);
IR_OUT <= IR;

end Behavioral;