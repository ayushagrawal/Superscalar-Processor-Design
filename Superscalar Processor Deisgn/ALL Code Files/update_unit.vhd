-- DEFINES THE STRUCTURE OF INDIVIDUAL RESERVATION STATIONS

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
library work;
use work.components.all;

-- NOTE : Tag length of the register in RRF is equivalent to tag length of ROB

entity update_unit is
		generic(N : integer := 62;				-- DATA LENGTH 
				  X : integer := 16);			-- Specifies the number of entries in the reservation station
		port(broadcast	: in main_array(0 to 4)(22 downto 0);	-- Max of 5 units can return
			  -- Data 		= 16 bits
			  -- Tag  		= 5  bits (RRF size)
			  -- Validity  = 1 bit
			  -- (In the above order) --
			  
			  -- FROM the RS
			  busy : in main_array(0 to X-1)(0 downto 0);									-- INDICATES OCCUPANCY OF A RS ENTRY
			  data_in : in main_array(0 to X-1)(N-1 downto 0);
			  
			  -- To RS
			  validity_out : out main_array(0 to X-1)(0 downto 0);
			  validity_en	: out main_array(0 to X-1)(0 downto 0);
			  data			: out main_array(0 to X-1)(N-1 downto 0);
			  data_en		: out main_array(0 to X-1)(0 downto 0);
			  
			  -- To Dispatch unit
			  index_out : out main_array(0 to 4)(natural(log2(real(X)))-1 downto 0);		-- INDICATES READY REGISTERS
			  index_val : out main_array(0 to 4)(0 downto 0)										-- INDICATES READY REGISTERS
			);
	end entity;

architecture UU of update_unit is
	signal index : main_array(0 to 4)(natural(log2(real(X)))-1 downto 0) := (others => (others => '0'));
	signal valid : main_array(0 to 4)(0 downto 0) := (others => (others => '0'));
begin
	
	-- This gives me the index of the entries in the RS which match with the broadcast
	comparator1 : comparator generic map(tag_size => natural(log2(real(X))), tag_num => X, N => N)
								 port map(to_match => broadcast,
											 
											 data_out => data,
											 data_in => data_in,
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
				validity_out(to_integer(unsigned(index(I))))(0) <= '1';
			end if;
		end loop;
		validity_en  <= (others => (others => '0'));
		data_en		 <= (others => (others => '0'));
		validity_out <= (others => (others => '0'));
	end process;
	
end;