-- IT MAINTAINS A QUEUE OF FREE ENTRIES IN THE RESERVATION STATION
-- IT GET'S THE ABOVE REQUIRED INFORMATION FROM THE UPADTE UNIT
-- THE QUEUE HAS ALSO TO BE UPDATED BY THE ALLOCATING UNIT INCASE THE INCOMING INSTRUCTION IS ALREADY READY

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
library work;
use work.components.all;


entity dispatch_unit is
		generic(N : integer := 4;				-- Number of registers in the reservation station
				  X : integer := 62);			-- Size of each register
		port(clk : in std_logic;
			  reset : in std_logic;
			  
			  -- FROM THE ALLOCATING UNIT
			  inst_ready : in main_array(0 to 1)(0 downto 0);		-- INDICATES WHETHER THE INCOMING INSTRUCTION WAS READY OR NOT
			  indx_alloc : in main_array(0 to 1)(natural(log2(real(N)))-1 downto 0);
			  
			  -- FROM THE RESERVATION SYSTEM
			  reg_data : in main_array(0 to N-1)(X-1 downto 0);
			  
			  -- FROM THE UPDATE UNIT
			  index_out : in main_array(0 to 4)(natural(log2(real(N)))-1 downto 0);
			  index_val : in main_array(0 to 4)(0 downto 0);
			  
			  -- TO ALLOCATE
			  index_allocate : out main_array(0 to 1)(natural(log2(real(N)))-1 downto 0);
			  valid_allocate : out main_array(0 to 1)(0 downto 0);
			  
			  -- TO EXECUTE
			  execute1 : out std_logic_vector(X-1 downto 0);		
			  execute2 : out std_logic_vector(X-1 downto 0)
			  );
	end entity;

architecture DU of dispatch_unit is
	
	signal index_inp,index_oup : main_array(0 to N-1)(natural(log2(real(N)))-1 downto 0) := (others =>(others => '0'));
	signal index_en,valid_inp,valid_oup,valid_en : main_array(0 to N-1)(0 downto 0) := (others => (others => '0'));
	signal top_in,top_out : std_logic_vector(natural(log2(real(N)))-1 downto 0) := (others => '0');
	signal top_add : main_array(0 to 7)(natural(log2(real(N)))-1 downto 0) := (others => (others => '0'));
	signal bottom_in,bottom_out,bottom_out_add,bottom_add : std_logic_vector(natural(log2(real(N)))-1 downto 0)  := (others => '0');
	
