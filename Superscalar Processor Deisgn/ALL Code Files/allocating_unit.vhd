
-- 
-- DIRECTLY INTERFACED WITH THE DEOCDE STAGE OR THE REGISTER FILE
-- AS MAYBE THE CASE
-- _______________________________________________________________
-- THIS IS CENTRAL IN CASE OF THE DISTRIBUTED RESERVATION STATION|
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--

-- THIS DESIGN IS FOR THE DISTRIBUTED RESERVATION SYSTEM SYSTEM:
-- FREE QUEUE IS MAINTAINED FOR:
-- 	1. ALU TYPE INSTRUCTIONS
--		2. BRANCH TYPE INSTRUCTIONS
--		3. LOAD/STORE TYPE INSTRUCTIONS


library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
library work;
use work.components.all;


entity allocating_unit is
		generic(N_alu 	: integer := 8;			-- Number of registers in the ALU reservation station = Number of entries in the Free Queue
				  N_bch 	: integer := 4;			-- Number of registers in the ALU reservation station = Number of entries in the Free Queue
				  N_lst 	: integer := 16;			-- Number of registers in the ALU reservation station = Number of entries in the Free Queue
				  X 		: integer := 62);			-- Size of each register
		port(reset : in std_logic;
			  clk : in std_logic;
			  stall_out : out std_logic;
			  only_one_alu : out std_logic;
			  only_one_bch : out std_logic;
			  only_one_lst : out std_logic;
			  
			  -- FROM DECODE
			  inst1 : in std_logic_vector(62 downto 0);
			  inst2 : in std_logic_vector(62 downto 0);
			  
			  -- TO RESERVATION STATION (NEED TO CONSIDER FROM ALL THE RESERVATION STATION)
			  reg_alu_data : out main_array(0 to N_alu-1)(X-1 downto 0);
			  reg_alu_en   : out main_array(0 to N_alu-1)(0 downto 0);
			  reg_bch_data : out main_array(0 to N_bch-1)(X-1 downto 0);
			  reg_bch_en   : out main_array(0 to N_bch-1)(0 downto 0);
			  reg_lst_data : out main_array(0 to N_lst-1)(X-1 downto 0);
			  reg_lst_en   : out main_array(0 to N_lst-1)(0 downto 0);
			  
			  
			  
			  -- FROM DISPATCHING UNITs
			  index_alu_allocate : in main_array(0 to 1)(natural(log2(real(N_alu)))-1 downto 0);
					-- Indicates the indices of the freed entries in the RS
			  valid_alu_allocate : in main_array(0 to 1)(0 downto 0);
					--Indicates the validity of the above data
			  index_bch_allocate : in main_array(0 to 1)(natural(log2(real(N_bch)))-1 downto 0);
					-- Indicates the indices of the freed entries in the RS
			  valid_bch_allocate : in main_array(0 to 1)(0 downto 0);
					--Indicates the validity of the above data
			  index_lst_allocate : in main_array(0 to 1)(natural(log2(real(N_lst)))-1 downto 0);
					-- Indicates the indices of the freed entries in the RS
			  valid_lst_allocate : in main_array(0 to 1)(0 downto 0)
					--Indicates the validity of the above data
			  );
	end entity;

architecture AU of allocating_unit is
	
	signal index_alu_in,index_alu_out : main_array(0 to N_alu-1)(natural(log2(real(N_alu)))-1 downto 0);
	signal index_bch_in,index_bch_out : main_array(0 to N_bch-1)(natural(log2(real(N_bch)))-1 downto 0);
	signal index_lst_in,index_lst_out : main_array(0 to N_lst-1)(natural(log2(real(N_lst)))-1 downto 0);
	signal index_alu_en,valid_alu_in,valid_alu_out,valid_alu_en : main_array(0 to N_alu-1)(0 downto 0);
	signal index_bch_en,valid_bch_in,valid_bch_out,valid_bch_en : main_array(0 to N_bch-1)(0 downto 0);
	signal index_lst_en,valid_lst_in,valid_lst_out,valid_lst_en : main_array(0 to N_lst-1)(0 downto 0);
	
