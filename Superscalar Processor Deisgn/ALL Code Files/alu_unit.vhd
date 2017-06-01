-- TO BE COMPMETED IN A SINGLE CLOCK CYCLE
-- TO TO PROVIDE REGISTER FOR RESULTS

-- The flags does not take part in calculation but takes part in decision making

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.components.all;

entity alu_unit is

		port(clk : in std_logic;
			  reset : in std_logic;
			  input : in std_logic_vector(43 downto 0);
			  output : out std_logic_vector(21 downto 0));
			  
end entity;

architecture alu_arch of alu_unit is
	
	signal add_out,nand_out : std_logic_vector(15 downto 0);
	signal c_add,c_nand,z_add,z_nand : std_logic;
	
begin

	-- Structure of input: validity:opcode:rob_index:wb_reg:r1_val:r2_val
	
	Adding_unit  : ADD_UNIT  generic map(N => 16)
									 port map(in1 => input(31 downto 16),
												 in2 => input(15 downto 0),
												 output => add_out,
												 carry => c_add,
												 zero => z_add);
	
	Nanding_unit : NAND_UNIT generic map(N => 16)
									 port map(in1 => input(31 downto 16),
												 in2 => input(15 downto 0),
												 output => nand_out,
												 carry => c_nand,
												 zero => z_nand);
	
	-- structure of output : 

--	reg_out : registers generic map(N => 22)
--							  port 	 map(clk => clk,
--											  reset => reset,
--											  enable => '1',
--											  input => reg_in,
--											  output => output);
	
end architecture;