-- DEFINES THE STRUCTURE OF INDIVIDUAL RESERVATION STATIONS

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
library work;
use work.components.all;

-- NOTE : Tag length of the register in RRF is equivalent to tag length of ROB

entity update_unit is
		generic(N  : integer := 32;			-- Specifies the number of entiries in the ROB
				  X  : integer := 16);			-- Specifies the number of entries in the reservation station
		port(broadcast	: in main_array(0 to 4)(21 downto 0);	-- Max of 5 units can return
			  -- Data 		= 16 bits
			  -- Tag  		= 5  bits (RRF size)
			  -- Validity = 1 bit
			  -- (In the above order) --
			  
			  -- FROM the RS
			  tag : in main_array(0 to X-1)(natural(log2(real(N)))-1 downto 0);
			  busy: in main_array(0 to X-1)(0 downto 0);
			  
			  -- To RS
			  validity_out : out main_array(0 to X-1)(0 downto 0);
			  validity_en	: out main_array(0 to X-1)(0 downto 0);
			  data			: out main_array(0 to X-1)(15 downto 0);
			  data_en		: out main_array(0 to X-1)(0 downto 0);
			  
			  -- To Dispatch unit
			  index_out : out main_array(0 to 4)(natural(log2(real(X)))-1 downto 0);
			  index_val : out main_array(0 to 4)(0 downto 0)
			);
	end entity;

architecture UU of update_unit is
	signal index : main_array(0 to 4)(natural(log2(real(X)))-1 downto 0);
	signal valid : main_array(0 to 4)(0 downto 0);
begin
	
	-- This gives me the index of the entries in the RS which match with the broadcast
	comparator1 : comparator generic map(tag_size => natural(log2(real(N))), tag_num => X)
								 port map(to_match(0) => broadcast(0)(5 downto 0),
											 to_match(1) => broadcast(1)(5 downto 0),
											 to_match(2) => broadcast(2)(5 downto 0),
											 to_match(3) => broadcast(3)(5 downto 0),
											 to_match(4) => broadcast(4)(5 downto 0),
											 tag_data => tag,
											 busy		 => busy,
											 index	 => index,		-- Corresponds to that in the RS
											 valid	 => valid);		-- Indicates if an index is valid or garbage
	
	index_out <= index;
	index_val <= valid;
	
	process(index,valid)
	
	begin
		for I in 0 to 4 loop
			if (valid(I)(0) = '1') then
				validity_en(to_integer(unsigned(index(I))))(0) <= '1';
				data_en(to_integer(unsigned(index(I))))(0) <= '1';
				data(to_integer(unsigned(index(I)))) <= broadcast(I)(21 downto 6);
				validity_out(to_integer(unsigned(index(I))))(0) <= '1';
			end if;
		end loop;
	end process;
	
end;