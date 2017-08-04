library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity rs_execute is
		port(clk : in std_logic;
			  reset : in std_logic;
			  
			  -- FROM DECODE
			  instruction1 : in std_logic_vector(72 downto 0);
			  instruction2 : in std_logic_vector(72 downto 0);
			  
			  -- TO DECODE
			  only_one_alu : out std_logic;
			  only_one_bch : out std_logic;
			  only_one_lst : out std_logic;
			  
			  -- TO ALL
			  broadcast : out main_array(0 to 4)(22 downto 0));
			  
	end entity;

architecture RS_ex of rs_execute is
	
	signal broadcast1 : main_array(0 to 4)(22 downto 0);
	signal alu_inst1,alu_inst2 : std_logic_vector(40 downto 0);
	signal bch_inst1				: std_logic_vector(56 downto 0);
	signal lst_inst1,lst_inst2 : std_logic_vector(39 downto 0);
	
begin
	
	Reserv_Statn : reservation_station_complete port map(clk => clk,
																		  reset => reset,
																		  
																		  instruction1 => instruction1,
																		  instruction2 => instruction2,
																		  
																		  only_one_alu => only_one_alu,
																		  only_one_bch => only_one_bch,
																		  only_one_lst => only_one_lst,
																		  
																		  alu_inst1_out => alu_inst1,
																		  alu_inst2_out => alu_inst2,
																		  bch_inst1_out => bch_inst1,
																		  lst_inst1_out => lst_inst1,
																		  lst_inst2_out => lst_inst2,
																		  
																		  broadcast => broadcast1);
	
	execute_units : execute_complete port map(clk => clk,
															reset => reset,
															
															alu_inst1 => alu_inst1,
															alu_inst2 => alu_inst2,
															bch_inst1 => bch_inst1,
															lst_inst2 => lst_inst1,
															lst_inst1 => lst_inst2,
															
															broadcast => broadcast1);
	
	broadcast <= broadcast1;
	
end;