--	 FOR KEEPING A TRACK OF VALID INSTRUCTION_________________________________________________________________
	signal top_alu_in,top_alu_out,top_alu_add,top_alu_add_one : std_logic_vector(natural(log2(real(N_alu)))-1 downto 0);
	signal bottom_alu_in,bottom_alu_out,bottom_alu_out_add,bottom_alu_add : std_logic_vector(natural(log2(real(N_alu)))-1 downto 0);
	signal top_bch_in,top_bch_out,top_bch_add,top_bch_add_one : std_logic_vector(natural(log2(real(N_bch)))-1 downto 0);
	signal bottom_bch_in,bottom_bch_out,bottom_bch_out_add,bottom_bch_add : std_logic_vector(natural(log2(real(N_bch)))-1 downto 0);
	signal top_lst_in,top_lst_out,top_lst_add,top_lst_add_one : std_logic_vector(natural(log2(real(N_lst)))-1 downto 0);
	signal bottom_lst_in,bottom_lst_out,bottom_lst_out_add,bottom_lst_add : std_logic_vector(natural(log2(real(N_lst)))-1 downto 0);
--	____________________________________________________________________________________________________________
	
	signal stall_alu,stall_bch,stall_lst,not_stall_alu,not_stall_bch,not_stall_lst : std_logic;
	
begin	
	
	stall_out <= stall_alu and stall_bch and stall_lst;
	not_stall_alu <= not stall_alu;
	not_stall_bch <= not stall_bch;
	not_stall_lst <= not stall_lst;
	
	GEN_ALU : for I in 0 to N_alu-1
				 generate
				 BUFF_I_ALU : registers generic map(N => natural(log2(real(N_alu))))
												port map (reset => '0',
															 clk	 => clk,
															 input => index_alu_in(I),
															 output=> index_alu_out(I),
															 enable=> index_alu_en(I)(0));
				 BUFF_V_ALU : registers generic map(N => 1)
												port map (reset => '0',
															 clk	 => clk,
															 input => valid_alu_in(I),
															 output=> valid_alu_out(I),
															 enable=> valid_alu_en(I)(0));
				 end generate;
	
	GEN_BCH : for I in 0 to N_bch-1
				 generate
				 BUFF_I_BCH : registers generic map(N => natural(log2(real(N_bch))))
												port map (reset => '0',
															 clk	 => clk,
															 input => index_bch_in(I),
															 output=> index_bch_out(I),
															 enable=> index_bch_en(I)(0));
				 BUFF_V_BCH : registers generic map(N => 1)
												port map (reset => '0',
															 clk	 => clk,
															 input => valid_bch_in(I),
															 output=> valid_bch_out(I),
															 enable=> valid_bch_en(I)(0));
				 end generate;
	
	GEN_LST : for I in 0 to N_lst-1
				 generate
				 BUFF_I_LST : registers generic map(N => natural(log2(real(N_lst))))
												port map (reset => '0',
															 clk	 => clk,
															 input => index_lst_in(I),
															 output=> index_lst_out(I),
															 enable=> index_lst_en(I)(0));
				 BUFF_V_LST : registers generic map(N => 1)
												port map (reset => '0',
															 clk	 => clk,
															 input => valid_lst_in(I),
															 output=> valid_lst_out(I),
															 enable=> valid_lst_en(I)(0));
				 end generate;
	
	top_alu_pointer 	: registers generic map(N => natural(log2(real(N_alu))))
										port map(reset => reset,
													clk   => clk,
													input => top_alu_in,
													output=> top_alu_out,
													enable=> '1');
												
	bottom_alu_pointer : registers generic map(N => natural(log2(real(N_alu))))
										port map(reset => reset,
													clk   => clk,
													input => bottom_alu_in,
													output=> bottom_alu_out,
													enable=> '1');
	
	top_bch_pointer 	: registers generic map(N => natural(log2(real(N_bch))))
										port map(reset => reset,
													clk   => clk,
													input => top_bch_in,
													output=> top_bch_out,
													enable=> '1');
												
	bottom_bch_pointer : registers generic map(N => natural(log2(real(N_bch))))
										port map(reset => reset,
													clk   => clk,
													input => bottom_bch_in,
													output=> bottom_bch_out,
													enable=> '1');
													
	top_lst_pointer 	: registers generic map(N => natural(log2(real(N_lst))))
										port map(reset => reset,
													clk   => clk,
													input => top_lst_in,
													output=> top_lst_out,
													enable=> '1');
												
	bottom_lst_pointer : registers generic map(N => natural(log2(real(N_lst))))
										port map(reset => reset,
													clk   => clk,
													input => bottom_lst_in,
													output=> bottom_lst_out,
													enable=> '1');
	
