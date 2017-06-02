-- COMPLETE STRUCTURE OF THE RESERVATION STATIONS
-- INCLUDES ALL THE DISTRIBUTED RESERVATION STATIONS

library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity reservation_station_complete is
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
			  alu_inst1_out : out std_logic_vector(40 downto 0);
			  alu_inst2_out : out std_logic_vector(40 downto 0);
			  
			  -- TO BRANCH EXECUTING UNIT
			  bch_inst1_out : out std_logic_vector(55 downto 0);
			  
			  -- TO LOAD/STORE EXECUTING UNIT
			  lst_inst1_out : out std_logic_vector(39 downto 0);
			  lst_inst2_out : out std_logic_vector(39 downto 0);
			  
			  
			  -- FROM EXECUTING UNITS
			  broadcast	: in main_array(0 to 4)(22 downto 0)	-- Max of 5 units can return
			  -- WB_valid  = 1  bit
			  -- Data 		= 16 bits
			  -- Tag  		= 5  bits (RRF size)
			  -- Validity  = 1 bit
			  -- (In the above order) --
			  );
	end entity;

architecture RS of reservation_station_complete is

	signal rs_data_alu,rs_data_lst : main_array(0 to 7)(62 downto 0);
	signal rs_data_bch 				 : main_array(0 to 3)(62 downto 0);
	
	signal rs_data_in_alu_alloc,rs_data_in_lst_alloc : main_array(0 to 7)(62 downto 0);
	signal rs_data_in_bch_alloc							 : main_array(0 to 3)(62 downto 0);
	signal rs_data_in_alu_updte,rs_data_in_lst_updte : main_array(0 to 7)(62 downto 0);
	signal rs_data_in_bch_updte							 : main_array(0 to 3)(62 downto 0);
	signal rs_data_en_alu_alloc,rs_data_en_lst_alloc : main_array(0 to 7)(0 downto 0);
	signal rs_data_en_bch_alloc							 : main_array(0 to 3)(0 downto 0);
	signal rs_data_en_alu_updte,rs_data_en_lst_updte : main_array(0 to 7)(0 downto 0);
	signal rs_data_en_bch_updte							 : main_array(0 to 3)(0 downto 0);
	
	signal index_alu_allocate,index_lst_allocate : main_array(0 to 1)(2 downto 0);
	signal index_bch_allocate							: main_array(0 to 1)(1 downto 0);
	
	signal valid_alu_allocate,valid_lst_allocate,valid_bch_allocate : main_array(0 to 1)(0 downto 0);
	
	signal index_out_alu,index_out_lst : main_array(0 to 4)(2 downto 0);
	signal index_out_bch 				  : main_array(0 to 4)(1 downto 0);
	signal index_val_alu,index_val_lst : main_array(0 to 4)(0 downto 0);
	signal index_val_bch					  : main_array(0 to 4)(0 downto 0);
	
	signal busy_alu,busy_lst : main_array(0 to 7)(0 downto 0);
	signal busy_bch			 : main_array(0 to 3)(0 downto 0);
	
	signal rs_valid_in_alu,rs_valid_in_lst,ready_alu : main_array(0 to 7)(0 downto 0);
	signal rs_valid_in_bch,ready_bch 					 : main_array(0 to 3)(0 downto 0);
	signal rs_valid_en_alu,rs_valid_en_lst,ready_lst : main_array(0 to 7)(0 downto 0);
	signal rs_valid_en_bch 									 : main_array(0 to 3)(0 downto 0);
	
	signal busy_alu_in,busy_lst_in,busy_lst_en,busy_alu_en : main_array(0 to 7)(0 downto 0);
	signal busy_bch_in,busy_bch_en							    : main_array(0 to 3)(0 downto 0);
	signal stall_out													 : std_logic;
	
	signal tag_alu,tag_lst : main_array(0 to 7)(4 downto 0);
	signal tag_bch			  : main_array(0 to 3)(4 downto 0);
	
	signal inst_ready_alu,inst_ready_bch,inst_ready_lst : main_array(0 to 1)(0 downto 0);
	signal indx_alloc_alu,indx_alloc_lst : main_array(0 to 1)(2 downto 0);
	signal indx_alloc_bch 					 : main_array(0 to 1)(1 downto 0);

	signal alu_inst1,alu_inst2,bch_inst1,lst_inst1,lst_inst2 : std_logic_vector(62 downto 0);
	
