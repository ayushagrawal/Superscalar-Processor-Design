library ieee;
use ieee.std_logic_1164.all;

library work;
use work.components.all;

-- WILL IMPLEMENT A DISTRIBUTED RESERVATION STATION SYSTEM

entity decode is

	port(clk	: in std_logic;
		  reset : in std_logic;
		  stall_in : std_logic;
		  inst1 : in std_logic_vector(15 downto 0);
		  inst2 : in std_logic_vector(15 downto 0);
		  PC1			: in std_logic_vector(7 downto 0);
		  PC2			: in std_logic_vector(7 downto 0);
		  
		  ------------ FROM WRITE BACK -----------
		  in_sel1: in std_logic_vector(2 downto 0);
		  in_sel2 : in std_logic_vector(2 downto 0);
		  input1 : in std_logic_vector(15 downto 0);
		  input2 : in std_logic_vector(15 downto 0);
		  wren1 : in std_logic;
		  wren2 : in std_logic;
		  ----------------------------------------
		  ------- CALCULATED uOPS RESGITERS ------
		  REG1	: out std_logic_vector(61 downto 0);
		  REG2	: out std_logic_vector(61 downto 0));

end entity;

architecture DEC of decode is
	signal opcode1,opcode2 : std_logic_vector(3 downto 0);
	signal rden1,rden2,rden3,rden4 : std_logic;
	signal wr1,wr2 : std_logic;
	signal toWrite1, toWrite2 : std_logic_vector(15 downto 0);
	signal index1,index2 : std_logic_vector(4 downto 0);
	signal stall, wr_en, not_stall : std_logic;
	signal input,output : std_logic_vector(21 downto 0);
	signal reg1_in,reg2_in : std_logic_vector(60 downto 0);
	signal out1,out2,out3,out4 : std_logic_vector(15 downto 0);
	signal out_val1,out_val2,out_val3,out_val4 : std_logic;
	signal inst1_val,inst2_val : std_logic;