-- ______________________________________________________________________________________________________
	
	adder0 : adds generic map(N => natural(log2(real(N_alu)))) port map(data1 => bottom_alu_out,
																						 data2 => (0 => '1',others => '0'),
																						 output => bottom_alu_out_add);
	
	adder1 : adds generic map(N => natural(log2(real(N_alu)))) port map(data1 => bottom_alu_out,
																						 data2 => bottom_alu_add,
																						 output => bottom_alu_in);
	
	adder2 : adds generic map(N => natural(log2(real(N_alu)))) port map(data1 => top_alu_out,
																						 data2 => top_alu_add,
																						 output => top_alu_in);
																						 
	adder3 : adds generic map(N => natural(log2(real(N_alu)))) port map(data1 => bottom_alu_out,
																						 data2 => (0 => '1',others => '0'),
																						 output => top_alu_add_one);																					 
	
	adder4 : adds generic map(N => natural(log2(real(N_bch)))) port map(data1 => bottom_bch_out,
																						 data2 => (0 => '1',others => '0'),
																						 output => bottom_bch_out_add);
	
	adder5 : adds generic map(N => natural(log2(real(N_bch)))) port map(data1 => bottom_bch_out,
																						 data2 => bottom_bch_add,
																						 output => bottom_bch_in);
	
	adder6 : adds generic map(N => natural(log2(real(N_bch)))) port map(data1 => top_bch_out,
																						 data2 => top_bch_add,
																						 output => top_bch_in);
																						 
	adder7 : adds generic map(N => natural(log2(real(N_bch)))) port map(data1 => bottom_bch_out,
																						 data2 => (0 => '1',others => '0'),
																						 output => top_bch_add_one);
	
	adder8 : adds generic map(N => natural(log2(real(N_lst)))) port map(data1 => bottom_lst_out,
																						 data2 => (0 => '1',others => '0'),
																						 output => bottom_lst_out_add);
	
	adder9 : adds generic map(N => natural(log2(real(N_lst)))) port map(data1 => bottom_lst_out,
																						 data2 => bottom_lst_add,
																						 output => bottom_lst_in);
	
	adder10: adds generic map(N => natural(log2(real(N_lst)))) port map(data1 => top_lst_out,
																						 data2 => top_lst_add,
																						 output => top_lst_in);
																						 
	adder11: adds generic map(N => natural(log2(real(N_lst)))) port map(data1 => bottom_lst_out,
																						 data2 => (0 => '1',others => '0'),
																						 output => top_lst_add_one);
	
