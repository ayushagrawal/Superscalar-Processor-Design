library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.components.all;

entity register_file is

	port(reset : in std_logic;
		  clk   : in std_logic;
		  stall_out : out std_logic;
		  
		  -- From Decode
		  REG1 : in std_logic_vector(35 downto 0);
		  REG2 : in std_logic_vector(35 downto 0);
		  
		  -- To Reservation Station
		  register1 : out std_logic_vector(71 downto 0);
		  register2 : out std_logic_vector(71 downto 0);
		  
		  -- From Write Back for ARF
		  in_sel1				: in std_logic_vector(2 downto 0);
		  in_sel2				: in std_logic_vector(2 downto 0);
		  
		  input1					: in std_logic_vector(15 downto 0);
		  input2					: in std_logic_vector(15 downto 0);
		  
		  wren1					: in std_logic;
		  wren2					: in std_logic;
		  
		  -- From Execute Complete for ROB
		  broadcast				: in main_array(0 to 4)(21 downto 0);	-- Max of 5 units can return
																						-- Data 		= 16 bits
																						-- Tag  		= 5  bits (RRF size)
																						-- Validity = 1 bit
																						-- (In the above order) --
		  -- TO COMPLETE FROM ROB
		  complete1				: out std_logic_vector(35 downto 0);
		  complete2				: out std_logic_vector(35 downto 0));
	
end entity;

architecture rFile of register_file is
	
	signal regIn1,regIn2 : std_logic_vector(71 downto 0);
	
	signal r1_1,r2_1,r3_1,r1_2,r2_2,r3_2	: std_logic_vector(2 downto 0);
	
	signal RA_1,RB_1,RA_2,RB_2 				: std_logic_vector(16 downto 0);
	signal RA_arf1,RB_arf1,RA_arf2,RB_arf2 : std_logic_vector(16 downto 0);
	
	signal immediate1,immediate2 : std_logic_vector(8 downto 0);
	
	signal stall_rob_out : std_logic;
	
	signal validity_in,validity_out,val_en_ch : main_array(0 to 7)(0 downto 0);
	
	-- To ROB
	signal reg1_val,reg2_val  : std_logic_vector(22 downto 0);
	-- From ROB
	signal reg1_index,reg2_index : std_logic_vector(4 downto 0);
	
