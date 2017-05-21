library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
library work;
use work.components.all;


entity allocating_unit is
		generic(N : integer := 4;				-- Number of registers in the reservation station = Number of entries in the Free Queue
				  X : integer := 62);			-- Size of each register
		port(reset : in std_logic;
			  clk : in std_logic;
			  stall_out : out std_logic;
			  only_one : out std_logic;
			  -- FROM DECODE
			  inst1 : in std_logic_vector(62 downto 0);
			  inst2 : in std_logic_vector(62 downto 0);
			  
			  -- FROM RESERVATION STATION
			  reg_data : out main_array(0 to N-1)(X-1 downto 0);
			  reg_en   : out main_array(0 to N-1)(0 downto 0);
			  
			  -- FROM DISPATCHING UNIT
			  index_allocate : in main_array(0 to 1)(natural(log2(real(N)))-1 downto 0);
					-- Indicates the indices of the freed entries in the RS
			  valid_allocate : in main_array(0 to 1)(0 downto 0)
					--Indicates the validity of the above data
			  );
	end entity;

architecture AU of allocating_unit is
	
	signal index_in,index_out : main_array(0 to N-1)(natural(log2(real(N)))-1 downto 0);
	signal index_en,valid_in,valid_out,valid_en : main_array(0 to N-1)(0 downto 0);
	signal top_in,top_out,top_add,top_add_one : std_logic_vector(natural(log2(real(N)))-1 downto 0);
	signal bottom_in,bottom_out,bottom_out_add,bottom_add : std_logic_vector(natural(log2(real(N)))-1 downto 0);
	signal stall,not_stall : std_logic;
	
