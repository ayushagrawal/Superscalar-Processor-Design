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
			  input : in std_logic_vector(40 downto 0);
			  output : out std_logic_vector(22 downto 0));
			  
end entity;

architecture alu_arch of alu_unit is
	
	signal add_out,nand_out : std_logic_vector(15 downto 0);
	signal c_add,c_nand,z_add,z_nand : std_logic;
	signal reg_in : std_logic_vector(22 downto 0);
	
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
	
	-- structure of output : WB_VALIDITY:DATA:TAG:VALIDITY
	
	reg_in(0) <= input(40);								-- Validity
	reg_in(5 downto 1) <= input(36 downto 32);	-- ROB index
	
	process(input,add_out,nand_out,c_add,z_add,c_nand,z_nand)
	begin
		if(input(39) = '0') then
			reg_in(21 downto 6) <= add_out;
			if (input(38 downto 37) = "00") then
				reg_in(22) <= '1';
			elsif (input(38 downto 37) = "10") then
				reg_in(22) <= c_add;
			elsif (input(38 downto 37) = "01") then
				reg_in(22) <= z_add;
			else		-- ADI
				reg_in(22) <= '1';
			end if;
		else
			reg_in(21 downto 6) <= nand_out;
			if (input(38 downto 37) = "00") then
				reg_in(22) <= '1';
			elsif (input(38 downto 37) = "10") then
				reg_in(22) <= c_nand;
			else
				reg_in(22) <= z_nand;
			end if;
		end if;
	end process;
	
	reg_out : registers generic map(N => 23)
							  port 	 map(clk => clk,
											  reset => reset,
											  enable => '1',
											  input => reg_in,
											  output => output);
	
end architecture;