-- _____________________________________________________________________________________________________	
	
	process(valid_alu_out,inst1,index_alu_out,bottom_alu_out_add,inst2,bottom_alu_in,not_stall_alu,reset,valid_alu_allocate,index_alu_allocate,top_alu_add_one,top_alu_in,index_alu_in,index_alu_en,valid_alu_in,valid_alu_en)
		variable count : integer;
	begin
		count := 0;
		for I in 0 to N_alu-1 loop
			if(valid_alu_out(I)(0) = '1') then
				count := count + 1;
			else
				count := count;
			end if;
		end loop;
		if(count = 0) then
			stall_alu <= '1';
			only_one_alu <= '0';
		elsif(count = 1) then
			stall_alu <= '0';
			only_one_alu <= '1';
		else
			stall_alu <= '0';
			only_one_alu <= '0';
		end if;
		
		if(inst1(62) = '1') then		-- VALID INSTRUCTION
			reg_alu_data(to_integer(unsigned(index_alu_out(to_integer(unsigned(bottom_alu_out_add)))))) <= inst1;
			reg_alu_en(to_integer(unsigned(index_alu_out(to_integer(unsigned(bottom_alu_out_add)))))) <= "1";
		end if;
		
		if(inst2(62) = '1') then
			bottom_alu_add <= (0 =>  not inst1(0), 1 => inst1(0), others => '0');
			reg_alu_data(to_integer(unsigned(index_alu_out(to_integer(unsigned(bottom_alu_in)))))) <= inst1;
			reg_alu_en(to_integer(unsigned(index_alu_out(to_integer(unsigned(bottom_alu_in)))))) <= "1";
		else
			bottom_alu_add <= (0 => inst1(0), others => '0');
		end if;
		
		reg_alu_data <= (others => (others => '0')); 
		reg_alu_en <= (others => (others => '0')); 
		
		
		-- FOR INITIALIZING THE INDEX OF THE 'FREE QUEUE' : Using Dispatching Data
		if (reset = '1') then
			for I in 0 to N_alu-1 loop
				index_alu_in(I) <= std_logic_vector(to_unsigned(I,natural(log2(real(N_alu)))));
				index_alu_en(I)(0) <= '1';
				valid_alu_in(I)(0) <= '1';
				valid_alu_en(I)(0) <= '1';
			end loop;
			top_alu_add <= (others => '0');
		else
			-- General update policy: Using Dispatching data
			if (valid_alu_allocate(0)(0) = '1' and valid_alu_allocate(1)(0) = '1') then		-- Indicates 2 instructions are dispatched
				top_alu_add <= (1 => '1', others => '0');
				index_alu_in(to_integer(unsigned(top_alu_add_one))) <= index_alu_allocate(0);
				index_alu_en(to_integer(unsigned(top_alu_add_one)))(0) <= '1';
				index_alu_in(to_integer(unsigned(top_alu_in))) <= index_alu_allocate(1);
				index_alu_en(to_integer(unsigned(top_alu_in)))(0) <= '1';
				index_alu_in <= (others => (others => '0'));
				index_alu_en <= (others => (others => '0'));
				valid_alu_in(to_integer(unsigned(top_alu_add_one)))(0) <= '1';
				valid_alu_en(to_integer(unsigned(top_alu_add_one)))(0) <= '1';
				valid_alu_in(to_integer(unsigned(top_alu_in)))(0) <= '1';
				valid_alu_en(to_integer(unsigned(top_alu_in)))(0) <= '1';
				valid_alu_in <= (others => (others => '0'));
				valid_alu_en <= (others => (others => '0'));
			else
				top_alu_add <= (0 => valid_alu_allocate(0)(0) and valid_alu_allocate(1)(0), others => '0');
				if (valid_alu_allocate(0)(0) = '1') then
					index_alu_in(to_integer(unsigned(top_alu_add_one))) <= index_alu_allocate(0);
					index_alu_en(to_integer(unsigned(top_alu_add_one)))(0) <= '1';
					index_alu_in <= (others => (others => '0'));
					index_alu_en <= (others => (others => '0'));
					valid_alu_in(to_integer(unsigned(top_alu_add_one)))(0) <= '1';
					valid_alu_en(to_integer(unsigned(top_alu_add_one)))(0) <= '1';
					valid_alu_in <= (others => (others => '0'));
					valid_alu_en <= (others => (others => '0'));
				elsif(valid_alu_allocate(1)(0) = '1') then
					index_alu_in(to_integer(unsigned(top_alu_add_one))) <= index_alu_allocate(1);
					index_alu_en(to_integer(unsigned(top_alu_add_one)))(0) <= '1';
					index_alu_in <= (others => (others => '0'));
					index_alu_en <= (others => (others => '0'));
					valid_alu_in(to_integer(unsigned(top_alu_add_one)))(0) <= '1';
					valid_alu_en(to_integer(unsigned(top_alu_add_one)))(0) <= '1';
					valid_alu_in <= (others => (others => '0'));
					valid_alu_en <= (others => (others => '0'));
				else
					index_alu_in <= (others => (others => '0'));
					index_alu_en <= (others => (others => '0'));
					valid_alu_in <= (others => (others => '0'));
					valid_alu_en <= (others => (others => '0'));
				end if;
			end if;			
		end if;
	end process;
	----------------------------------------------------------------------------------------------------------
	process(valid_bch_out,inst1,index_bch_out,bottom_bch_out_add,inst2,bottom_bch_in,not_stall_bch,reset,valid_bch_allocate,index_bch_allocate,top_bch_add_one,top_bch_in,index_bch_in,index_bch_en,valid_bch_in,valid_bch_en)
		variable count : integer;
	begin
		count := 0;
		for I in 0 to N_bch-1 loop
			if(valid_bch_out(I)(0) = '1') then
				count := count + 1;
			else
				count := count;
			end if;
		end loop;
		if(count = 0) then
			stall_bch <= '1';
			only_one_bch <= '0';
		elsif(count = 1) then
			stall_bch <= '0';
			only_one_bch <= '1';
		else
			stall_bch <= '0';
			only_one_bch <= '0';
		end if;
		
		if(inst1(62) = '1') then		-- VALID INSTRUCTION
			reg_bch_data(to_integer(unsigned(index_bch_out(to_integer(unsigned(bottom_bch_out_add)))))) <= inst1;
			reg_bch_en(to_integer(unsigned(index_bch_out(to_integer(unsigned(bottom_bch_out_add)))))) <= "1";
		end if;
		
		if(inst2(62) = '1') then
			bottom_bch_add <= (0 =>  not inst1(0), 1 => inst1(0), others => '0');
			reg_bch_data(to_integer(unsigned(index_bch_out(to_integer(unsigned(bottom_bch_in)))))) <= inst1;
			reg_bch_en(to_integer(unsigned(index_bch_out(to_integer(unsigned(bottom_bch_in)))))) <= "1";
		else
			bottom_bch_add <= (0 => inst1(0), others => '0');
		end if;
		
		reg_bch_data <= (others => (others => '0')); 
		reg_bch_en <= (others => (others => '0')); 
		
		
		-- FOR INITIALIZING THE INDEX OF THE 'FREE QUEUE' : Using Dispatching Data
		if (reset = '1') then
			for I in 0 to N_bch-1 loop
				index_bch_in(I) <= std_logic_vector(to_unsigned(I,natural(log2(real(N_bch)))));
				index_bch_en(I)(0) <= '1';
				valid_bch_in(I)(0) <= '1';
				valid_bch_en(I)(0) <= '1';
			end loop;
			top_bch_add <= (others => '0');
		else
			-- General update policy: Using Dispatching data
			if (valid_bch_allocate(0)(0) = '1' and valid_bch_allocate(1)(0) = '1') then		-- Indicates 2 instructions are dispatched
				top_bch_add <= (1 => '1', others => '0');
				index_bch_in(to_integer(unsigned(top_bch_add_one))) <= index_bch_allocate(0);
				index_bch_en(to_integer(unsigned(top_bch_add_one)))(0) <= '1';
				index_bch_in(to_integer(unsigned(top_bch_in))) <= index_bch_allocate(1);
				index_bch_en(to_integer(unsigned(top_bch_in)))(0) <= '1';
				index_bch_in <= (others => (others => '0'));
				index_bch_en <= (others => (others => '0'));
				valid_bch_in(to_integer(unsigned(top_bch_add_one)))(0) <= '1';
				valid_bch_en(to_integer(unsigned(top_bch_add_one)))(0) <= '1';
				valid_bch_in(to_integer(unsigned(top_bch_in)))(0) <= '1';
				valid_bch_en(to_integer(unsigned(top_bch_in)))(0) <= '1';
				valid_bch_in <= (others => (others => '0'));
				valid_bch_en <= (others => (others => '0'));
			else
				top_bch_add <= (0 => valid_bch_allocate(0)(0) and valid_bch_allocate(1)(0), others => '0');
				if (valid_bch_allocate(0)(0) = '1') then
					index_bch_in(to_integer(unsigned(top_bch_add_one))) <= index_bch_allocate(0);
					index_bch_en(to_integer(unsigned(top_bch_add_one)))(0) <= '1';
					index_bch_in <= (others => (others => '0'));
					index_bch_en <= (others => (others => '0'));
					valid_bch_in(to_integer(unsigned(top_bch_add_one)))(0) <= '1';
					valid_bch_en(to_integer(unsigned(top_bch_add_one)))(0) <= '1';
					valid_bch_in <= (others => (others => '0'));
					valid_bch_en <= (others => (others => '0'));
				elsif(valid_bch_allocate(1)(0) = '1') then
					index_bch_in(to_integer(unsigned(top_bch_add_one))) <= index_bch_allocate(1);
					index_bch_en(to_integer(unsigned(top_bch_add_one)))(0) <= '1';
					index_bch_in <= (others => (others => '0'));
					index_bch_en <= (others => (others => '0'));
					valid_bch_in(to_integer(unsigned(top_bch_add_one)))(0) <= '1';
					valid_bch_en(to_integer(unsigned(top_bch_add_one)))(0) <= '1';
					valid_bch_in <= (others => (others => '0'));
					valid_bch_en <= (others => (others => '0'));
				else
					index_bch_in <= (others => (others => '0'));
					index_bch_en <= (others => (others => '0'));
					valid_bch_in <= (others => (others => '0'));
					valid_bch_en <= (others => (others => '0'));
				end if;
			end if;			
		end if;
	end process;
	----------------------------------------------------------------------------------------------------------
	process(valid_lst_out,inst1,index_lst_out,bottom_lst_out_add,inst2,bottom_lst_in,not_stall_bch,reset,valid_lst_allocate,index_lst_allocate,top_lst_add_one,top_lst_in,index_lst_in,index_lst_en,valid_lst_in,valid_lst_en)
		variable count : integer;
	begin
		count := 0;
		for I in 0 to N_lst-1 loop
			if(valid_lst_out(I)(0) = '1') then
				count := count + 1;
			else
				count := count;
			end if;
		end loop;
		if(count = 0) then
			stall_lst <= '1';
			only_one_lst <= '0';
		elsif(count = 1) then
			stall_lst <= '0';
			only_one_lst <= '1';
		else
			stall_lst <= '0';
			only_one_lst <= '0';
		end if;
		
		if(inst1(62) = '1') then		-- VALID INSTRUCTION
			reg_lst_data(to_integer(unsigned(index_lst_out(to_integer(unsigned(bottom_lst_out_add)))))) <= inst1;
			reg_lst_en(to_integer(unsigned(index_lst_out(to_integer(unsigned(bottom_lst_out_add)))))) <= "1";
		end if;
		
		if(inst2(62) = '1') then
			bottom_lst_add <= (0 =>  not inst1(0), 1 => inst1(0), others => '0');
			reg_lst_data(to_integer(unsigned(index_lst_out(to_integer(unsigned(bottom_lst_in)))))) <= inst1;
			reg_lst_en(to_integer(unsigned(index_lst_out(to_integer(unsigned(bottom_lst_in)))))) <= "1";
		else
			bottom_lst_add <= (0 => inst1(0), others => '0');
		end if;
		
		reg_lst_data <= (others => (others => '0')); 
		reg_lst_en <= (others => (others => '0')); 
		
		
		-- FOR INITIALIZING THE INDEX OF THE 'FREE QUEUE' : Using Dispatching Data
		if (reset = '1') then
			for I in 0 to N_lst-1 loop
				index_lst_in(I) <= std_logic_vector(to_unsigned(I,natural(log2(real(N_lst)))));
				index_lst_en(I)(0) <= '1';
				valid_lst_in(I)(0) <= '1';
				valid_lst_en(I)(0) <= '1';
			end loop;
			top_lst_add <= (others => '0');
		else
			-- General update policy: Using Dispatching data
			if (valid_lst_allocate(0)(0) = '1' and valid_lst_allocate(1)(0) = '1') then		-- Indicates 2 instructions are dispatched
				top_lst_add <= (1 => '1', others => '0');
				index_lst_in(to_integer(unsigned(top_lst_add_one))) <= index_lst_allocate(0);
				index_lst_en(to_integer(unsigned(top_lst_add_one)))(0) <= '1';
				index_lst_in(to_integer(unsigned(top_lst_in))) <= index_lst_allocate(1);
				index_lst_en(to_integer(unsigned(top_lst_in)))(0) <= '1';
				index_lst_in <= (others => (others => '0'));
				index_lst_en <= (others => (others => '0'));
				valid_lst_in(to_integer(unsigned(top_lst_add_one)))(0) <= '1';
				valid_lst_en(to_integer(unsigned(top_lst_add_one)))(0) <= '1';
				valid_lst_in(to_integer(unsigned(top_lst_in)))(0) <= '1';
				valid_lst_en(to_integer(unsigned(top_lst_in)))(0) <= '1';
				valid_lst_in <= (others => (others => '0'));
				valid_lst_en <= (others => (others => '0'));
			else
				top_lst_add <= (0 => valid_lst_allocate(0)(0) and valid_lst_allocate(1)(0), others => '0');
				if (valid_lst_allocate(0)(0) = '1') then
					index_lst_in(to_integer(unsigned(top_lst_add_one))) <= index_lst_allocate(0);
					index_lst_en(to_integer(unsigned(top_lst_add_one)))(0) <= '1';
					index_lst_in <= (others => (others => '0'));
					index_lst_en <= (others => (others => '0'));
					valid_lst_in(to_integer(unsigned(top_lst_add_one)))(0) <= '1';
					valid_lst_en(to_integer(unsigned(top_lst_add_one)))(0) <= '1';
					valid_lst_in <= (others => (others => '0'));
					valid_lst_en <= (others => (others => '0'));
				elsif(valid_lst_allocate(1)(0) = '1') then
					index_lst_in(to_integer(unsigned(top_lst_add_one))) <= index_lst_allocate(1);
					index_lst_en(to_integer(unsigned(top_lst_add_one)))(0) <= '1';
					index_lst_in <= (others => (others => '0'));
					index_lst_en <= (others => (others => '0'));
					valid_lst_in(to_integer(unsigned(top_lst_add_one)))(0) <= '1';
					valid_lst_en(to_integer(unsigned(top_lst_add_one)))(0) <= '1';
					valid_lst_in <= (others => (others => '0'));
					valid_lst_en <= (others => (others => '0'));
				else
					index_lst_in <= (others => (others => '0'));
					index_lst_en <= (others => (others => '0'));
					valid_lst_in <= (others => (others => '0'));
					valid_lst_en <= (others => (others => '0'));
				end if;
			end if;			
		end if;
	end process;
	
	
end;