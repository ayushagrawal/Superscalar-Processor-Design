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
			  
			  
			  -- FROM EXECUTING UNITS
			  broadcast	: in main_array(0 to 4)(21 downto 0);	-- Max of 5 units can return
			  -- Data 		= 16 bits
			  -- Tag  		= 5  bits (RRF size)
			  -- Validity  = 1 bit
			  -- (In the above order) --
			  );
	end entity;

architecture RS of reservation_station is

	signal rs_data_alu,rs_data_lst : main_array(0 to 7)(63 downto 0);
	signal rs_data_bch 				 : main_array(0 to 3)(63 downto 0);
	
	signal rs_data_in_alu,rs_data_in_lst : main_array(0 to 7)(63 downto 0);
	signal rs_data_in_bch					 : main_array(0 to 3)(63 downto 0);
	signal rs_data_en_alu,rs_data_en_lst : main_array(0 to 7)(0 downto 0);
	signal rs_data_en_bch					 : main_array(0 to 3)(0 downto 0);
	
	signal index_alu_allocate,index_lst_allocate : main_array(0 to 1)(2 downto 0);
	signal index_bch_allocate							: main_array(0 to 1)(1 downto 0);
	
	signal valid_alu_allocate,valid_lst_allocate,valid_bch_allocate : main_array(0 to 1)(0 downto 0);
	
	signal index_out_alu,index_out_lst : main_array(0 to 4)(2 downto 0);
	signal index_out_bch 				  : main_array(0 to 4)(1 downto 0);
	signal index_val_alu,index_val_lst : main_array(0 to 4)(0 downto 0);
	signal index_val_bch					  : main_array(0 to 4)(0 downto 0);

begin
	
	ALLOC_UNIT : allocating unit generic map(N_alu => 8,
														  N_bch => 4,
														  N_lst => 8)
										  port map	 (reset => reset,
														  clk	  => clk,
														  stall_out => ,
														  only_one_alu => only_one_alu,
														  only_one_bch => only_one_bch,
														  only_one_lst => only_one_lst,
														  
														  inst1 => instruction1,
														  inst2 => instruction2,
														  
														  reg_alu_data => rs_data_in_alu,
														  reg_alu_en => rs_data_en_alu,
														  reg_bch_data => rs_data_in_bch,
														  reg_bch_en => rs_data_en_bch,
														  reg_lst_data => rs_data_in_lst,
														  reg_lst_en => rs_data_en_lst,
														  
														  index_alu_allocate => index_alu_allocate,
														  valid_alu_allocate => valid_alu_allocate,
														  index_bch_allocate => index_bch_allocate,
														  valid_bch_allocate => valid_bch_allocate,
														  index_lst_allocate => index_lst_allocate,
														  valid_lst_allocate => valid_lst_allocate);
	
	-------------------------------------------------------------------------------------
	RESRV_ALU  : reservation_station generic map(N => 8,                                
																X => 63)					-- Data Length                               
												port map   (clk   => clk,                          
																reset => reset,                        
																busy_in => ,                            
																busy_en => ,
																busy_out => ,
																ready_in => ,
																ready_en => ;
																ready_out => ,
																data_in => rs_data_in_alu,
																data_en => rs_data_en_alu,
																data_out => rs_data_alu);
	
	RESRV_BCH  : reservation_station generic map(N => 4,
																X => 63)					-- Data Length
												port map   (clk   => clk,
																reset => reset,
																busy_in => ,
																busy_en => ,
																busy_out => ,
																ready_in => ,
																ready_en => ;
																ready_out => ,
																data_in => rs_data_in_bch,
																data_en => rs_data_en_bch,
																data_out => rs_data_bch);
	
	RESRV_LST  : reservation_station generic map(N => 8,
																X => 63)					-- Data Length
												port map   (clk   => clk,
																reset => reset,
																busy_in => ,
																busy_en => ,
																busy_out => ,
																ready_in => ,
																ready_en => ;
																ready_out => ,
																data_in => rs_data_in_lst,
																data_en => rs_data_en_lst,
																data_out => rs_data_lst);
	-------------------------------------------------------------------------------------------
	
	DISPATCH_ALU : dispatch_unit generic map(N => 8,
														  X => 63)
										  port map   (reset => reset,
														  clk   => clk,
														  
														  reg_data => rs_data_alu,
														  
														  index_out => index_out_alu,
														  index_val => index_val_alu,
														  
														  index_allocate => index_alu_allocate,
														  valid_allocate => valid_alu_allocate,
														  
														  execute1 => alu_inst1,
														  execute2 => alu_inst2);
	
	DISPATCH_BCH : dispatch_unit generic map(N => 4,
														  X => 62)
										  port map   (reset => reset,
														  clk   => clk,
														  
														  reg_data => rs_data_bch,
														  
														  index_out => index_out_bch,
														  index_val => index_val_bch,
														  
														  index_allocate => index_bch_allocate,
														  valid_allocate => valid_bch_allocate,
														  
														  execute1 => bch_inst1,
														  execute2 => );  --<<<<<<<<<<<<<<<<<<<< LOOK AT THIS
	
	DISPATCH_LST : dispatch_unit generic map(N => 8,
														  X => 62)
										  port map   (reset => reset,
														  clk   => clk,
														  
														  reg_data => rs_data_lst,
														  
														  index_out => index_out_lst,
														  index_val => index_val_lst,
														  
														  index_allocate => index_lst_allocate,
														  valid_allocate => valid_lst_allocate,
														  
														  execute1 => lst_inst1,
														  execute2 => lst_inst2);
														  
	---------------------------------------------------------------------------------------------
	
	UPDATE_ALU : update unit generic map(N => 32,			-- Entries in ROB
													 X => 8)				-- Entries in RF
									 port map   (broadcast => broadcast,
													 tag => ,
													 busy => ,
													 validity_out => ,
													 valildity_en => ,
													 data => ,
													 data_en => ,
													 index_out => index_out_alu,
													 index_val => index_val_alu);
	
	UPDATE_BCH : update unit generic map(N => 32,			-- Entries in ROB
													 X => 4)				-- Entries in RF
									 port map   (broadcast => broadcast,
													 tag => ,
													 busy => ,
													 validity_out => ,
													 valildity_en => ,
													 data => ,
													 data_en => ,
													 index_out => index_out_bch,
													 index_val => index_val_bch);
													 
	UPDATE_LST : update unit generic map(N => 32,			-- Entries in ROB
													 X => 8)				-- Entries in RF
									 port map   (broadcast => broadcast,
													 tag => ,
													 busy => ,
													 validity_out => ,
													 valildity_en => ,
													 data => ,
													 data_en => ,
													 index_out => index_out_lst,
													 index_val => index_val_lst);
													 
	--------------------------------------------------------------------------------------------
	
end;