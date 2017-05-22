-- COMPLETE STRUCTURE OF THE RESERVATION STATIONS
-- INCLUDES ALL THE DISTRIBUTED RESERVATION STATIONS

library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity reservation_station is
		port(clk : in std_logic;
			  reset : in std_logic;
			  -- FROM DECODE
			  instruction1 : in std_logic_vector(62 downto 0);
			  instruction2 : in std_logic_vector(62 downto 0);
			  
			  -- TO DECODE
			  only_one_alu : out std_logic;
			  only_one_bch : out std_logic;
			  only_one_lst : out std_logic;
			  
			  -- TO ALU EXECUTING UNIT
			  alu_inst1 : out std_logic_vector(62 downto 0);
			  alu_inst2 : out std_logic_vector(62 downto 0);
			  
			  -- TO BRANCH EXECUTING UNIT
			  bch_inst1 : out std_logic_vector(62 downto 0);
			  
			  -- TO LOAD/STORE EXECUTING UNIT
			  lst_inst1 : out std_logic_vector(62 downto 0);
			  lst_inst2 : out std_logic_vector(62 downto 0);
			  );
	end entity;

architecture RS of reservation_station is
begin
	
	ALLOC_UNIT : allocating unit generic map(N_alu => 8,
														  N_bch => 4,
														  N_lst => 8)
										  port map	 (reset => reset,
														  clk	  => clk,
														  inst1 => instruction1,
														  inst2 => instruction2,
														  only_one_alu => only_one_alu
														  only_one_bch => only_one_bch
														  only_one_lst => only_one_lst
														  );
	
	-------------------------------------------------------------------------------------
	RESRV_ALU  : reservation_station generic map(N => 8,                                -
																X => 63)                               -
												port map   (clk   => clk,                          -
																reset => reset,                        -
																busy_in => ,                            
																busy_en => ,
																busy_out => ,
																ready_in => ,
																ready_en => ;
																ready_out => ,
																data_in => ,
																data_en => ,
																data_out => );
	
	RESRV_BCH  : reservation_station generic map(N => 4,
																X => 63)
												port map   (clk   => clk,
																reset => reset,
																busy_in => ,
																busy_en => ,
																busy_out => ,
																ready_in => ,
																ready_en => ;
																ready_out => ,
																data_in => ,
																data_en => ,
																data_out => );
	
	RESRV_LST  : reservation_station generic map(N => 8,
																X => 63)
												port map   (clk   => clk,
																reset => reset,
																busy_in => ,
																busy_en => ,
																busy_out => ,
																ready_in => ,
																ready_en => ;
																ready_out => ,
																data_in => ,
																data_en => ,
																data_out => );
	-------------------------------------------------------------------------------------------
	
	DISPATCH_ALU : dispatch_unit generic map(N => 8,
														  X => 62)
										  port map   (reset => reset,
														  clk   => clk,
														  
														  reg_data => ,
														  
														  index_out => ,
														  index_val => ,
														  
														  index_allocate => ,
														  valid_allocate => ,
														  
														  execute1 => ,
														  execute2 => );
	
	DISPATCH_BCH : dispatch_unit generic map(N => 4,
														  X => 62)
										  port map   (reset => reset,
														  clk   => clk,
														  
														  reg_data => ,
														  
														  index_out => ,
														  index_val => ,
														  
														  index_allocate => ,
														  valid_allocate => ,
														  
														  execute1 => ,
														  execute2 => );  --<<<<<<<<<<<<<<<<<<<< LOOK AT THIS
	
	DISPATCH_LST : dispatch_unit generic map(N => 8,
														  X => 62)
										  port map   (reset => reset,
														  clk   => clk,
														  
														  reg_data => ,
														  
														  index_out => ,
														  index_val => ,
														  
														  index_allocate => ,
														  valid_allocate => ,
														  
														  execute1 => ,
														  execute2 => );
	
end;