begin	
	
	GEN_REG : for I in 0 to N-1
				 generate
				 BUFF_INDEX : registers generic map(N => natural(log2(real(N))))
												port map (reset => reset,
															 clk	 => clk,
															 input => index_inp(I),
															 output=> index_oup(I),
															 enable=> index_en(I)(0));
				 BUFF_VALID : registers generic map(N => 1)
												port map (reset => reset,
															 clk	 => clk,
															 input => valid_inp(I),
															 output=> valid_oup(I),
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

	---------------------------------------------------------------------------------------------
	
	adder0 : adds generic map(N => natural(log2(real(N)))) port map(data1 => bottom_out,
																						 data2 => (0 => '1',others => '0'),
																						 output => bottom_out_add);
	
	adder1 : adds generic map(N => natural(log2(real(N)))) port map(data1 => bottom_out,
																						 data2 => bottom_add,
																						 output => bottom_in);
	
	--_____________ LOGIC FOR 'TO EXECUTE' _______________--
	
	process(top_out,bottom_out,valid_oup,reg_data,index_oup,bottom_out_add)
	
	begin
		if(not((top_out = bottom_out) and valid_oup(to_integer(unsigned(bottom_out)))(0) = '0')) then
			execute1 <= reg_data(to_integer(unsigned(index_oup(to_integer(unsigned(bottom_out))))));
			index_allocate(0) <= bottom_out;
			valid_allocate(0) <= "1";
			
			execute2 <= reg_data(to_integer(unsigned(index_oup(to_integer(unsigned(bottom_out_add))))));
			index_allocate(1) <= bottom_out_add;
			valid_allocate(1) <= "1";
		else
			execute1 <= (others => '0');
			execute2 <= (others => '0');
			index_allocate <= (others => (others => '0'));
			valid_allocate <= (others => (others => '0'));
		end if;
		if(valid_oup(to_integer(unsigned(bottom_out_add)))(0) = '1') then
			bottom_add <= (1 =>'1', others => '0');
		elsif(valid_oup(to_integer(unsigned(bottom_out)))(0) = '1') then
			bottom_add <= bottom_out_add;
		else
			bottom_add <= (others => '0');
		end if;
	end process;
	
	--------------------------------------------------------
	
	--_____________________ ENTER DATA INTO THE BUFFER _________________________--
	
	adder2 : adds generic map(N => natural(log2(real(N)))) port map(data1 => top_out,
																						 data2 => (0 => '1',others => '0'),
																						 output => top_add(0));
	
	adder3 : adds generic map(N => natural(log2(real(N)))) port map(data1 => top_add(0),
																						 data2 => (0 => '1',others => '0'),
																						 output => top_add(1));
	
	adder4 : adds generic map(N => natural(log2(real(N)))) port map(data1 => top_add(1),
																						 data2 => (0 => '1',others => '0'),
																						 output => top_add(2));
	
	adder5 : adds generic map(N => natural(log2(real(N)))) port map(data1 => top_add(2),
																						 data2 => (0 => '1',others => '0'),
																						 output => top_add(3));
	
	adder6 : adds generic map(N => natural(log2(real(N)))) port map(data1 => top_add(3),
																						 data2 => (0 => '1',others => '0'),
																						 output => top_add(4));
	
	adder7 : adds generic map(N => natural(log2(real(N)))) port map(data1 => top_add(4),
																						 data2 => (0 => '1',others => '0'),
																						 output => top_add(5));
	
	adder8 : adds generic map(N => natural(log2(real(N)))) port map(data1 => top_add(5),
																						 data2 => (0 => '1',others => '0'),
																						 output => top_add(6));
	
	adder9 : adds generic map(N => natural(log2(real(N)))) port map(data1 => top_add(6),
																						 data2 => (0 => '1',others => '0'),
																						 output => top_add(7));
	
	process(index_out,index_val,top_add,top_out,inst_ready,indx_alloc)
		variable count : integer;
	begin
		count := 0;
		for I in 0 to 4 loop
			if(index_val(I)(0) = '1') then
				index_inp(to_integer(unsigned(top_add(count)))) <= index_out(I);
				index_inp <= (others => (others => '0'));
				index_en(to_integer(unsigned(top_add(count))))(0) <= '1';
				index_en <= (others => (others => '0'));
				valid_inp(to_integer(unsigned(top_add(count))))(0) <= '1';
				valid_inp <= (others => (others => '0'));
				valid_en(to_integer(unsigned(top_add(count))))(0) <= '1';
				valid_en <= (others => (others => '0'));
				count := count+1;
			else
				count := count;
			end if;
		end loop;
		
		if(inst_ready(0) = "1")then
			index_inp(to_integer(unsigned(top_add(count)))) <= indx_alloc(0);
			index_inp <= (others => (others => '0'));
			index_en(to_integer(unsigned(top_add(count))))(0) <= '1';
			index_en <= (others => (others => '0'));
			valid_inp(to_integer(unsigned(top_add(count))))(0) <= '1';
			valid_inp <= (others => (others => '0'));
			valid_en(to_integer(unsigned(top_add(count))))(0) <= '1';
			valid_en <= (others => (others => '0'));
			count := count + 1;
		else
			count := count;
		end if;
		
		if(inst_ready(1) = "1")then
			index_inp(to_integer(unsigned(top_add(count)))) <= indx_alloc(1);
			index_inp <= (others => (others => '0'));
			index_en(to_integer(unsigned(top_add(count))))(0) <= '1';
			index_en <= (others => (others => '0'));
			valid_inp(to_integer(unsigned(top_add(count))))(0) <= '1';
			valid_inp <= (others => (others => '0'));
			valid_en(to_integer(unsigned(top_add(count))))(0) <= '1';
			valid_en <= (others => (others => '0'));
			count := count + 1;
		else
			count := count;
		end if;
		
		index_inp <= (others => (others => '0'));
		index_en <= (others => (others => '0'));
		valid_inp <= (others => (others => '0'));
		valid_en <= (others => (others => '0'));
		if count = 0 then
			top_in <= top_out;
		else
			top_in <= top_add(count-1);
		end if;
	end process;
	
	------------------------------------------------------------------------------
	
end;