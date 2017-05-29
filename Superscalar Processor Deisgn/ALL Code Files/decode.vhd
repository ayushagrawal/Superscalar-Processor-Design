library ieee;
use ieee.std_logic_1164.all;

library work;
use work.components.all;

-- WILL IMPLEMENT A DISTRIBUTED RESERVATION STATION SYSTEM

entity decode is

	port(clk	: in std_logic;
		  reset : in std_logic;
		  stall_in : in std_logic;
		  
		  -- To fetch
--		  decode_stall_out : out std_logic;
		  
		  inst1 : in std_logic_vector(15 downto 0);
		  inst2 : in std_logic_vector(15 downto 0);
		  PC1			: in std_logic_vector(6 downto 0);
		  PC2			: in std_logic_vector(6 downto 0);
		  
		  
		  ------- CALCULATED uOPS RESGITERS ------
		  REG1	: out std_logic_vector(35 downto 0);
		  REG2	: out std_logic_vector(35 downto 0));
		  --*** (VALIDITY:OPCODE:ROB-INDEX:WB_REG:REG1:REG2:PC) ***--

end entity;

architecture DEC of decode is

	signal inst1_val,inst2_val : std_logic;
	
	signal opcode_reduced1,opcode_reduced2 : std_logic_vector(3 downto 0);
	signal opcode1,opcode2 : std_logic_vector(3 downto 0);
	signal regA_1,regB_1,regA_2,regB_2,regWB_1,regWB_2: std_logic_vector(2 downto 0);
	
	signal not_stall : std_logic;
	
	signal reg1_in,reg2_in : std_logic_vector(35 downto 0);
	signal PC_1,PC_2 : std_logic_vector(15 downto 0);
	
	signal extra1,extra2 : std_logic_vector(2 downto 0);
	signal isWB_1,isWB_2,isA_1,isA_2,isB_1,isB_2 : std_logic;
	
--	signal decode_stall_in : std_logic;
	
