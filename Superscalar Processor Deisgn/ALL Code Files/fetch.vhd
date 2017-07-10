library ieee;
use ieee.std_logic_1164.all;

library work;
use work.components.all;
-- Used for accessing Branch Predictor and Incrementer

entity fetch is
	port(clk 		: in std_logic;
		  reset		: in std_logic;
		  stall		: in std_logic;
		  inst1		: out std_logic_vector(22 downto 0);
		  inst2		: out std_logic_vector(22 downto 0);
		  
		  bc_1		: out std_logic;
		  bc_2		: out std_logic
		  -- Bits represents Branch taken or not
		  -- Only relevant for branch instructions
	);
end entity;

architecture fetching of fetch is
	signal mux_pc,add_pc,pc_add_out 				: std_logic_vector(6 downto 0);
	signal bp_out 										: std_logic_vector(6 downto 0);
	signal mux_sel,not_stall 						: std_logic;
	
	signal pc1,pc2 									: std_logic_vector(6 downto 0);
	
begin
	
	not_stall <= '1';
	
	mem_map : instruction_memory port map(address_a => mux_pc,
													  address_b => add_pc,
													  clock		=> clk,
													  data_a		=> "0000000000000000",
													  data_b		=> "0000000000000000",
													  wren_a		=> '0',
													  wren_b		=> '0',
													  q_a			=> inst1(15 downto 0),
													  q_b			=> inst2(15 downto 0));
	
	mux	  : mux2 generic map(N => 7) port map(in0 	=> pc_add_out,
															  in1 	=> bp_out,
															  sel		=> mux_sel,
															  output => mux_pc);
	
	adder	  : inc port map(data0x => mux_pc,
								  data1x => "0000001",
								  result => add_pc);
	adder1  : inc port map(data0x => pc2,
								  data1x => "0000001",
								  result => pc_add_out);
								  
																	 
	pc1_reg : registers generic map(N => 7) port map(clk	  => clk,
																	 reset  => reset,
																	 enable => '1',
																	 input  => mux_pc,
																	 output => pc1);
	inst1(22 downto 16) <= pc1;
															
	pc2_reg : registers1 generic map(N => 7) port map(clk	  => clk,
																	  reset  => reset,
																	  enable => '1',
																	  input  => add_pc,
																	  output => pc2);
	inst2(22 downto 16) <= pc2;																 
	
	BP		  : branch_predictor port map(pc 	 => pc2,
													clk	 => clk,
													bp_out => bp_out,
													sel	 => mux_sel);
	
	-- sel = '0' => Not taken
	
	bc_1 <= mux_sel;
	bc_2 <= mux_sel;
end architecture;