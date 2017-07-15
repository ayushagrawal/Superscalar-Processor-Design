library ieee;
use ieee.std_logic_1164.all;

library work;
use work.components.all;

entity fetch_decode_rf is
	port(clk 		: in std_logic;
		  reset		: in std_logic;
		  
		  -- FROM WRITE BACK to Register File
		  in_sel1 : in std_logic_vector(2 downto 0);
		  in_sel2 : in std_logic_vector(2 downto 0);
		  input1 : in std_logic_vector(15 downto 0);
		  input2 : in std_logic_vector(15 downto 0);
		  wren1 : in std_logic;
		  wren2 : in std_logic;
		  
		   -- To Reservation Station
		  register1 : out std_logic_vector(71 downto 0);
		  register2 : out std_logic_vector(71 downto 0);		  
		  
		  -- From Execute Complete for ROB
		  broadcast				: in main_array(0 to 4)(22 downto 0);	-- Max of 5 units can return
																						-- Data 		= 16 bits
																						-- Tag  		= 5  bits (RRF size)
																						-- Validity = 1 bit
																						-- (In the above order) --
		  -- TO COMPLETE FROM ROB
		  complete1				: out std_logic_vector(37 downto 0);
		  complete2				: out std_logic_vector(37 downto 0);
		  -- If write back		 : 1  bit
		  -- Inst_type 			 : 2  bits
		  -- Register affected : 3  bits
		  -- Memory affected   : 16 bits
		  -- Data				  : 16 bits
		  -- validity		     : 1  bit
		  
		  bc_1					: out std_logic;
		  bc_2					: out std_logic);
end entity;

architecture fd of fetch_decode_rf is

	signal REG1,REG2 : std_logic_vector(35 downto 0);
	
	signal stall : std_logic;
	
	signal bc_11,bc_22 : std_logic;

begin
	
	fetch_dec_unit : fetch_decode port map (clk => clk,
														 reset => reset,
														 stall => stall,
														
														 REG1 => REG1,
														 REG2 => REG2,
														 
														 bc_1 => bc_11,
														 bc_2 => bc_22);
	
	reg_file			: register_file port map(clk => clk,
														 reset => reset,
														 stall_out => stall,
														 
														 REG1 => REG1,
														 REG2 => REG2,
														 
														 register1 => register1,
														 register2 => register2,
														 
														 in_sel1 => in_sel1,
														 in_sel2 => in_sel2,
														 
														 input1 => input1,
														 input2 => input2,
														 
														 wren1 => wren1,
														 wren2 => wren2,
														 
														 broadcast => broadcast,
														 
														 -- To Complete
														 complete1 => complete1,
														 complete2 => complete2,
														 
														 bc_1in => bc_11,
														 bc_2in => bc_22,
														 bc_1out => bc_1,
														 bc_2out => bc_2);
	
end architecture;