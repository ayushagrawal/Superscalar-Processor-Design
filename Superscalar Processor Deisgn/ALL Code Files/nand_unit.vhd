-- TO BE COMPMETED IN A SINGLE CLOCK CYCLE
-- TO TO PROVIDE REGISTER FOR RESULTS

-- The flags does not take part in calculation but takes part in decision making

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.components.all;

entity nand_unit is
		
		generic(N : integer := 16);
		port(in1 : in std_logic_vector(N-1 downto 0);
			  in2 : in std_logic_vector(N-1 downto 0);
			  output : out std_logic_vector(N-1 downto 0);
			  carry : out std_logic;
			  zero : out std_logic);
			  
end entity;

architecture nand_arch of nand_unit is
	signal temp : std_logic_vector(N-1 downto 0);
begin

	temp   <= in1 nand in2;    
   carry 	<= '0';
	output <= temp;
	
	process(temp)
		variable z_temp : std_logic;
	begin
		z_temp := '0';
		for I in 0 to N-1 loop
			z_temp := z_temp or temp(I);
		end loop;
		zero <= z_temp;
	end process;
		
end architecture;