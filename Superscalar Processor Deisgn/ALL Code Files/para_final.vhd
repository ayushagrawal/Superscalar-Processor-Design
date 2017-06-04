library ieee;
use ieee.std_logic_1164.all;

library work;
use work.components.all;

entity para_final is
	port(clk 		: in std_logic;
		  reset		: in std_logic;
		  
		  -- FROM COMPLETE
		  in_sel1 : in std_logic_vector(2 downto 0);
		  in_sel2 : in std_logic_vector(2 downto 0);
		  input1  : in std_logic_vector(15 downto 0);
		  input2  : in std_logic_vector(15 downto 0);
		  wren1 : in std_logic;
		  wren2 : in std_logic;
		  
		  -- TO COMPLETE FROM ROB
		  complete1				: out std_logic_vector(37 downto 0);
		  complete2				: out std_logic_vector(37 downto 0));
		  
end entity;

architecture pfinal of para_final is

	signal instruction1,instruction2 : std_logic_vector(71 downto 0);
	signal broadcast : main_array(0 to 4)(22 downto 0);
	
	signal only_one_alu,only_one_bch,only_one_lst : std_logic;

begin
	
	F_D_RF : fetch_decode_rf port map(clk => clk,
												 reset => reset,
												 
												 in_sel1 => in_sel1,
												 in_sel2 => in_sel2,
												 input1 => input1,
												 input2 => input2,
												 wren1 => wren1,
												 wren2 => wren2,
												 
												 register1 => instruction1,
												 register2 => instruction2,
												 
												 broadcast => broadcast,
												 
												 complete1 => complete1,
												 complete2 => complete2);
												 
	RS_EX : rs_execute port map(clk => clk,
										 reset =>reset,
										 
										 instruction1 => instruction1,
										 instruction2 => instruction2,
										 
										 only_one_alu => only_one_alu,
										 only_one_lst => only_one_lst,
										 only_one_bch => only_one_bch,
										 
										 broadcast => broadcast);
	
end architecture;