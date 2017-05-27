library ieee;
use ieee.std_logic_1164.all;

library work;
use work.components.all;

entity fetch_decode is
	port(clk 		: in std_logic;
		  reset		: in std_logic;
		  stall		: in std_logic;
		  
		  -- FROM WRITE BACK
		  in_sel1 : in std_logic_vector(2 downto 0);
		  in_sel2 : in std_logic_vector(2 downto 0);
		  input1 : in std_logic_vector(15 downto 0);
		  input2 : in std_logic_vector(15 downto 0);
		  wren1 : in std_logic;
		  wren2 : in std_logic;
		   ------- CALCULATED uOPS RESGITERS ------
		  REG1	: out std_logic_vector(61 downto 0);
		  REG2	: out std_logic_vector(61 downto 0));
end entity;

architecture fd of fetch_decode is

	signal inst1,inst2 : std_logic_vector(22 downto 0);  	-- PC(22 downto 16) + INSTRUCTION(15 downto 0)

begin
	
	fetch_unit : fetch  port map(clk => clk,
										  reset => reset,
							 			  stall => stall,
										  inst1 => inst1,				-- PC(22 downto 16) + INSTRUCTION(15 downto 0)
										  inst2 => inst2);			-- PC(22 downto 16) + INSTRUCTION(15 downto 0)
										 
	decode_unt : decode port map(clk => clk,
										  reset => reset,
										  stall_in => stall,
										  inst1 => inst1(15 downto 0),
										  inst2 => inst2(15 downto 0),
										  PC1 => inst1(22 downto 16),
										  PC2 => inst2(22 downto 16),
										  
										  -- FROM WRITE BACK
										  in_sel1 => in_sel1,
										  in_sel2 => in_sel2,
										  input1  => input1,
										  input1  => input2,
										  wren1   => wren1,
										  wren2   => wren2,
										  
										  -- TO REGISTER FILE
										  REG1 => REG1,
										  REG2 => REG2);
	
end architecture;