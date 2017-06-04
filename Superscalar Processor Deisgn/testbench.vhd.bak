library std;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;

entity testbench is

end entity;

architecture Behave of testbench is
	
	component microprocessor is
		port	(	clock_c	:in STD_LOGIC;
			 		reset	:in STD_LOGIC
			);
	end component;

  signal reset : std_logic := '0';
  signal clk : std_logic := '0';

  function to_string(x: string) return string is
      variable ret_val: string(1 to x'length);
      alias lx : string (1 to x'length) is x;
  begin  
      ret_val := lx;
      return(ret_val);
  end to_string;

  function to_std_logic (x: bit) return std_logic is
  begin
	if(x = '1') then return ('1');
	else return('0'); end if;
  end to_std_logic;

begin

  process
    variable err_flag : boolean := false;
    File INFILE: text open read_mode is "TRACEFILE.txt";
    FILE OUTFILE: text  open write_mode is "OUTPUTS.txt";
    
	--- input variables ------
	variable Nreset : bit ;
	variable Nclk : bit ;

	--- output variables -----


    variable INPUT_LINE: Line;
    variable OUTPUT_LINE: Line;
    variable LINE_COUNT: integer := 0;
    
  begin 
    while not endfile(INFILE) loop 
          -- clock = '0', inputs should be changed here.
          	LINE_COUNT := LINE_COUNT + 1;
	  		readLine (INFILE, INPUT_LINE);

			-- reading input from tracefile
	   	 	read (INPUT_LINE, Nreset);
          	read (INPUT_LINE, Nclk);
		
			-- reading output from tracefile
		
          	reset <= to_std_logic(Nreset);
          	clk <= to_std_logic(Nclk);

	  wait for 5 ns;

	  -- check Mealy machine output and 
          -- compare with expected.
 
        end loop;
    
	assert (err_flag) report "SUCCESS, all tests passed." severity note;
    assert (not err_flag) report "FAILURE, some tests failed." severity error;
	
	wait;
  end process;
 
dut: microprocessor 
 	 port map(
		  reset => reset,
		  clock_c => clk);

end Behave;