library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.components.all;

-- Instructions included:
-- 	1. BEQ
--		2. JAL
--		3. JLR

-- All of these changes the value of PC : Therefore we need to check if the branch taken earlier was right or not
-- If not : Need to make a mechanism of flushing
-- If yes : continue as such

-- For checking the validity of the branch : Need an input from the ROB or it must come with the instruction


entity bch_unit is

		port(clk : in std_logic;
			  reset : in std_logic;
			  input : in std_logic_vector(55 downto 0);
			  output : out std_logic_vector(22 downto 0));
			  
end entity;

architecture bch_arch of bch_unit is
	
	
	
begin
	
	process
		begin
		
		if() then
		
		elsif then
		
		end if;
		
	end process;
	output <= (others => '0');
	
end architecture;