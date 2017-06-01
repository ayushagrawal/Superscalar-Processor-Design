library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.components.all;

entity bch_unit is

		port(clk : in std_logic;
			  reset : in std_logic;
			  input : in std_logic_vector(58 downto 0);
			  output : out std_logic_vector(21 downto 0));
			  
end entity;

architecture bch_arch of bch_unit is
	
	
	
begin
	

	
end architecture;