begin
	
	alu_inst1_out(43) 			 <= alu_inst1(62);
	alu_inst1_out(42 downto 16) <= alu_inst1(60 downto 34);
	alu_inst1_out(15 downto 0)  <= alu_inst1(32 downto 17);
	
	alu_inst2_out(43) 			 <= alu_inst2(62);
	alu_inst2_out(42 downto 16) <= alu_inst2(60 downto 34);
	alu_inst2_out(15 downto 0)  <= alu_inst2(32 downto 17);
	
	lst_inst1_out(42) 			 <= lst_inst1(62);
	lst_inst1_out(41 downto 16) <= lst_inst1(59 downto 34);
	lst_inst1_out(15 downto 0)  <= lst_inst1(32 downto 17);
	
	lst_inst2_out(42) 			 <= lst_inst2(62);
	lst_inst2_out(41 downto 16) <= lst_inst2(59 downto 34);
	lst_inst2_out(15 downto 0)  <= lst_inst2(32 downto 17);
	
	bch_inst1_out(58) 			 <= bch_inst1(62);
	bch_inst1_out(57 downto 32) <= bch_inst1(59 downto 34);
	bch_inst1_out(31 downto 16) <= bch_inst1(32 downto 17);
	bch_inst1_out(15 downto 0)  <= bch_inst1(15 downto 0);
	
	ALLOC_UNIT : allocating_unit generic map(N_alu => 8,
														  N_bch => 4,
														  N_lst => 8,
														  X_alu => 63,
														  X_bch => 63,
														  X_lst => 63)
										  port map	 (reset     => reset,
														  clk	      => clk,
														  stall_out => stall_out,
														  only_one_alu => only_one_alu,
														  only_one_bch => only_one_bch,
														  only_one_lst => only_one_lst,
														  
														  -- FROM RF
														  inst1 => instruction1,
														  inst2 => instruction2,
														  
														  -- TO RS
														  reg_alu_data => rs_data_in_alu_alloc,
														  reg_alu_en   => rs_data_en_alu_alloc,
														  busy_alu		=> busy_alu_in,
														  busy_alu_en  => busy_alu_en,
														  reg_bch_data => rs_data_in_bch_alloc,
														  reg_bch_en   => rs_data_en_bch_alloc,
														  busy_bch		=> busy_bch_in,
														  busy_bch_en  => busy_bch_en,
														  reg_lst_data => rs_data_in_lst_alloc,
														  reg_lst_en   => rs_data_en_lst_alloc,
														  busy_lst		=> busy_lst_in,
														  busy_lst_en  => busy_lst_en,
														  
														  -- FROM DISPATCHING UNITS
														  index_alu_allocate => index_alu_allocate,
														  valid_alu_allocate => valid_alu_allocate,
														  index_bch_allocate => index_bch_allocate,
														  valid_bch_allocate => valid_bch_allocate,
														  index_lst_allocate => index_lst_allocate,
														  valid_lst_allocate => valid_lst_allocate,
														  
														  -- TO DISPATCH UNIT
														  inst_ready_alu => inst_ready_alu,
														  inst_ready_bch => inst_ready_bch,
														  inst_ready_lst => inst_ready_lst,
														  indx_alloc_alu => indx_alloc_alu,
														  indx_alloc_bch => indx_alloc_bch,
														  indx_alloc_lst => indx_alloc_lst);
	
	-------------------------------------------------------------------------------------
	RESRV_ALU  : reservation_station generic map(N => 8,              -- Number of entries                  
																X => 63)					-- Data Length                               
												port map   (clk      => clk,                          
																reset    => reset,                        
																busy_in  => busy_alu_in,                            
																busy_en  => busy_alu_en,
																busy_out => busy_alu,
																ready_in => rs_valid_in_alu,
																ready_en => rs_valid_en_alu,
																ready_out => ready_alu,
																data_in_updte => rs_data_in_alu_updte,
																data_en_updte => rs_data_en_alu_updte,
																data_in_alloc => rs_data_in_alu_alloc,
																data_en_alloc => rs_data_en_alu_alloc,
																data_out => rs_data_alu);
	
	RESRV_BCH  : reservation_station generic map(N => 4,              -- Number of entries
																X => 63)					-- Data Length
												port map   (clk   => clk,
																reset => reset,
																busy_in => busy_bch_in,
																busy_en => busy_bch_en,
																busy_out => busy_bch,
																ready_in => rs_valid_in_bch,
																ready_en => rs_valid_en_bch,
																ready_out => ready_bch,
																data_in_updte => rs_data_in_bch_updte,
																data_en_updte => rs_data_en_bch_updte,
																data_in_alloc => rs_data_in_bch_alloc,
																data_en_alloc => rs_data_en_bch_alloc,
																data_out => rs_data_bch);
	
	RESRV_LST  : reservation_station generic map(N => 8,              -- Number of entries
																X => 63)					-- Data Length
												port map   (clk   => clk,
																reset => reset,
																busy_in => busy_lst_in,
																busy_en => busy_lst_en,
																busy_out => busy_lst,
																ready_in => rs_valid_in_lst,
																ready_en => rs_valid_en_lst,
																ready_out => ready_lst,
																data_in_updte => rs_data_in_lst_updte,
																data_en_updte => rs_data_en_lst_updte,
																data_in_alloc => rs_data_in_lst_alloc,
																data_en_alloc => rs_data_en_lst_alloc,
																data_out => rs_data_lst);
	-------------------------------------------------------------------------------------------
	
	DISPATCH_ALU : dispatch_unit generic map(N => 8,
														  X => 63)
										  port map   (reset => reset,
														  clk   => clk,
														  
														  -- FROM ALLOCATING UNIT
														  inst_ready => inst_ready_alu,
														  indx_alloc => indx_alloc_alu,
														  
														  -- TO RS
														  reg_data => rs_data_alu,
														  
														  index_out => index_out_alu,
														  index_val => index_val_alu,
														  
														  -- TO ALLOCATING UNIT
														  index_allocate => index_alu_allocate,
														  valid_allocate => valid_alu_allocate,
														  
														  execute1 => alu_inst1,
														  execute2 => alu_inst2);
	
	DISPATCH_BCH : dispatch_unit_bch generic map(N => 4,
																X => 63)
											  port map   (reset => reset,
															  clk   => clk,
															  
														     -- FROM ALLOCATING UNIT
														     inst_ready => inst_ready_bch,
															  indx_alloc => indx_alloc_bch,
															  
															  reg_data => rs_data_bch,
															  
															  index_out => index_out_bch,
															  index_val => index_val_bch,
															  
															  index_allocate => index_bch_allocate,
															  valid_allocate => valid_bch_allocate,
															  
															  execute1 => bch_inst1); 
	
	DISPATCH_LST : dispatch_unit generic map(N => 8,
														  X => 63)
										  port map   (reset => reset,
														  clk   => clk,
														  
														  -- FROM ALLOCATING UNIT
														  inst_ready => inst_ready_lst,
														  indx_alloc => indx_alloc_lst,
														  
														  reg_data => rs_data_lst,
														  
														  index_out => index_out_lst,
														  index_val => index_val_lst,
														  
														  index_allocate => index_lst_allocate,
														  valid_allocate => valid_lst_allocate,
														  
														  execute1 => lst_inst1,
														  execute2 => lst_inst2);
														  
	---------------------------------------------------------------------------------------------
	
	UPDATE_ALU : update_unit generic map(N => 63,			-- Data Length
													 X => 8)				-- Entries in RF
									 port map   (broadcast => broadcast,
													 busy => busy_alu,
													 validity_out => rs_valid_in_alu,
													 validity_en => rs_valid_en_alu,
													 data_in => rs_data_alu,
													 data => rs_data_in_alu_updte,
													 data_en => rs_data_en_alu_updte,
													 index_out => index_out_alu,
													 index_val => index_val_alu);
	
	UPDATE_BCH : update_unit generic map(N => 63,			-- Data Length
													 X => 4)				-- Entries in RF
									 port map   (broadcast => broadcast,
													 busy => busy_bch,
													 validity_out => rs_valid_in_bch,
													 validity_en => rs_valid_en_bch,
													 data_in => rs_data_bch,
													 data => rs_data_in_bch_updte,
													 data_en => rs_data_en_bch_updte,
													 index_out => index_out_bch,
													 index_val => index_val_bch);
													 
	UPDATE_LST : update_unit generic map(N => 63,			-- Data Length
													 X => 8)				-- Entries in RF
									 port map   (broadcast => broadcast,
													 busy => busy_lst,
													 validity_out => rs_valid_in_lst,
													 validity_en => rs_valid_en_lst,
													 data_in => rs_data_lst,
													 data      => rs_data_in_lst_updte,
													 data_en   => rs_data_en_lst_updte,
													 index_out => index_out_lst,
													 index_val => index_val_lst);
													 
	--------------------------------------------------------------------------------------------
	
end;