begin

	inst1_val <= not_stall;
	inst2_val <= not_stall;
	
	-- TO BE PROCESSED IN PARALLEL
	opcode1 <= inst1(15 downto 12);
	opcode2 <= inst2(15 downto 12);
																		
	not_stall <= not stall_in;
	
	PC_1(6 downto 0)  <= PC1;
	PC_1(15 downto 7) <= "000000000";
	PC_2(6 downto 0)  <= PC2;
	PC_2(15 downto 7) <= "000000000";
	
	------------------------- BAISC ASSIGNMENTS -------------------------
	--******** (VALIDITY:OPCODE:ROB-INDEX:WB_REG:REG1:REG2:PC) ********--
	
	reg1_in(35)				 <= inst1_val;
	reg1_in(34 downto 31) <= opcode_reduced1;
	reg1_in(30)				 <= isWB_1;
	reg1_in(29)				 <= isA_1;
	reg1_in(28)				 <= isB_1;
	reg1_in(27 downto 25) <= regWB_1;
	reg1_in(24 downto 22) <= regA_1;
	reg1_in(21 downto 19) <= regB_1;
	reg1_in(18 downto 16) <= extra1;
	reg1_in(15 downto  0) <= PC_1;
	
	
	reg2_in(35)				 <= inst2_val;
	reg2_in(34 downto 31) <= opcode_reduced2;
	reg2_in(30)				 <= isWB_2;
	reg2_in(29)				 <= isA_2;
	reg2_in(28)				 <= isB_2;
	reg2_in(27 downto 25) <= regWB_2;
	reg2_in(24 downto 22) <= regA_2;
	reg2_in(21 downto 19) <= regB_2;
	reg2_in(18 downto 16) <= extra2;
	reg2_in(15 downto  0) <= PC_2;
	
	---------------------------------------------------------------------
	
	out_reg1 : registers generic map(N => 36) port map(clk => clk,
																	   reset => reset,
																	   input => reg1_in,
																	   output => REG1,
																	   enable => not_stall);
	
	out_reg2 : registers generic map(N => 36) port map(clk => clk,
																	   reset => reset,
																	   input => reg2_in,
																	   output => REG2,
																	   enable => not_stall);
	
	--------------------------- DECODING --------------------------------
	
	--						ALU GENERAL STRUCTURE
	--
	--
	--
	--
	
	process(opcode1,opcode2,inst1,inst2)
	begin
		-- For 1st instruction
		if(opcode1 = "0000") then		-- ADD
			regA_1			 <= inst1(11 downto 9);
			regB_1			 <= inst1(8 downto 6);
			regWB_1			 <= inst1(5 downto 3);
			opcode_reduced1(3 downto 2) <= "00";
			opcode_reduced1(1 downto 0) <= inst1(1 downto 0);
			isWB_1 <= '1';
			isA_1  <= '1';
			isB_1  <= '1';
			extra1 <= "000";
			--decode_stall_in <= '0';
			
		elsif(opcode1 = "0001") then	-- ADI
			regA_1			 <= inst1(11 downto 9);			-- RA is first operand
			regB_1			 <= inst1(5 downto 3);			-- Immediate
			regWB_1			 <= inst1(8 downto 6);			-- RB is WB
			extra1 			 <= inst1(2 downto 0);			-- Immediate
			isWB_1 			 <= '1';
			isA_1  <= '1';
			isB_1  <= '0';
			opcode_reduced1(3 downto 2) <= "00";
			opcode_reduced1(1 downto 0) <= "11";
			--decode_stall_in <= '0';
			
		elsif(opcode1 = "0010") then	-- NAND
			regA_1			 <= inst1(11 downto 9);
			regB_1			 <= inst1(8 downto 6);
			regWB_1			 <= inst1(5 downto 3);
			opcode_reduced1(3 downto 2) <= "01";
			opcode_reduced1(1 downto 0) <= inst1(1 downto 0);
			isWB_1 <= '1';
			isA_1  <= '1';
			isB_1  <= '1';
			extra1			<= "000";
			--decode_stall_in <= '0';
			
		elsif(opcode1 = "0011") then	-- LHI
			regA_1			 <= inst1(8 downto 6);		-- Immediate(2)
			regB_1			 <= inst1(5 downto 3);		-- Immediate(1)
			regWB_1			 <= inst1(11 downto 9);		-- RA is WB
			extra1 			 <= inst1(2 downto 0);		-- Immediate(0)
			isWB_1 			 <= '1';
			isA_1  <= '0';
			isB_1  <= '0';
			opcode_reduced1(3 downto 2) <= "10";
			opcode_reduced1(1 downto 0) <= "00";
			--decode_stall_in <= '0';
			
		elsif(opcode1 = "0100") then	-- LOAD RA,RB,IMM
			regA_1			 <= inst1(8 downto 6);		-- RB is first operand
			regB_1			 <= inst1(5 downto 3);		-- Immediate
			regWB_1			 <= inst1(11 downto 9);		-- RA is for write back
			extra1 			 <= inst1(2 downto 0);		-- Immediate
			isWB_1 			 <= '1';
			isA_1  <= '1';
			isB_1  <= '0';
			opcode_reduced1(3 downto 2) <= "10";
			opcode_reduced1(1 downto 0) <= "01";
			--decode_stall_in <= '0';
			
		elsif(opcode1 = "0101") then	-- STORE
			regA_1			 <= inst1(11 downto 9);		-- RA is for store
			regB_1			 <= inst1(8 downto 6);		-- RB is first operand
			regWB_1			 <= inst1(5 downto 3);		-- Immediate
			extra1 			 <= inst1(2 downto 0);		-- Immediate
			isWB_1 			 <= '0';							-- No write back
			isA_1  <= '1';
			isB_1  <= '0';
			opcode_reduced1(3 downto 2) <= "10";
			opcode_reduced1(1 downto 0) <= "10";
			--decode_stall_in <= '0';
			
