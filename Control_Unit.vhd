----------------------------------------------------------------------------------
-- Company: CPE 233
-- Engineer: 
-- -------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CONTROL is
    Port ( CLK           : in   STD_LOGIC;
           C             : in   STD_LOGIC;
           Z             : in   STD_LOGIC;
           INT           : in   STD_LOGIC;
		   RST           : in   STD_LOGIC;
		   OPCODE_HI_5   : in   STD_LOGIC_VECTOR (4 downto 0);
		   OPCODE_LO_2   : in   STD_LOGIC_VECTOR (1 downto 0);
		   
           PC_LD         : out  STD_LOGIC;
		   PC_INC        : out  STD_LOGIC;
	       PC_RESET      : out  STD_LOGIC;	  
           PC_MUX_SEL    : out  STD_LOGIC_VECTOR (1 downto 0);
           SP_LD         : out  STD_LOGIC;
		   SP_RESET      : out  STD_LOGIC;
		   SP_INC        : out  STD_LOGIC;
		   SP_DEC        : out  STD_LOGIC;
           RF_WR         : out  STD_LOGIC;
		   RF_WR_SEL     : out  STD_LOGIC_VECTOR (1 downto 0);
           ALU_OPY_SEL   : out  STD_LOGIC;
           ALU_SEL       : out  STD_LOGIC_VECTOR (3 downto 0);
           SCR_WR        : out  STD_LOGIC;
           SCR_DATA_SEL  : out  STD_LOGIC;
           SCR_ADDR_SEL  : out  STD_LOGIC_VECTOR (1 downto 0);
           C_FLAG_LD     : out  STD_LOGIC;
           C_FLAG_SET    : out  STD_LOGIC;
           C_FLAG_CLR    : out  STD_LOGIC;
           Z_FLAG_LD     : out  STD_LOGIC;
           FLG_LD_SEL    : out  STD_LOGIC;
           FLG_SHAD_LD   : out  STD_LOGIC;
           I_FLAG_SET    : out  STD_LOGIC;
           I_FLAG_CLR    : out  STD_LOGIC;
		   IO_OE         : out  STD_LOGIC);
end CONTROL;

architecture Behavioral of CONTROL is

   type state_type is (ST_init, ST_fet, ST_exec, ST_inter);
      signal PS,NS : state_type;
		
	signal sig_OPCODE_7: std_logic_vector (6 downto 0);
