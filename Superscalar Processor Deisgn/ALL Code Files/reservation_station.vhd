-- DEFINES THE STRUCTURE OF INDIVIDUAL RESERVATION STATIONS

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
			  data_in : in main_array(0 to N-1)(X-1 downto 0);
			  data_en : in main_array(0 to N-1)(0 downto 0);
			  data_out : out main_array(0 to N-1)(X-1 downto 0);
			  clk   : in std_logic;
			  reset : in std_logic);
	end entity;

architecture RS of reservation_station is
begin
	
	GEN_REG : for I in 0 to N-1
						generate
						
						BUSY : registers generic map(N => 1)
											  port map(	reset => reset,
															clk	=> clk,
															input => busy_in(I),
															enable=> busy_en(I)(0),
															output=> busy_out(I));
						
						READY : registers generic map(N => 1)
											   port map(reset => reset,
															clk	=> clk,
															input => ready_in(I),
															enable=> ready_en(I)(0),
															output=> ready_out(I));
						
						
						REGX : registers generic map(N => X)
											  port map(	reset => reset,
															clk	=> clk,
															input => data_in(I),
															enable=> data_en(I)(0),
															output=> data_out(I));
						end generate;
	
end;