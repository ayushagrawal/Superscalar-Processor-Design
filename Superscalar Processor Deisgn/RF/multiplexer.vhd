library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

library work;
use work.components.all;

entity multiplexer is
	generic(X : integer;			-- NUMBER OF PORTS IN THE MUX
			  Y : integer);		-- DATA WIDTH OF THE MUX
	port(output : out std_logic_vector(Y-1 downto 0);
		  input  : in main_array(0 to X-1)(Y-1 downto 0);
		  sel		: in std_logic_vector(natural(log2(real(X)))-1 downto 0));
end entity;

architecture m of multiplexer is
begin

		output <= input(to_integer(unsigned(sel)));
		
end m;