begin
   -- concatenate the all opcodes into a 7-bit complete opcode for
	-- easy instruction decoding.
   sig_OPCODE_7 <= OPCODE_HI_5 & OPCODE_LO_2;

   sync_p: process (CLK, NS, RST)
	begin
	   if (RST = '1') then
		  PS <= ST_init;
		elsif (rising_edge(CLK)) then 
	      PS <= NS;
		end if;
	end process sync_p;


   comb_p: process (sig_OPCODE_7, PS, NS, INT, C, Z)
   begin
    
    -- This is the default block for all signals set in the STATE cases.  Note that any output values desired 
    -- to be different from these values shown below will be assigned in the individual case statements for 
	-- each STATE.  Please note that that this "default" set of values must be stated for each individual case
    -- statement.  We have a case statement for CPU states and then an embedded case statement for OPCODE 
    -- resolution. 	
    PC_LD         <= '0';   PC_MUX_SEL     <= "00";   PC_RESET <= '0';	    PC_INC <= '0';		      				
	SP_LD         <= '0';   SP_RESET       <= '0';    SP_INC    <= '0';     SP_DEC   <= '0';
	RF_WR         <= '0';   RF_WR_SEL      <= "00";   
	ALU_OPY_SEL   <= '0';   ALU_SEL        <= "0000";       			
	SCR_WR        <= '0';   SCR_ADDR_SEL   <= "00";   SCR_DATA_SEL <= '0';  
    C_FLAG_LD      <= '0';    C_FLAG_SET   <= '0';  C_FLAG_CLR <= '0';  FLG_LD_SEL <= '0';				
	Z_FLAG_LD      <= '0';    FLG_SHAD_LD  <= '0';
	I_FLAG_SET    <= '0';   I_FLAG_CLR     <= '0'; 
	IO_OE <= '0';
    
	case PS is
	
		   -- STATE: the init cycle ------------------------------------
			-- Initialize all control outputs to non-active states and reset the PC and SP to all zeros.
		when ST_init => 
		    NS <= ST_fet;	
			
			    PC_RESET     <= '1';
			    SP_RESET     <= '1';	 	
			    I_FLAG_SET   <= '1';
				
         -- STATE: the fetch cycle -----------------------------------
        when ST_fet => 
		    NS <= ST_exec;	
			
			   PC_INC <= '1';
			   
       
			   
        when ST_inter =>
       
                   NS <= ST_fet;
                   
                       PC_LD           <= '1';
                       PC_MUX_SEL      <= "10";
                       SP_DEC          <= '1';
                       SCR_WR          <= '1';
                       SCR_DATA_SEL    <= '1';
                       SCR_ADDR_SEL    <= "11";
                       FLG_SHAD_LD     <= '1';
                   
                   

			
        -- STATE: the execute cycle ---------------------------------
		when ST_exec => 
            if (INT = '0') then
                NS <= ST_fet;
            else
                NS <= ST_inter;
            end if;
				
            -- This is the default block for all signals set in the OPCODE cases.  Note that any output values desired 
            -- to be different from these values shown below will be assigned in the individual case statements for 
            -- each opcode.
            PC_LD         <= '0';   PC_MUX_SEL     <= "00";   PC_RESET <= '0';	    PC_INC <= '0';		      				
            SP_LD         <= '0';   SP_RESET       <= '0';    SP_INC    <= '0';     SP_DEC   <= '0';
            RF_WR         <= '0';   RF_WR_SEL      <= "00";   
            ALU_OPY_SEL   <= '0';   ALU_SEL        <= "0000";                   
            SCR_WR        <= '0';   SCR_ADDR_SEL   <= "00";   SCR_DATA_SEL <= '0';  
            C_FLAG_LD      <= '0';    C_FLAG_SET   <= '0';  C_FLAG_CLR <= '0';  FLG_LD_SEL <= '0';                
            Z_FLAG_LD      <= '0';    FLG_SHAD_LD  <= '0';
            I_FLAG_SET    <= '0';   I_FLAG_CLR     <= '0'; 
            IO_OE <= '0';
				
				case sig_OPCODE_7 is			
				    
				                            -- ALU --
				    
				        -- AND reg-reg --
				    when "0000000" =>
				        RF_WR           <= '1';
				        RF_WR_SEL       <= "00";
				        ALU_SEL         <= "0101";
				        ALU_OPY_SEL     <= '0';
				        C_FLAG_CLR      <= '1';
				        Z_FLAG_LD       <= '1';
				        FLG_LD_SEL      <= '0';
				        
				        -- AND reg-immed --
                    when "1000000" | "1000001" | "1000010" | "1000011" =>
				        RF_WR           <= '1';
                        RF_WR_SEL       <= "00";
                        ALU_SEL         <= "0101";
                        ALU_OPY_SEL     <= '1';
                        C_FLAG_CLR      <= '1';
                        Z_FLAG_LD       <= '1';
                        FLG_LD_SEL      <= '0';
                        
                        -- OR reg-reg --
                    when "0000001" =>
                        RF_WR           <= '1';
                        RF_WR_SEL       <= "00";
                        ALU_SEL         <= "0110";
                        ALU_OPY_SEL     <= '0';
                        C_FLAG_CLR      <= '1';
                        Z_FLAG_LD       <= '1';
                        FLG_LD_SEL      <= '0';
                        
                        -- OR reg-immed --
                    when "1000100" | "1000101" | "1000110" | "1000111" =>
                        RF_WR           <= '1';
                        RF_WR_SEL       <= "00";
                        ALU_SEL         <= "0110";
                        ALU_OPY_SEL     <= '1';
                        C_FLAG_CLR      <= '1';
                        Z_FLAG_LD       <= '1';
                        FLG_LD_SEL      <= '0';
                        
                        -- EXOR reg-reg --
                    when "0000010" =>    
                        RF_WR           <= '1';     
                        RF_WR_SEL       <= "00";
                        ALU_SEL         <= "0111";
                        ALU_OPY_SEL     <= '0';
                        C_FLAG_CLR      <= '1';
                        Z_FLAG_LD       <= '1';
                        FLG_LD_SEL      <= '0';
                                   
                        -- EXOR reg-immed --
                    when "1001000" | "1001001" | "1001010" | "1001011" =>    
                        RF_WR           <= '1';      
                        RF_WR_SEL       <= "00";
                        ALU_SEL         <= "0111";     
                        ALU_OPY_SEL     <= '1';
                        C_FLAG_CLR      <= '1';
                        Z_FLAG_LD       <= '1';
                        FLG_LD_SEL      <= '0';
                        
                        -- TEST reg-reg --
                    when "0000011" =>
                        RF_WR           <= '0';
                        ALU_SEL         <= "1000";
                        ALU_OPY_SEL     <= '0';
                        C_FLAG_CLR      <= '1';
                        Z_FLAG_LD       <= '1';
                        FLG_LD_SEL      <= '0';
                        
                        -- TEST reg-immed --
                    when "1001100" | "1001101" | "1001110" | "1001111" =>
                        RF_WR           <= '0';
                        ALU_SEL         <= "1000";
                        ALU_OPY_SEL     <= '1';
                        C_FLAG_CLR      <= '1';
                        Z_FLAG_LD       <= '1';
                        FLG_LD_SEL      <= '0';
                        
				        -- ADD reg-reg --
                    when "0000100" =>
                        RF_WR           <= '1';
                        RF_WR_SEL       <= "00";
                        ALU_SEL         <= "0000";
                        ALU_OPY_SEL     <= '0';
                        C_FLAG_LD       <= '1';
                        Z_FLAG_LD       <= '1';
                        FLG_LD_SEL      <= '0';
                        
                        -- ADD reg-immed --
                    when "1010000" | "1010001" | "1010010" | "1010011" =>
                        RF_WR           <= '1';
                        RF_WR_SEL       <= "00";
                        ALU_SEL         <= "0000";
                        ALU_OPY_SEL     <= '1';
                        C_FLAG_LD       <= '1';
                        Z_FLAG_LD       <= '1';
                        FLG_LD_SEL      <= '0';
                        
                        -- ADDC reg-reg --
                    when "0000101" =>
                        RF_WR           <= '1';
                        RF_WR_SEL       <= "00";
                        ALU_SEL         <= "0001";
                        ALU_OPY_SEL     <= '0';
                        C_FLAG_LD       <= '1';
                        Z_FLAG_LD       <= '1';
                        FLG_LD_SEL      <= '0';
                        
                        -- ADDC reg-immed --
                    when "1010100" | "1010101" | "1010110" | "1010111" =>
                        RF_WR           <= '1';
                        RF_WR_SEL       <= "00";
                        ALU_SEL         <= "0001";
                        ALU_OPY_SEL     <= '1';
                        C_FLAG_LD       <= '1';
                        Z_FLAG_LD       <= '1';
                        FLG_LD_SEL      <= '0';
                        
                        -- SUB reg-reg --
                    when "0000110" =>
                        RF_WR           <= '1';
                        RF_WR_SEL       <= "00";
                        ALU_SEL         <= "0010";
                        ALU_OPY_SEL     <= '0';
                        C_FLAG_LD       <= '1';
                        Z_FLAG_LD       <= '1';
                        FLG_LD_SEL      <= '0';
                        
                        -- SUB reg-immed --
                    when "1011000" | "1011001" | "1011010" | "1011011" =>
                        RF_WR           <= '1';
                        RF_WR_SEL       <= "00";
                        ALU_SEL         <= "0010";
                        ALU_OPY_SEL     <= '1';
                        C_FLAG_LD       <= '1';
                        Z_FLAG_LD       <= '1';
                        FLG_LD_SEL      <= '0';
                        
                        -- SUBC reg-reg --
                    when "0000111" =>
                        RF_WR           <= '1';
                        RF_WR_SEL       <= "00";
                        ALU_SEL         <= "0011";
                        ALU_OPY_SEL     <= '0';
                        C_FLAG_LD       <= '1';
                        Z_FLAG_LD       <= '1';
                        FLG_LD_SEL      <= '0';
                        
                        -- SUBC reg-immed --
                    when "1011100" | "1011101" | "1011110" | "1011111" =>
                        RF_WR           <= '1';
                        RF_WR_SEL       <= "00";
                        ALU_SEL         <= "0011";
                        ALU_OPY_SEL     <= '1';
                        C_FLAG_LD       <= '1';
                        Z_FLAG_LD       <= '1';
                        FLG_LD_SEL      <= '0';
                        
                        -- CMP reg-reg --
                    when "0001000" =>
                        ALU_SEL         <= "0100";
                        ALU_OPY_SEL     <= '0';
                        C_FLAG_LD       <= '1';
                        Z_FLAG_LD       <= '1';
                        FLG_LD_SEL      <= '0';
                        
                        -- CMP reg-immed --
                    when "1100000" | "1100001" | "1100010" | "1100011" =>
                        ALU_SEL         <= "0100";
                        ALU_OPY_SEL     <= '1';
                        C_FLAG_LD       <= '1';
                        Z_FLAG_LD       <= '1';
                        FLG_LD_SEL      <= '0';
                        
                        -- MOV reg-reg --
                    when "0001001" =>
                        RF_WR           <= '1';
                        RF_WR_SEL       <= "00";
                        ALU_SEL         <= "1110";
                        ALU_OPY_SEL     <= '0';
                        
                        -- MOV reg-immed --
                    when "1101100" | "1101101" | "1101110" | "1101111" =>
                        RF_WR           <= '1';
                        RF_WR_SEL       <= "00";
                        ALU_SEL         <= "1110";
                        ALU_OPY_SEL     <= '1';  
                                            
                        -- LD reg-reg --
                    when "0001010" =>
                        RF_WR           <= '1';
                        RF_WR_SEL       <= "01";
                        SCR_DATA_SEL    <= '0';
                        SCR_ADDR_SEL    <= "00";
                        

                        -- LD reg-immed --
                    when "1110000" | "1110001" | "1110010" | "1110011" =>
                        RF_WR           <= '1';
                        RF_WR_SEL       <= "01";
                        SCR_DATA_SEL    <= '0';
                        SCR_ADDR_SEL    <= "01";
                        
                        -- ST reg-reg --
                    when "0001011" =>
                        SCR_WR          <= '1';
                        SCR_DATA_SEL    <= '0';
                        SCR_ADDR_SEL    <= "00";
                        
                        -- ST reg-immed --
                    when "1110100" | "1110101" | "1110110" | "1110111" =>
                        SCR_WR          <= '1';
                        SCR_DATA_SEL    <= '0';
                        SCR_ADDR_SEL    <= "01";
                        
                                    -- SINGLE REG ALU --
                        
                        -- LSL --
                    when "0100000" =>
                        RF_WR           <= '1';
                        RF_WR_SEL       <= "00";
                        ALU_SEL         <= "1001";
                        ALU_OPY_SEL     <= '0';
                        C_FLAG_LD       <= '1';
                        Z_FLAG_LD       <= '1';
                        FLG_LD_SEL      <= '0';
                        
                        -- LSR --
                    when "0100001" =>
                        RF_WR           <= '1';
                        RF_WR_SEL       <= "00";
                        ALU_SEL         <= "1010";
                        ALU_OPY_SEL     <= '0';
                        C_FLAG_LD       <= '1';
                        Z_FLAG_LD       <= '1';
                        FLG_LD_SEL      <= '0';
                        
                        -- ROL --
                    when "0100010" =>
                        RF_WR           <= '1';
                        RF_WR_SEL       <= "00";
                        ALU_SEL         <= "1011";
                        ALU_OPY_SEL     <= '0';
                        C_FLAG_LD       <= '1';
                        Z_FLAG_LD       <= '1';
                        FLG_LD_SEL      <= '0';
                        
                        -- ROR --
                    when "0100011" =>
                        RF_WR           <= '1';
                        RF_WR_SEL       <= "00";
                        ALU_SEL         <= "1100";
                        ALU_OPY_SEL     <= '0';
                        C_FLAG_LD       <= '1';
                        Z_FLAG_LD       <= '1';
                        
                        -- ASR --
                    when "0100100" =>
                        RF_WR           <= '1';
                        RF_WR_SEL       <= "00";
                        ALU_SEL         <= "1101";
                        ALU_OPY_SEL     <= '0';
                        C_FLAG_LD       <= '1';
                        Z_FLAG_LD       <= '1';
                        FLG_LD_SEL      <= '0';
                        
                        -- PUSH --
                    when "0100101" =>
                        SP_DEC          <= '1';
                        SCR_WR          <= '1';
                        SCR_DATA_SEL    <= '0';
                        SCR_ADDR_SEL    <= "11";
                        
                        -- POP --
                    when "0100110" =>
                        RF_WR           <= '1';
                        RF_WR_SEL       <= "01";
                        SP_INC          <= '1';
                        SCR_ADDR_SEL    <= "10";
                        
                        -- WSP --
                    when "0101000" =>
                        SP_LD           <= '1';
                        
                                      -- INPUT OUTPUT --
                        
                        -- IN --
                    when "1100100" | "1100101" | "1100110" | "1100111" =>
                        RF_WR           <= '1';
                        RF_WR_SEL       <= "11";
                    
                        -- OUT --
                    when "1101000" | "1101001" | "1101010" | "1101011" =>
                        IO_OE           <= '1';
                        
                                    -- BRANCHES / CALLS --
                        
                        -- BRN --
                    when "0010000" =>   
                        PC_LD           <= '1';  
                        PC_MUX_SEL  <= "00";
                        
                        -- CALL --
                    when "0010001" =>
                        PC_LD           <= '1';
                        PC_MUX_SEL      <= "00";
                        SP_DEC          <= '1';
                        SCR_WR          <= '1';
                        SCR_DATA_SEL    <= '1';
                        SCR_ADDR_SEL    <= "11";
                        
                        -- BREQ --
                    when "0010010" =>
                        if (Z = '1') then
                            PC_LD       <= '1';
                            PC_MUX_SEL  <= "00";                        
                        else
                        end if;
                        
                        -- BRNE --
                    when "0010011" =>
                        if (Z = '0') then
                            PC_LD       <= '1';
                            PC_MUX_SEL  <= "00";
                        else
                        end if;
                        
                        -- BRCS --
                    when "0010100" =>
                        if (C = '1') then
                            PC_LD       <= '1';
                            PC_MUX_SEL  <= "00";
                        else
                        end if;
                    
                        -- BRCC --
                    when "0010101" =>
                        if (C = '0') then
                            PC_LD       <= '1';
                            PC_MUX_SEL  <= "00";
                        else
                        end if;
                        
                                        -- ??????? --
                                            
                        -- CLC --
                    when "0110000" =>
                        C_FLAG_CLR      <= '1';
                        
                        -- SEC --
                    when "0110001" =>
                        C_FLAG_SET      <= '1';
                        
                        -- RET --
                    when "0110010" =>
                        PC_LD           <= '1';
                        PC_MUX_SEL      <= "01";
                        SP_INC          <= '1';
                        SCR_ADDR_SEL    <= "10";
                        
                        -- SEI --
                    when "0110100" =>
                    
                        -- CLI --
                    when "0110101" =>
                        
                        -- RETID --
                    when "0110110" =>
                        PC_LD           <= '1';
                        PC_MUX_SEL      <= "01";
                        SP_INC          <= '1';
                        SCR_ADDR_SEL    <= "10";
                        I_FLAG_CLR      <= '1';
                        C_FLAG_LD       <= '1';
                        Z_FLAG_LD       <= '1';
                        FLG_LD_SEL      <= '1';
                        
                        -- RETIE --
                    when "0110111" =>
                        PC_LD           <= '1';
                        PC_MUX_SEL      <= "01";
                        SP_INC          <= '1';
                        SCR_ADDR_SEL    <= "10";
                        I_FLAG_SET      <= '1';
                        C_FLAG_LD       <= '1';
                        Z_FLAG_LD       <= '1';
                        FLG_LD_SEL      <= '1';
							   	   
                    when others =>		
                      -- repeat the default block here to avoid incompletely specified outputs and hence avoid
                      -- the problem of inadvertently created latches within the synthesized system.						
                          PC_LD         <= '0';   PC_MUX_SEL     <= "00";   PC_RESET <= '0';	    PC_INC <= '0';		      				
                          SP_LD         <= '0';   SP_RESET       <= '0';    SP_INC    <= '0';     SP_DEC   <= '0';
                          RF_WR         <= '0';   RF_WR_SEL      <= "00";   
                          ALU_OPY_SEL   <= '0';   ALU_SEL        <= "0000";                   
                          SCR_WR        <= '0';   SCR_ADDR_SEL   <= "00";   SCR_DATA_SEL <= '0';  
                          C_FLAG_LD      <= '0';    C_FLAG_SET   <= '0';  C_FLAG_CLR <= '0';  FLG_LD_SEL <= '0';                
                          Z_FLAG_LD      <= '0';    FLG_SHAD_LD  <= '0';
                          I_FLAG_SET    <= '0';   I_FLAG_CLR     <= '0'; 
                          IO_OE <= '0';

                end case;

          when others => 
			   NS <= ST_fet;
			    
            -- repeat the default block here to avoid incompletely specified outputs and hence avoid
            -- the problem of inadvertently created latches within the synthesized system.
                    PC_LD         <= '0';   PC_MUX_SEL     <= "00";   PC_RESET <= '0';	    PC_INC <= '0';		      				
                    SP_LD         <= '0';   SP_RESET       <= '0';    SP_INC    <= '0';     SP_DEC   <= '0';
                    RF_WR         <= '0';   RF_WR_SEL      <= "00";   
                    ALU_OPY_SEL   <= '0';   ALU_SEL        <= "0000";                   
                    SCR_WR        <= '0';   SCR_ADDR_SEL   <= "00";   SCR_DATA_SEL <= '0';  
                    C_FLAG_LD      <= '0';    C_FLAG_SET   <= '0';  C_FLAG_CLR <= '0';  FLG_LD_SEL <= '0';                
                    Z_FLAG_LD      <= '0';    FLG_SHAD_LD  <= '0';
                    I_FLAG_SET    <= '0';   I_FLAG_CLR     <= '0'; 
                    IO_OE <= '0';
                         
	    end case;
   end process comb_p;
end Behavioral;