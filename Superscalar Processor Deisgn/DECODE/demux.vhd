library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

library work;
use work.components.all;

entity demux is

	generic(X : integer;
			  Y : integer);
		port(input  : in std_logic_vector(X-1 downto 0);
			  output : out main_array(0 to Y-1)(natural(log2(real(Y)))+X-1 downto 0);
			  sel		: in std_logic_vector(natural(log2(real(Y))) downto 0));

end entity;

architecture DM of demux is

begin
	process(sel)
		begin
			
			if(sel)
			
		end process;

end DM;