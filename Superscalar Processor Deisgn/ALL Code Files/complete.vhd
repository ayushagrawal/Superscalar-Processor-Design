library ieee;
use ieee.std_logic_1164.all;

library work;
use work.components.all;

entity complete is
	port(clk 		: in std_logic;
		  reset		: in std_logic;
		  
		  -- TO COMPLETE FROM ROB
		  complete1				: in std_logic_vector(37 downto 0);
		  complete2				: in std_logic_vector(37 downto 0);
		  -- If write back		 : 1  bit
		  -- Inst_type 			 : 2  bits
		  -- Register affected : 3  bits
		  -- Memory affected   : 16 bits
		  -- Data				    : 16 bits
		  -- validity		    : 1  bit
		  
		  
		  -- TO DECODE
		  in_sel1 : out std_logic_vector(2 downto 0);
		  in_sel2 : out std_logic_vector(2 downto 0);
		  input1  : out std_logic_vector(15 downto 0);
		  input2  : out std_logic_vector(15 downto 0);
		  wren1 : out std_logic;
		  wren2 : out std_logic);
		  
end entity;

architecture com of complete is

	signal output1,output2 : std_logic_vector(37 downto 0);

begin
	
	in_sel1 <= output1(34 downto 32);
	in_sel2 <= output2(34 downto 32);
	input1  <= output1(16 downto  1);
	input2  <= output2(16 downto  1);
	wren1	  <= output1(0) and output1(37);
	wren2	  <= output2(0) and output2(37);
	
	COMP_REG1 : registers generic map(N => 38)
								 port map(input => complete1,
											 enable => '1',
											 clk => clk,
											 reset => reset,
											 output => output1);
											 
	COMP_REG2 : registers generic map(N => 38)
								 port map(input => complete2,
											 enable => '1',
											 clk => clk,
											 reset => reset,
											 output => output2);
	
end architecture;