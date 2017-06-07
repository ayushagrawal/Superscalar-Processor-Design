library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.components.all;

entity adds is
	generic(N : integer := 32);			-- Arbit number
	port(data1 : in std_logic_vector(N-1 downto 0);
		  data2 : in std_logic_vector(N-1 downto 0);
		  output : out std_logic_vector(N-1 downto 0));
		 
end entity;

architecture files of adds is

	signal result : std_logic_vector(N downto 0);
	
begin
	
	result <= ('0' & data1) + ('0' & data2);
	output <= result(N-1 downto 0);
	
end files;