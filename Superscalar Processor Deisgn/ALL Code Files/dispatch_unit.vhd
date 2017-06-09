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
	signal top_in,top_out,top_add : std_logic_vector(natural(log2(real(N)))-1 downto 0) := (others => '0');
	signal bottom_add : main_array(0 to 7)(natural(log2(real(N)))-1 downto 0) := (others => (others => '0'));
	signal bottom_in,bottom_out,top_out_add : std_logic_vector(natural(log2(real(N)))-1 downto 0)  := (others => '0');
	
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
	
	-- Ready instruction index enters from bottom and moves out from top
	
	top_pointer 	: registers generic map(N => natural(log2(real(N))))
										port map(reset => reset,
													clk   => clk,
													input => top_in,
													output=> top_out,
													enable=> '1');
												
	bottom_pointer : registers1 generic map(N => natural(log2(real(N))))
										port map(reset => reset,
													clk   => clk,
													input => bottom_in,
													output=> bottom_out,
													enable=> '1');

	---------------------------------------------------------------------------------------------
	
	adder0 : adds generic map(N => natural(log2(real(N)))) port map(data1 => top_out,
																						 data2 => (0 => '1',others => '0'),
																						 output => top_out_add);
	
	adder1 : adds generic map(N => natural(log2(real(N)))) port map(data1 => top_out,
																						 data2 => top_add,
																						 output => top_in);
	
	--_____________ LOGIC FOR 'TO EXECUTE' _______________--
	
	-- TAKING THE INSTRUCTIONS FROM THE LOCATION OF THE TOP POINTER
	-- Includes complete management of the top pointer
	
	process(top_out,bottom_out,valid_oup,reg_data,index_oup,top_out_add)
		variable count : std_logic := '0';
		variable Nexecute1,Nexecute2 : std_logic_vector(X-1 downto 0);		
		variable Nindex_allocate : main_array(0 to 1)(natural(log2(real(N)))-1 downto 0);
		variable Nvalid_allocate : main_array(0 to 1)(0 downto 0);
		variable Ntop_add : std_logic_vector(natural(log2(real(N)))-1 downto 0);
	begin
		Nexecute1 := (others => '0');
		Nexecute2 := (others => '0');
		Nindex_allocate := (others => (others => '0'));
		Nvalid_allocate := (others => (others => '0'));
		Ntop_add := (others => '0');
		count := '0';
		if(not((top_out = bottom_out))) then
			-- Either top 2 are available or only the first is available
			if(valid_oup(to_integer(unsigned(top_out_add)))(0) = '1') then
				Nexecute2 := reg_data(to_integer(unsigned(index_oup(to_integer(unsigned(top_out_add))))));
				Nindex_allocate(1) := top_out_add;
				Nvalid_allocate(1) := "1";
				count := '1';
			end if;
			if(valid_oup(to_integer(unsigned(top_out)))(0) = '1') then
				Nexecute1 := reg_data(to_integer(unsigned(index_oup(to_integer(unsigned(top_out))))));
				Nindex_allocate(0) := bottom_out;
				Nvalid_allocate(0) := "1";
				Ntop_add := (0 => not count,1 => count, others => '0');
			end if;
		else
			Nexecute1 := (others => '0');
			Nexecute2 := (others => '0');
			Nindex_allocate := (others => (others => '0'));
			Nvalid_allocate := (others => (others => '0'));
			Ntop_add := (others => '0');
		end if;
		execute1 <= Nexecute1;
		execute2 <= Nexecute2;
		index_allocate <= Nindex_allocate;
		valid_allocate <= Nvalid_allocate;
		top_add <= Ntop_add;
	end process;
	
	--------------------------------------------------------
	
	--_____________________ ENTER DATA INTO THE BUFFER _________________________--
	
	adder2 : adds generic map(N => natural(log2(real(N)))) port map(data1 => bottom_out,
																						 data2 => (0 => '1',others => '0'),
																						 output => bottom_add(0));
	
	adder3 : adds generic map(N => natural(log2(real(N)))) port map(data1 => bottom_add(0),
																						 data2 => (0 => '1',others => '0'),
																						 output => bottom_add(1));
	
	adder4 : adds generic map(N => natural(log2(real(N)))) port map(data1 => bottom_add(1),
																						 data2 => (0 => '1',others => '0'),
																						 output => bottom_add(2));
	
	adder5 : adds generic map(N => natural(log2(real(N)))) port map(data1 => bottom_add(2),
																						 data2 => (0 => '1',others => '0'),
																						 output => bottom_add(3));
	
	adder6 : adds generic map(N => natural(log2(real(N)))) port map(data1 => bottom_add(3),
																						 data2 => (0 => '1',others => '0'),
																						 output => bottom_add(4));
	
	adder7 : adds generic map(N => natural(log2(real(N)))) port map(data1 => bottom_add(4),
																						 data2 => (0 => '1',others => '0'),
																						 output => bottom_add(5));
	
	adder8 : adds generic map(N => natural(log2(real(N)))) port map(data1 => bottom_add(5),
																						 data2 => (0 => '1',others => '0'),
																						 output => bottom_add(6));
	
	adder9 : adds generic map(N => natural(log2(real(N)))) port map(data1 => bottom_add(6),
																						 data2 => (0 => '1',others => '0'),
																						 output => bottom_add(7));
	
	
	
	--....... For adding new entries into the Queue ..........--
	process(index_out,index_val,bottom_add,bottom_out,inst_ready,indx_alloc)
		variable count : integer;
		variable Nindex_en,Nvalid_en,Nvalid_inp : main_array(0 to N-1)(0 downto 0);
		variable Nindex_inp : main_array(0 to N-1)(natural(log2(real(N)))-1 downto 0);
	begin
		count := 0;
		for I in 0 to N-1 loop
			Nindex_inp(I) := (others => '0');
			Nindex_en(I)  := "0";
			Nvalid_inp(I) := "0";
			Nvalid_en(I)  := "0";
		end loop;
		for I in 0 to 4 loop
			if(index_val(I)(0) = '1') then
				Nindex_inp(to_integer(unsigned(bottom_add(count)))) := index_out(I);
				Nindex_en(to_integer(unsigned(bottom_add(count))))(0) := '1';
				Nvalid_inp(to_integer(unsigned(bottom_add(count))))(0) := '1';
				Nvalid_en(to_integer(unsigned(bottom_add(count))))(0) := '1';
				count := count+1;
			else
				count := count;
			end if;
		end loop;
		
		if(inst_ready(0) = "1")then
			Nindex_inp(to_integer(unsigned(bottom_add(count)))) := indx_alloc(0);
			Nindex_en(to_integer(unsigned(bottom_add(count))))(0) := '1';
			Nvalid_inp(to_integer(unsigned(bottom_add(count))))(0) := '1';
			Nvalid_en(to_integer(unsigned(bottom_add(count))))(0) := '1';
			count := count + 1;
		else
			count := count;
		end if;
		
		if(inst_ready(1) = "1")then
			Nindex_inp(to_integer(unsigned(bottom_add(count)))) := indx_alloc(1);
			Nindex_en(to_integer(unsigned(bottom_add(count))))(0) := '1';
			Nvalid_inp(to_integer(unsigned(bottom_add(count))))(0) := '1';
			Nvalid_en(to_integer(unsigned(bottom_add(count))))(0) := '1';
			count := count + 1;
		else
			count := count;
		end if;
		
		index_inp <= Nindex_inp;
		index_en <= Nindex_en;
		valid_inp <= Nvalid_inp;
		valid_en <= Nvalid_en;
		if count = 0 then
			bottom_in <= bottom_out;
		else
			bottom_in <= bottom_add(count-1);
		end if;
	end process;
	
	------------------------------------------------------------------------------
	
end;