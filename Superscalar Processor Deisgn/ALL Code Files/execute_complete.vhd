library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.components.all;

entity execute_complete is

	port(clk : in std_logic;
		  reset : in std_logic;
		  
		  -- TO ALU EXECUTING UNIT
		  alu_inst1 : in std_logic_vector(40 downto 0);
		  alu_inst2 : in std_logic_vector(40 downto 0);
		  
		  -- TO BRANCH EXECUTING UNIT
		  bch_inst1 : in std_logic_vector(56 downto 0);
		  
		  -- TO LOAD/STORE EXECUTING UNIT
		  lst_inst1 : in std_logic_vector(39 downto 0);
		  lst_inst2 : in std_logic_vector(39 downto 0);
		  
		  -- FROM EXECUTING UNITS
		  broadcast	: out main_array(0 to 4)(22 downto 0)	-- Max of 5 units can return
		  -- WB_Valid  = 1  bit
		  -- Data 		= 16 bits
		  -- Tag  		= 5  bits (RRF size)
		  -- Validity  = 1  bit
		  -- (In the above order) --
		  );
	
end entity;

architecture ex_comp of execute_complete is
	
	
	
begin
	
	alu_unit1 : alu_unit port map(clk => clk,
											reset => reset,
											input => alu_inst1,
											output => broadcast(0));
	
	alu_unit2 : alu_unit port map(clk => clk,
											reset => reset,
											input => alu_inst2,
											output => broadcast(1));
	
	bch_unit0 : bch_unit port map(clk => clk,
											reset => reset,
											input => bch_inst1,
											output => broadcast(2));
	
	lst_unit1 : lst_unit port map(clk => clk,
											reset => reset,
											input => lst_inst1,
											output => broadcast(3));
	
	lst_unit2 : lst_unit port map(clk => clk,
											reset => reset,
											input => lst_inst2,
											output => broadcast(4));
	
end architecture;