--		elsif(opcode1 = "0110") then	-- LOAD MULTIPLE
--			regA_1			 	 <= inst1(11 downto 9);		-- RA is first operand
--			regB_1			 	 <= "000";														-- Immediate(1)
--			regWB_1				 <= counter_out;
--			extra1(0) 			 <= inst1(to_integer(unsigned(counter_out)));		-- Immediate(0)
--			extra1(2 downto 1) <= "00";
--			isWB_1 			 	 <= inst1(to_integer(unsigned(counter_out)));
--			isA_1  <= '1';
--			isB_1  <= '0';
--			opcode_reduced1(3 downto 2) <= "10";
--			opcode_reduced1(1 downto 0) <= "01";
--			decode_stall_in <= '1';
--			
--		elsif(opcode1 = "0111") then	-- STORE MULTIPLE
--			regA_1			 <= counter_out;		-- RA is for store
--			regB_1			 <= inst1(11 downto 9);		-- RB is first operand
--			regWB_1			 <= "000";						-- Immediate(1)
--			extra1 			 <= inst1(2 downto 0);		-- Immediate(0)
--			isWB_1 			 <= '0';							-- No write back
--			isA_1  <= '1';
--			isB_1  <= '0';
--			opcode_reduced1(3 downto 2) <= "10";
--			opcode_reduced1(1 downto 0) <= "10";
--			decode_stall_in <= '1';
			
		elsif(opcode1 = "1100") then	-- BEQ
			regA_1			 <= inst1(11 downto 9);		-- RA is first operand
			regB_1			 <= inst1(8 downto 6);		-- RB is second operand
			regWB_1			 <= inst1(5 downto 3);		-- Immediate
			extra1 			 <= inst1(2 downto 0);		-- Immediate
			isWB_1 			 <= '0';							-- No write back
			isA_1  <= '1';
			isB_1  <= '0';
			opcode_reduced1(3 downto 2) <= "11";
			opcode_reduced1(1 downto 0) <= "00";
			--decode_stall_in <= '0';
			
		elsif(opcode1 = "1000") then	-- JAL
			regA_1			 <= inst1(8 downto 6);		-- Immediate(2)
			regB_1			 <= inst1(5 downto 3);		-- Immediate(1)
			regWB_1			 <= inst1(11 downto 9);		-- RA is WB
			extra1 			 <= inst1(2 downto 0);		-- Immediate(0)
			isWB_1 			 <= '1';							-- Write back
			isA_1  <= '0';
			isB_1  <= '0';
			opcode_reduced1(3 downto 2) <= "11";
			opcode_reduced1(1 downto 0) <= "01";
			--decode_stall_in <= '0';
			
		else									-- JLR
			regA_1			 <= inst1(8 downto 6);		-- RB us first operand
			regB_1			 <= inst1(5 downto 3);		-- Nothing
			regWB_1			 <= inst1(11 downto 9);		-- RA is WB
			extra1 			 <= inst1(2 downto 0);		-- Nothing
			isWB_1 			 <= '1';							-- Write back
			isA_1  <= '1';
			isB_1  <= '0';
			opcode_reduced1(3 downto 2) <= "11";
			opcode_reduced1(1 downto 0) <= "10";
			--decode_stall_in <= '0';
			
		end if;
	
		-- ###################### For 2nd instruction #################### --
		---------------------------------------------------------------------
		-- ############################################################### --
		
		if(opcode2 = "0000") then		-- ADD
			regA_2			 <= inst2(11 downto 9);
			regB_2			 <= inst2(8 downto 6);
			regWB_2			 <= inst2(5 downto 3);
			opcode_reduced2(3 downto 2) <= "00";
			opcode_reduced2(1 downto 0) <= inst2(1 downto 0);
			isWB_2 <= '1';
			isA_2  <= '1';
			isB_2  <= '1';
			extra2 <= "000";
			--decode_stall_in <= '0';
			
		elsif(opcode2 = "0001") then	-- ADI
			regA_2			 <= inst2(11 downto 9);
			regB_2			 <= inst2(5 downto 3);
			regWB_2			 <= inst2(8 downto 6);
			extra2 			 <= inst2(2 downto 0);
			isWB_2 			 <= '1';
			isA_2  <= '1';
			isB_2  <= '0';
			opcode_reduced2(3 downto 2) <= "00";
			opcode_reduced2(1 downto 0) <= "11";
			--decode_stall_in <= '0';
			
		elsif(opcode2 = "0010") then	-- NAND
			regA_2			 <= inst2(11 downto 9);
			regB_2			 <= inst2(8 downto 6);
			regWB_2			 <= inst2(5 downto 3);
			opcode_reduced2(3 downto 2) <= "01";
			opcode_reduced2(1 downto 0) <= inst2(1 downto 0);
			isWB_2 <= '1';
			isA_2  <= '1';
			isB_2  <= '1';
			extra2			<= "000";
			--decode_stall_in <= '0';
			
		elsif(opcode2 = "0011") then	-- LHI
			regA_2			 <= inst2(8 downto 6);
			regB_2			 <= inst2(5 downto 3);
			regWB_2			 <= inst2(11 downto 9);
			extra2 			 <= inst2(2 downto 0);
			isWB_2 			 <= '1';
			isA_2  <= '0';
			isB_2  <= '0';
			opcode_reduced2(3 downto 2) <= "10";
			opcode_reduced2(1 downto 0) <= "00";
			--decode_stall_in <= '0';
			
		elsif(opcode2 = "0100") then	-- LOAD RA,RB,IMM
			regA_2			 <= inst2(8 downto 6);		-- RB is first operand
			regB_2			 <= inst2(5 downto 3);		-- Immediate
			regWB_2			 <= inst2(11 downto 9);		-- RA is for write back
			extra2 			 <= inst2(2 downto 0);		-- Immediate
			isWB_2 			 <= '1';
			isA_2  <= '1';
			isB_2  <= '0';
			opcode_reduced2(3 downto 2) <= "10";
			opcode_reduced2(1 downto 0) <= "01";
			--decode_stall_in <= '0';
			
		elsif(opcode2 = "0101") then	-- STORE
			regA_2			 <= inst2(8 downto 6);		-- RB is first operand
			regB_2			 <= inst2(5 downto 3);		-- Immediate
			regWB_2			 <= inst2(11 downto 9);		-- RA is for store
			extra2 			 <= inst2(2 downto 0);		-- Immediate
			isWB_2 			 <= '0';							-- No write back
			isA_2  <= '1';
			isB_2  <= '0';
			opcode_reduced2(3 downto 2) <= "10";
			opcode_reduced2(1 downto 0) <= "10";
			--decode_stall_in <= '0';
			