begin
	
	--------- STALL LOGIC ---------
	
	stall_out <= stall_rob_out;
	
	-------------------------------
	
	
	--................... REGISTERS FOR DATA CARRY THROUGH ..................--
	---------------------------------------------------------------------------
	data_reg1 : registers generic map(N => 72)
								 port    map(input => regIn1,
												 enable => '1',
												 output => register1,
												 clk => clk,
												 reset => reset);
	
	data_reg2 : registers generic map(N => 72)
								 port    map(input => regIn2,
												 enable => '1',
												 output => register2,
												 clk => clk,
												 reset => reset);
	----------------------------------------------------------------------------			
	
	--------------------- TO ROB ---------------------
	
	reg1_val(22)			  <= REG1(30);					-- IF wirte back
	reg1_val(21 downto 20) <= REG1(34 downto 33);
	reg1_val(19 downto 17) <= REG1(27 downto 25);
	reg1_val(16 downto 1)  <= "0000000000000000";
	reg1_val(0) 			  <= REG1(35);
	
	--------------------------------------------------
	
	--__________________________ DATA MAPPING ________________________________--
	
	regIn1(71) 				<= REG1(35);						-- VALIDITY
	regIn1(70 downto 67) <= REG1(34 downto 31);			-- REDUCED OP-CODE
	regIn1(66 downto 62) <= reg1_index;						-- ROB INDEX
	regIn1(61 downto 59) <= REG1(27 downto 25);			-- WB REG
	regIn1(58 downto 50) <= immediate1;						-- IMMEDIATE
	regIn1(49 downto 34) <= RA_1(15 downto 0);			-- REG_A VALUE
	regIn1(33)				<= RA_1(16);						-- VALIDITY
	regIn1(32 downto 17) <= RB_1(15 downto 0);			-- REG_B VALUE
	regIn1(16) 				<= RB_1(16);						-- VALIDITY
	regIn1(15 downto 0)  <= REG1(15 downto 0);			-- PC
	----------------------------------------------------------------------------
	
	-- LOGIC FOR IMMEDIATE
	
	immediate1(2 downto 0) <= REG1(18 downto 16);
	
	process(REG1)
	begin
		if(REG1(34 downto 31) = "0011" or REG1(34 downto 31) = "1001") then			-- ADI,LW in REGB
			immediate1(5 downto 3) <= REG1(21 downto 19);
			immediate1(8 downto 6) <= "000";
			
		elsif(REG1(34 downto 31) = "1010" or REG1(34 downto 31) = "1100") then		-- BEQ,SW in WB_REG
			immediate1(5 downto 3) <= REG1(27 downto 25);
			immediate1(8 downto 6) <= "000";
			
		else																								-- JAL,LHI
			immediate1(5 downto 3) <= REG1(21 downto 19);
			immediate1(8 downto 6) <= REG1(24 downto 22);
		end if;
	end process;
	
	----------------------
	
	ar_file : ARF port map(reset => reset,
								  clk => clk,
								  in_sel1 => in_sel1,	-- From write back
								  in_sel2 => in_sel2,	-- From write back
								  in_sel3 => r3_1,		-- From decode
								  in_sel4 => r3_2,		-- From deocde
								  
								  input1 => input1,									-- From write back
								  input2 => input2,									-- From write back
								  input3(4 downto  0) => reg1_index,			-- From RRF->ROB
								  input3(15 downto 5) => "00000000000",
								  input4(4 downto 0) => reg2_index,				-- From RRF->ROB
								  input4(15 downto 5) => "00000000000",
								  
								  wren1 => wren1,						-- From write back
								  wren2 => wren2,						-- From write back
								  wren3 => REG1(30),					-- From decode (Indicates whether there is a need for renaming)
								  wren4 => REG2(30),					-- From decode (Indicates whether there is a need for renaming)
								  
								  validity_in => validity_in,
								  val_en_ch => val_en_ch,
								  
								  output1 => RA_1,
								  output2 => RB_1,
								  output3 => RA_2,
								  output4 => RB_2,
								  osel1 => REG1(24 downto 22),
								  osel2 => REG1(21 downto 19),
								  osel3 => REG2(24 downto 22),
								  osel4 => REG2(21 downto 19));
								  
	-- For maintaing the validity bit
	process(REG1)
	begin
		if(REG1(30) = '1') then			-- IMPLIES THAT THERE IS A VALID WRITE-BACK -> The register becomes invalid
			validity_in(to_integer(unsigned(REG1(27 downto 25))))(0) <= '0';
			val_en_ch(to_integer(unsigned(REG1(27 downto 25))))(0) <= '1';
		else
			validity_in(to_integer(unsigned(REG1(27 downto 25))))(0) <= '0';		-- Don't care
			val_en_ch(to_integer(unsigned(REG1(27 downto 25))))(0) <= '0';			-- Not using the result
		end if;
		validity_in <= (others => (others => '0'));
		val_en_ch <= (others => (others => '0'));
	end process;
	
	------------------------------ REORDER BUFFER ---------------------------------
	
	------------ INTERFACING ---------------
	
	reorder : ROB generic map(N => 32) 
					  port    map(reset => reset,
									  clk   => clk,
									  stall_out => stall_rob_out,
									  broadcast => broadcast,
									  
									  instruction1 => reg1_val,
									  instruction2 => reg2_val,
									  
									  inst1_tag => reg1_index,
									  inst2_tag => reg2_index,
									  
									  complete1 => complete1,
									  complete2 => complete2);
	
	--________ END INTERFACING ___________--
	
	--_________________________ END REORDER BUFFER ______________________________--
	
end architecture;