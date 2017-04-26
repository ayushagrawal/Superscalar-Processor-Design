library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

library work;
use work.components.all;

entity demux is
	generic(X : integer;			-- NUMBER OF PORTS IN THE DEMUX
			  Y : integer);		-- DATA WIDTH OF THE DEMUX
	port(input : in std_logic_vector(Y-1 downto 0);
		  output  : out main_array(0 to X-1)(Y-1 downto 0);
		  sel		: in std_logic_vector(natural(log2(real(X)))-1 downto 0));
end entity;

architecture dm of demux is
begin
		process(sel)
			variable num : integer;
		begin
			num := to_integer(unsigned(sel));
			output(num) <= input;
		end process;
end dm;