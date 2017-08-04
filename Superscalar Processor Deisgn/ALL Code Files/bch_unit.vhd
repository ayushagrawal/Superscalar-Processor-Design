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
-- If not : Need to make a mechanism of flushing : Make use of ROB - easy but cycles wastage
-- If yes : continue as such

-- For checking the validity of the branch : Need an input from the ROB or it must come with the instruction


entity bch_unit is

		port(clk : in std_logic;
			  reset : in std_logic;
			  input : in std_logic_vector(56 downto 0);
			  output : out std_logic_vector(22 downto 0));
			  
end entity;

architecture bch_arch of bch_unit is
	
	
	
begin
	
	-- '0' => Not Taken
	
	process
		begin
		
		if(input(54 downto 53) = "00") then		-- BCH
			if((input(47 downto 32) = input(31 downto 16)) and input(56) = '1') then
				-- ALL GOOD
			elsif(not(input(47 downto 32) = input(31 downto 16)) and input(56) = '0') then
				-- ALL GOOD
			else
				-- NEED TO TAKE CORRECTIVE MEASURES
			end if;
		elsif(input(54 downto 53) = "01") then -- JAL
			--if(input()) then
			--end if;
		else	-- JLR
		
		end if;
		
	end process;
	output <= (others => '0');
	
end architecture;