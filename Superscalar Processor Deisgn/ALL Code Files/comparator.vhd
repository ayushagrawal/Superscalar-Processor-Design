library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
library work;
use work.components.all;

entity comparator is

	generic(tag_size : integer := 5;
			  tag_num : integer := 16;
			  N       : integer := 62);		-- DATA LENGTH
	port (to_match : in main_array(0 to 4)(21 downto 0);					-- CONTAINS THE BROADCAST
			data_in : in main_array(0 to tag_num-1)(N-1 downto 0);		-- THE REGISTER'S DATA
			data_out : out main_array(0 to tag_num-1)(N-1 downto 0);		-- THE REGISTER'S DATA
			busy		: in main_array(0 to tag_num-1)(0 downto 0);
			index		: out main_array(0 to 4)(natural(log2(real(tag_num)))-1 downto 0);
			valid		: out main_array(0 to 4)(0 downto 0));
	
end entity;

architecture Comp of comparator is

begin

	process(to_match,data_in)
		variable Nvalid : main_array(0 to 4)(0 downto 0);
		variable Nindex : main_array(0 to 4)(natural(log2(real(tag_num)))-1 downto 0) := (others => (others => '0'));
	begin
		Nvalid := (others => (others => '0'));
		Nindex := (others => (others => '0'));
		for I in 0 to 4 loop
			if(to_match(I)(0) = '1') then			-- VALIDITY_BROADCAST == 1
				for J in 0 to tag_num-1 loop
					if ((to_match(I)(tag_size downto 1) = data_in(J)(21 downto 17) ) and (busy(J) = "1")) then
						Nvalid(I) := "1";
						Nindex(I) := std_logic_vector(to_unsigned(J,natural(log2(real(tag_num)))));
						data_out(J)(32 downto 17) <= to_match(I)(21 downto 6);
					end if;
					if ((to_match(I)(tag_size downto 1) = data_in(J)(38 downto 34) ) and (busy(J) = "1")) then
						Nvalid(I) := "1";
						Nindex(I) := std_logic_vector(to_unsigned(J,natural(log2(real(tag_num)))));
						data_out(J)(32 downto 17) <= to_match(I)(21 downto 6);
					end if;
				end loop;
			end if;
		end loop;
		index <= Nindex;
		valid <= Nvalid;
		data_out <= (others => (others => '0'));
	end process;

end Comp;