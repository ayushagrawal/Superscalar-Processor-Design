-- DEFINES THE STRUCTURE OF INDIVIDUAL RESERVATION STATIONS

-- CONTAINS A MULTIPLEXER TO FACILITATE THE MODIFICATION BY BOTH ALLOCATING UNIT AND THE UPDATE UNIT

library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity reservation_station is
		generic(N  : integer := 8;			-- Specifies the number of entiries in a reservation station
				  X  : integer := 32);			-- Specifies the data length
		port(busy_in : in main_array(0 to N-1)(0 downto 0);
			  busy_en : in main_array(0 to N-1)(0 downto 0);
			  busy_out : out main_array(0 to N-1)(0 downto 0);
			  ready_in: in main_array(0 to N-1)(0 downto 0);
			  ready_en: in main_array(0 to N-1)(0 downto 0);
			  ready_out: out main_array(0 to N-1)(0 downto 0);
			  
			  -- FROM UPDATE UNIT
			  data_in_updte : in main_array(0 to N-1)(X-1 downto 0);
			  data_en_updte : in main_array(0 to N-1)(0 downto 0);
			  
			  -- FROM ALLOCATION UNIT
			  data_in_alloc : in main_array(0 to N-1)(X-1 downto 0);
			  data_en_alloc : in main_array(0 to N-1)(0 downto 0);
			  
			  data_out : out main_array(0 to N-1)(X-1 downto 0);
			  clk   : in std_logic;
			  reset : in std_logic);
	end entity;

architecture RS of reservation_station is

	signal data_in_mux    : main_array(0 to N-1)(X-1 downto 0) := (others => (others => '0'));
	signal data_en_mux    : main_array(0 to N-1)(0 downto 0) := (others => (others => '0'));
	signal ready_in_final : main_array(0 to N-1)(0 downto 0);
	signal ready_en_final : main_array(0 to N-1)(0 downto 0);

begin
	
	GEN_REG : for I in 0 to N-1
						generate
						
						-- INDICATES WHETHER A PARTICULAR ENTRY IS OCCUPIED OR NOT
						-- TO BE MODIFIED BY THE ALLOCATING UNIT
						BUSY : registers generic map(N => 1)
											  port map(	reset => reset,
															clk	=> clk,
															input => busy_in(I),
															enable=> busy_en(I)(0),
															output=> busy_out(I));
						
						-- INDICATED WHETHER A PARTICULAR ENTRY IS READY FOR DISPATCH OR NOT
						-- TO BE MODIFIED BY THE UPDATE UNIT
						READY : registers generic map(N => 1)
											   port map(reset => reset,
															clk	=> clk,
															input => ready_in_final(I),
															enable=> ready_en_final(I)(0),
															output=> ready_out(I));
						
						
						-- TO BE MODIFIED BY BOTH ALLOCATING UNIT AND UPDATE UNIT. NEED A PROVISION OF MULTIPLEXER. 
						REGX : registers generic map(N => X)
											  port map(	reset => reset,
															clk	=> clk,
															input => data_in_mux(I),
															enable=> data_en_mux(I)(0),
															output=> data_out(I));
						end generate;
	
	process(data_en_updte,data_in_updte,data_in_alloc,data_en_alloc,ready_en,busy_en,data_en_mux,ready_in,data_in_mux)
	begin
		for I in 0 to N-1 loop
			if(data_en_updte(I) = "1") then
				data_in_mux(I) <= data_in_updte(I);
				data_en_mux(I) <= data_en_updte(I);
			else
				data_in_mux(I) <= data_in_alloc(I);
				data_en_mux(I) <= data_en_alloc(I);
			end if;
			ready_en_final(I) <= ready_en(I) or (busy_en(I) and data_en_mux(I));
			ready_in_final(I)(0) <= ready_in(I)(0) or ( data_in_mux(I)(71) and data_in_mux(I)(33) and data_in_mux(I)(16));
		end loop;
	end process;
	
end;