--		elsif(opcode2 = "0110") then	-- LOAD MULTIPLE
--			rden1v := '1';
--			rden2v := '0';
--			wr1v := '1';
--			toWrite1v := "000";		-----------------CHANGE!!!!!!!!!
--			decode_stall_in <= '1';
--			
--		elsif(opcode2 = "0111") then	-- STORE MULTIPLE
--			rden1v := '1';
--			rden2v := '0';
--			wr1v := '0';
--			toWrite1v := inst2(5 downto 3);
--			decode_stall_in <= '1';
			
		elsif(opcode2 = "1100") then	-- BEQ
			regA_2			 <= inst2(8 downto 6);		-- RB is second operand
			regB_2			 <= inst2(5 downto 3);		-- Immediate
			regWB_2			 <= inst2(11 downto 9);		-- RA is first operand
			extra2 			 <= inst2(2 downto 0);		-- Immediate
			isWB_2 			 <= '0';							-- No write back
			isA_2  <= '1';
			isB_2  <= '0';
			opcode_reduced2(3 downto 2) <= "11";
			opcode_reduced2(1 downto 0) <= "00";
			--decode_stall_in <= '0';
			
		elsif(opcode2 = "1000") then	-- JAL
			regA_2			 <= inst2(8 downto 6);		-- Immediate
			regB_2			 <= inst2(5 downto 3);		-- Immediate
			regWB_2			 <= inst2(11 downto 9);		-- RA is WB
			extra2 			 <= inst2(2 downto 0);		-- Immediate
			isWB_2 			 <= '1';							-- Write back
			isA_2  <= '0';
			isB_2  <= '0';
			opcode_reduced2(3 downto 2) <= "11";
			opcode_reduced2(1 downto 0) <= "01";
			--decode_stall_in <= '0';
			
		else									-- JLR
			regA_2			 <= inst2(8 downto 6);		-- RB us first operand
			regB_2			 <= inst2(5 downto 3);		-- Nothing
			regWB_2			 <= inst2(11 downto 9);		-- RA is WB
			extra2 			 <= inst2(2 downto 0);		-- Nothing
			isWB_2 			 <= '1';							-- Write back
			isA_2  <= '1';
			isB_2  <= '0';
			opcode_reduced2(3 downto 2) <= "11";
			opcode_reduced2(1 downto 0) <= "10";
			--decode_stall_in <= '0';
			
		end if;
	end process;
	
	---------------------------------------------------------------------
	
	-- INSTRUCTION MANAGEMENT FOR LM/SM
	-- There can be three situations
	--   	1. LM with some other instruction
	--		2. SM with some other instruction
	--		3. LM & SM together
	
	-- THIS IS MANAGED AS IF THERE EXIST A DIFFERENT DECODING AND FECTHING UNIT
	-- MUXES ARE USED FOR CONTROLLING THE DATA FLOW
	
	-- In either of the case we have to stall the fetch unit for 4,4,8 cycles respectively
	
--	count4 : counter port map(clock => clk,
--									  cnt_en => ,
--									  sclr => ,
--									  cout => ,
--									  q => counter_out4);
--									  
--									  
--									  
--									  
--	-- DECODE STALL REGISTER
--	
--	dec_stall : registers generic map(N => 1)
--								 port    map(input => decode_stall_in,
--												 reset => reset,
--												 clk => clk,
--												 enable => '1',
--												 output => decode_stall_out);
	
end DEC;