begin	
	
	stall_out <= stall;
	not_stall <= not stall;
	
	GEN_REG : for I in 0 to N-1
				 generate
				 BUFF_INDEX : registers generic map(N => natural(log2(real(N))))
												port map (reset => '0',
															 clk	 => clk,
															 input => index_in(I),
															 output=> index_out(I),
															 enable=> index_en(I)(0));
				 BUFF_VALID : registers generic map(N => 1)
												port map (reset => '0',
															 clk	 => clk,
															 input => valid_in(I),
															 output=> valid_out(I),
															 enable=> valid_en(I)(0));
				 end generate;
	
	top_pointer 	: registers generic map(N => natural(log2(real(N))))
										port map(reset => reset,
													clk   => clk,
													input => top_in,
													output=> top_out,
													enable=> '1');
												
	bottom_pointer : registers generic map(N => natural(log2(real(N))))
										port map(reset => reset,
													clk   => clk,
													input => bottom_in,
													output=> bottom_out,
													enable=> '1');
													
	adder0 : adds generic map(N => natural(log2(real(N)))) port map(data1 => bottom_out,
																						 data2 => (0 => '1',others => '0'),
																						 output => bottom_out_add);
	
	adder1 : adds generic map(N => natural(log2(real(N)))) port map(data1 => bottom_out,
																						 data2 => bottom_add,
																						 output => bottom_in);
	
	adder2 : adds generic map(N => natural(log2(real(N)))) port map(data1 => top_out,
																						 data2 => top_add,
																						 output => top_in);
																						 
	adder3 : adds generic map(N => natural(log2(real(N)))) port map(data1 => bottom_out,
																						 data2 => (0 => '1',others => '0'),
																						 output => top_add_one);																					 
	
	process(valid_out,inst1,index_out,bottom_out_add,inst2,bottom_in,not_stall,reset,valid_allocate,index_allocate,top_add_one,top_in,index_in,index_en,valid_in,valid_en)
		variable count : integer;
	begin
		count := 0;
		for I in 0 to N-1 loop
			if(valid_out(I)(0) = '1') then
				count := count + 1;
			else
				count := count;
			end if;
		end loop;
		if(count = 0) then
			stall <= '1';
			only_one <= '0';
		elsif(count = 1) then
			stall <= '0';
			only_one <= '1';
		else
			stall <= '0';
			only_one <= '0';
		end if;
		
		if(inst1(62) = '1') then		-- VALID INSTRUCTION
			reg_data(to_integer(unsigned(index_out(to_integer(unsigned(bottom_out_add)))))) <= inst1;
			reg_en(to_integer(unsigned(index_out(to_integer(unsigned(bottom_out_add)))))) <= "1";
		end if;
		
		if(inst2(62) = '1') then
			bottom_add <= (0 =>  not inst1(0), 1 => inst1(0), others => '0');
			reg_data(to_integer(unsigned(index_out(to_integer(unsigned(bottom_in)))))) <= inst1;
			reg_en(to_integer(unsigned(index_out(to_integer(unsigned(bottom_in)))))) <= "1";
		else
			bottom_add <= (0 => inst1(0), others => '0');
		end if;
		
		reg_data <= (others => (others => '0')); 
		reg_en <= (others => (others => '0')); 
		
		
		-- FOR INITIALIZING THE INDEX OF THE 'FREE QUEUE' : Using Dispatching Data
		if (reset = '1') then
			for I in 0 to N-1 loop
				index_in(I) <= std_logic_vector(to_unsigned(I,natural(log2(real(N)))));
				index_en(I)(0) <= '1';
				valid_in(I)(0) <= '1';
				valid_en(I)(0) <= '1';
			end loop;
			top_add <= (others => '0');
		else
			-- General update policy: Using Dispatching data
			if (valid_allocate(0)(0) = '1' and valid_allocate(1)(0) = '1') then		-- Indicates 2 instructions are dispatched
				top_add <= (1 => '1', others => '0');
				index_in(to_integer(unsigned(top_add_one))) <= index_allocate(0);
				index_en(to_integer(unsigned(top_add_one)))(0) <= '1';
				index_in(to_integer(unsigned(top_in))) <= index_allocate(1);
				index_en(to_integer(unsigned(top_in)))(0) <= '1';
				index_in <= (others => (others => '0'));
				index_en <= (others => (others => '0'));
				valid_in(to_integer(unsigned(top_add_one)))(0) <= '1';
				valid_en(to_integer(unsigned(top_add_one)))(0) <= '1';
				valid_in(to_integer(unsigned(top_in)))(0) <= '1';
				valid_en(to_integer(unsigned(top_in)))(0) <= '1';
				valid_in <= (others => (others => '0'));
				valid_en <= (others => (others => '0'));
			else
				top_add <= (0 => valid_allocate(0)(0) and valid_allocate(1)(0), others => '0');
				if (valid_allocate(0)(0) = '1') then
					index_in(to_integer(unsigned(top_add_one))) <= index_allocate(0);
					index_en(to_integer(unsigned(top_add_one)))(0) <= '1';
					index_in <= (others => (others => '0'));
					index_en <= (others => (others => '0'));
					valid_in(to_integer(unsigned(top_add_one)))(0) <= '1';
					valid_en(to_integer(unsigned(top_add_one)))(0) <= '1';
					valid_in <= (others => (others => '0'));
					valid_en <= (others => (others => '0'));
				elsif(valid_allocate(1)(0) = '1') then
					index_in(to_integer(unsigned(top_add_one))) <= index_allocate(1);
					index_en(to_integer(unsigned(top_add_one)))(0) <= '1';
					index_in <= (others => (others => '0'));
					index_en <= (others => (others => '0'));
					valid_in(to_integer(unsigned(top_add_one)))(0) <= '1';
					valid_en(to_integer(unsigned(top_add_one)))(0) <= '1';
					valid_in <= (others => (others => '0'));
					valid_en <= (others => (others => '0'));
				else
					index_in <= (others => (others => '0'));
					index_en <= (others => (others => '0'));
					valid_in <= (others => (others => '0'));
					valid_en <= (others => (others => '0'));
				end if;
			end if;			
		end if;
	end process;
	
end;