begin

	inst1_val <= not stall_in;
	inst2_val <= not stall_in;
	
	opcode1 <= inst1(15 downto 12);
	opcode2 <= inst2(15 downto 12);

	ROB: reorder_buffer generic map(N => 32) port map(clk => clk,
																		reset => reset,
																		stall => stall,
																		input => input,
																		output => output,
																		wr_en => wr_en,
																		index1 => index1,
																		index2 => index2);
																		
	not_stall <= not stall;
	
	rf : register_file port map(clk => clk,
										 reset => reset,
										 in_sel1 => in_sel1,
										 in_sel2 => in_sel2,
										 input1 => input1,
										 input2 => input2,
										 wren1 => wren1,
										 wren2 => wren2,
										 out1 => out1,
										 out2 => out2,
										 out3 => out3,
										 out4 => out4,
										 out_val1 => out_val1,
										 out_val2 => out_val2,
										 out_val3 => out_val3,
										 out_val4 => out_val4,
										 osel1 => inst1(11 downto 9),
										 osel2 => inst1(8 downto 6),
										 osel3 => inst2(11 downto 9),
										 osel4 => inst2(8 downto 6),
										 rden1 => rden1,				-- Decided by decoding
										 rden2 => rden2,				-- Decided by decoding
										 rden3 => rden3,				-- Decided by decoding
										 rden4 => rden4,				-- Decided by decoding
										 
										 toWrite1 => toWrite1,
										 toWrite2 => toWrite2,
										 wr1		 => wr1,			-- Decided by decoding
										 wr2		 => wr2			-- Decided by decoding
										 );	
	
	------------------------- BAISC ASSIGNMENTS -------------------------
	reg1_in(61)				 <= inst1_val;
	reg1_in(60 downto 57) <= inst1(15 downto 12);
	reg1_in(56 downto 55) <= inst1(1 downto 0);
	reg1_in(54 downto 50) <= index1;				-- FROM REORDER BUFFER
	reg1_in(49 downto 34) <= out1;
	reg1_in(33) <= out_val1;
	reg1_in(32 downto 17) <= out2;
	reg1_in(16) <= out_val2;
	reg1_in(15 downto 0) <= PC1;
	
	
	reg2_in(61)				 <= inst2_val;
	reg2_in(60 downto 57) <= inst2(15 downto 12);
	reg2_in(56 downto 55) <= inst2(1 downto 0);
	reg2_in(54 downto 50) <= index2;				-- FROM REORDER BUFFER
	reg2_in(49 downto 34) <= out3;
	reg2_in(33) <= out_val3;
	reg2_in(32 downto 17) <= out4;
	reg2_in(16) <= out_val4;
	reg2_in(15 downto 0) <= PC2;
	
	---------------------------------------------------------------------
	
	out_reg1 : registers generic map(N => 62) port map(clk => clk,
																	   reset => reset,
																	   input => reg1_in,
																	   output => REG1,
																	   enable => not_stall);
	
	out_reg2 : registers generic map(N => 62) port map(clk => clk,
																	   reset => reset,
																	   input => reg2_in,
																	   output => REG2,
																	   enable => not_stall);
	
	--------------------------- DECODING --------------------------------
	
	process(opcode1,opcode2)
		variable rden1v,rden2v,rden3v,rden4v : std_logic;
		variable wr1v,wr2v : std_logic;
		variable toWrite1v,toWrite2v : std_logic_vector(2 downto 0);
	begin
		-- For 1st instruction
		if(opcode1 = "0000") then		-- ADD
			rden1v := '1';
			rden2v := '1';
			wr1v := '1';
			toWrite1v := inst1(5 downto 3);
		elsif(opcode1 = "0001") then	-- ADI
			rden1v := '1';
			rden2v := '0';
			wr1v := '1';
			toWrite1v := inst1(8 downto 6);
		elsif(opcode1 = "0010") then	-- NAND
			rden1v := '1';
			rden2v := '1';
			wr1v := '1';
			toWrite1v := inst1(5 downto 3);
		elsif(opcode1 = "0011") then	-- LHI
			rden1v := '0';
			rden2v := '0';
			wr1v := '1';
			toWrite1v := inst1(11 downto 9);
		elsif(opcode1 = "0100") then	-- LOAD
			rden1v := '0';
			rden2v := '1';
			wr1v := '1';
			toWrite1v := inst1(11 downto 9);
		elsif(opcode1 = "0101") then	-- STORE
			rden1v := '1';
			rden2v := '1';
			wr1v := '0';
			toWrite1v := inst1(5 downto 3);-------------------------------
		elsif(opcode1 = "0110") then	-- LOAD MULTIPLE
			rden1v := '1';
			rden2v := '0';
			wr1v := '1';
			toWrite1v := "000";		-----------------CHANGE!!!!!!!!!
		elsif(opcode1 = "0111") then	-- STORE MULTIPLE
			rden1v := '1';
			rden2v := '0';
			wr1v := '0';
			toWrite1v := inst1(5 downto 3);
		elsif(opcode1 = "1100") then	-- BEQ
			rden1v := '1';
			rden2v := '1';
			wr1v := '0';
			toWrite1v := inst1(5 downto 3);
		elsif(opcode1 = "1000") then	-- JAL
			rden1v := '0';
			rden2v := '0';
			wr1v := '1';
			toWrite1v := inst1(11 downto 9);
		else									-- JLR
			rden1v := '0';
			rden2v := '1';
			wr1v := '1';
			toWrite1v := inst1(11 downto 9);
		end if;
	
		-- For 2nd instruction -------------
		if(opcode2 = "0000") then		-- ADD
			rden3v := '1';
			rden4v := '1';
			wr2v := '1';
			toWrite2v := inst2(5 downto 3);
		elsif(opcode2 = "0001") then	-- ADI
			rden3v := '1';
			rden4v := '0';
			wr2v := '1';
			toWrite2v := inst2(8 downto 6);
		elsif(opcode2 = "0010") then	-- NAND
			rden3v := '1';
			rden4v := '1';
			wr2v := '1';
			toWrite2v := inst2(5 downto 3);
		elsif(opcode2= "0011") then	-- LHI
			rden3v := '0';
			rden4v := '0';
			wr2v := '1';
			toWrite2v := inst2(11 downto 9);
		elsif(opcode2 = "0100") then	-- LOAD
			rden3v := '0';
			rden4v := '1';
			wr2v := '1';
			toWrite2v := inst1(11 downto 9);
		elsif(opcode2 = "0101") then	-- STORE
			rden3v := '1';
			rden4v := '1';
			wr2v := '0';
			toWrite2v := inst2(5 downto 3);---------------------------
		elsif(opcode2 = "0110") then	-- LOAD MULTIPLE
			rden3v := '1';
			rden4v := '0';
			wr2v := '1';
			toWrite2v := "000"; --------------CHANGE!!!!!!!!!!!!!!!!!!!!!!!
		elsif(opcode1 = "0111") then	-- STORE MULTIPLE
			rden4v := '1';
			rden4v := '0';
			wr2v := '0';
			toWrite2v := inst2(5 downto 3);
		elsif(opcode2 = "1100") then	-- BEQ
			rden3v := '1';
			rden4v := '1';
			wr1v := '0';
			toWrite2v := inst2(5 downto 3);
		elsif(opcode2 = "1000") then	-- JAL
			rden3v := '0';
			rden4v := '0';
			wr2v := '1';
			toWrite2v := inst2(11 downto 9);
		else									-- JLR
			rden3v := '0';
			rden4v := '1';
			wr2v := '1';
			toWrite2v := inst2(11 downto 9);
		end if;
	
	rden1 <= rden1v;
	rden2 <= rden2v;
	rden3 <= rden3v;
	rden4 <= rden4v;
	wr1 <= wr1v;
	wr2 <= wr2v;
	
	toWrite1 <= toWrite1v;
	toWrite2 <= toWrite2v;
	end process;
	
	---------------------------------------------------------------------
	
end DEC;