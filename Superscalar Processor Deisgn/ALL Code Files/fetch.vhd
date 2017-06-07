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
		  inst2		: out std_logic_vector(22 downto 0));
end entity;

architecture fetching of fetch is
	signal mux_pc,add_pc,add_pc1,pc_add_out 	: std_logic_vector(6 downto 0);
	signal reg1_in,reg2_in 							: std_logic_vector(15 downto 0);
	signal pc_out,bp_out 							: std_logic_vector(6 downto 0);
	signal mux_sel,not_stall 						: std_logic;
	signal temp,mux_pc1,pc_add_out1				: std_logic_vector(6 downto 0);
begin
	
	not_stall <= not(stall);
	
	temp <= (others => reset);
	add_pc1 <= (not temp) and add_pc;
	mux_pc1 <= (not temp) and mux_pc;
	pc_add_out1 <= (not temp) and pc_add_out;
	
	mem_map : instruction_memory port map(address_a => mux_pc,
													  address_b => add_pc,
													  clock		=> clk,
													  data_a		=> "0000000000000000",
													  data_b		=> "0000000000000000",
													  wren_a		=> '0',
													  wren_b		=> '0',
													  q_a			=> reg1_in,
													  q_b			=> reg2_in);
	
	mux	  : mux2 generic map(N => 7) port map(in0 	=> pc_add_out1,
															  in1 	=> bp_out,
															  sel		=> mux_sel,
															  output => mux_pc);
	
	adder	  : inc port map(data0x => mux_pc,
								  data1x => "0000001",
								  result => add_pc);
	adder1  : inc port map(data0x => pc_out,
								  data1x => "0000001",
								  result => pc_add_out);
								  
	reg1	  : registers generic map(N => 16) port map(clk    => clk,
																	  reset	=> reset,
																	  enable => not_stall,
																	  input  => reg1_in,
																	  output => inst1(15 downto 0));
	
	reg2	  : registers generic map(N => 16) port map(clk    => clk,
																	  reset 	=> reset,
																	  enable => not_stall,
																	  input  => reg2_in,
																	  output => inst2(15 downto 0));
	
	pc_reg  : registers generic map(N => 7) port map(clk	  => clk,
																	 reset  => reset,
																	 enable => not_stall,
																	 input  => add_pc1,
																	 output => pc_out);
																	 
	pc1_reg : registers generic map(N => 7) port map(clk	  => clk,
																	 reset  => reset,
																	 enable => not_stall,
																	 input  => mux_pc1,
																	 output => inst1(22 downto 16));
															
	pc2_reg : registers generic map(N => 7) port map(clk	  => clk,
																	 reset  => reset,
																	 enable => not_stall,
																	 input  => add_pc1,
																	 output => inst2(22 downto 16));
	
	BP		  : branch_predictor port map(pc 	 => pc_out,
													clk	 => clk,
													bp_out => bp_out,
													sel	 => mux_sel);
	
end architecture;