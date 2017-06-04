library ieee;
use ieee.std_logic_1164.all;

library work;
use work.components.all;

entity final is
	port(clk 		: in std_logic;
		  reset		: in std_logic);
		  
end entity;

architecture fin of final is

	signal  in_sel1,in_sel2 : std_logic_vector(2 downto 0);
	signal input1,input2    : std_logic_vector(15 downto 0);
	signal wren1,wren2		: std_logic;
	signal complete1,complete2 : std_logic_vector(37 downto 0);

begin
	
	PAR_FIN : para_final port map(clk => clk,
											reset => reset,
											
											in_sel1 => in_sel1,
											in_sel2 => in_sel2,
											input1  => input1,
											input2  => input2,
											wren1   => wren1,
											wren2   => wren2,
											
											complete1 => complete1,
											complete2 => complete2);
	
	COMP : complete port map(clk => clk,
									 reset => reset,
									 in_sel1 => in_sel1,
									 in_sel2 => in_sel2,
									 input1  => input1,
									 input2  => input2,
									 wren1   => wren1,
									 wren2   => wren2,
									 complete1 => complete1,
									 complete2 => complete2);
	
end architecture;