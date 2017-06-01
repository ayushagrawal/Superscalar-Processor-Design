library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

package components is
	
	type main_array is array(natural range <>) of std_logic_vector;
	
	component adds is
		generic(N : integer := 32);			-- Arbit number
		port(data1 : in std_logic_vector(N-1 downto 0);
			  data2 : in std_logic_vector(N-1 downto 0);
			  output : out std_logic_vector(N-1 downto 0));
			 
	end component;
	
	component allocating_unit is
		generic(N_alu 	: integer := 8;			-- Number of registers in the ALU reservation station = Number of entries in the Free Queue
				  N_bch 	: integer := 4;			-- Number of registers in the BCH reservation station = Number of entries in the Free Queue
				  N_lst 	: integer := 16;			-- Number of registers in the LST reservation station = Number of entries in the Free Queue
				  X_alu	: integer := 43;
				  X_bch	: integer := 59;
				  X_lst	: integer := 43);			-- Size of each register
		port(reset : in std_logic;
			  clk : in std_logic;
			  stall_out : out std_logic;
			  only_one_alu : out std_logic;
			  only_one_bch : out std_logic;
			  only_one_lst : out std_logic;
			  
			  -- FROM DECODE [validity:tag:______]
			  inst1 : in std_logic_vector(62 downto 0);
			  inst2 : in std_logic_vector(62 downto 0);
			  
			  -- TO RESERVATION STATION (NEED TO CONSIDER FROM ALL THE RESERVATION STATION)
			  reg_alu_data : out main_array(0 to N_alu-1)(X_alu-1 downto 0);
			  reg_alu_en   : out main_array(0 to N_alu-1)(0 downto 0);
			  busy_alu		: out main_array(0 to N_alu-1)(0 downto 0);
			  busy_alu_en	: out main_array(0 to N_alu-1)(0 downto 0);
			  reg_bch_data : out main_array(0 to N_bch-1)(X_bch-1 downto 0);
			  reg_bch_en   : out main_array(0 to N_bch-1)(0 downto 0);
			  busy_bch		: out main_array(0 to N_bch-1)(0 downto 0);
			  busy_bch_en	: out main_array(0 to N_bch-1)(0 downto 0);
			  reg_lst_data : out main_array(0 to N_lst-1)(X_lst-1 downto 0);
			  reg_lst_en   : out main_array(0 to N_lst-1)(0 downto 0);
			  busy_lst		: out main_array(0 to N_lst-1)(0 downto 0);
			  busy_lst_en	: out main_array(0 to N_lst-1)(0 downto 0);
			  
			  
			  
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
			  valid_lst_allocate : in main_array(0 to 1)(0 downto 0);
					--Indicates the validity of the above data
			  
			  -- TO DISPATCH UNIT
			  inst_ready_alu : out main_array(0 to 1)(0 downto 0);
			  inst_ready_bch : out main_array(0 to 1)(0 downto 0);
			  inst_ready_lst : out main_array(0 to 1)(0 downto 0);
			  indx_alloc_alu : out main_array(0 to 1)(natural(log2(real(N_alu)))-1 downto 0);
			  indx_alloc_bch : out main_array(0 to 1)(natural(log2(real(N_bch)))-1 downto 0);
			  indx_alloc_lst : out main_array(0 to 1)(natural(log2(real(N_lst)))-1 downto 0)
			  );
	end component;
	
	component alu_unit is
		port(clk : in std_logic;
			  reset : in std_logic;
			  input : in std_logic_vector(43 downto 0);
			  output : out std_logic_vector(21 downto 0));
	end component;
	
	component bch_unit is
		port(clk : in std_logic;
			  reset : in std_logic;
			  input : in std_logic_vector(58 downto 0);
			  output : out std_logic_vector(21 downto 0));
	end component;
	
	component lst_unit is
		port(clk : in std_logic;
			  reset : in std_logic;
			  input : in std_logic_vector(42 downto 0);
			  output : out std_logic_vector(21 downto 0));
	end component;
	
	component ARF is
		port(reset : in std_logic;
			  clk   : in std_logic;
			  
			  in_sel1 : in std_logic_vector(2 downto 0);
			  in_sel2 : in std_logic_vector(2 downto 0);
			  in_sel3 : in std_logic_vector(2 downto 0);
			  in_sel4 : in std_logic_vector(2 downto 0);
			  
			  --
			  input1 : in std_logic_vector(15 downto 0);
			  input2 : in std_logic_vector(15 downto 0);
			  input3 : in std_logic_vector(15 downto 0);
			  input4 : in std_logic_vector(15 downto 0);
			  wren1 : in std_logic;
			  wren2 : in std_logic;
			  wren3 : in std_logic;
			  wren4 : in std_logic;
			  
			  validity_in : in main_array(0 to 7)(0 downto 0);
			  
			  val_en_ch : in main_array(0 to 7)(0 downto 0);	-- DEFAULT is '1' ;change to 0 indicate action to be performed
			  
			  -- TO THE REGISTER FILE
			  -- MSB is the validity of the data
			  output1 : out std_logic_vector(16 downto 0);
			  output2 : out std_logic_vector(16 downto 0);
			  output3 : out std_logic_vector(16 downto 0);
			  output4 : out std_logic_vector(16 downto 0);
			  
			  -- FROM REGISTER FILE
			  osel1	 : in std_logic_vector(2 downto 0);
			  osel2	 : in std_logic_vector(2 downto 0);
			  osel3	 : in std_logic_vector(2 downto 0);
			  osel4	 : in std_logic_vector(2 downto 0));
		
	end component;
	
	component branch_predictor is
		port(pc		: in std_logic_vector(6 downto 0);
			  clk		: in std_logic;
			  bp_out : out std_logic_vector(6 downto 0);
			  sel 	: out std_logic);
	end component;
	
	component comparator is
		generic(tag_size : integer := 5;
				  tag_num : integer := 16;
				  N       : integer := 62);		-- DATA LENGTH
		port (to_match : in main_array(0 to 4)(21 downto 0);					-- CONTAINS THE BROADCAST
				data_in : in main_array(0 to tag_num-1)(N-1 downto 0);		-- THE REGISTER'S DATA
				data_out : out main_array(0 to tag_num-1)(N-1 downto 0);		-- THE REGISTER'S DATA
				busy		: in main_array(0 to tag_num-1)(0 downto 0);
				index		: out main_array(0 to 4)(natural(log2(real(tag_num)))-1 downto 0);
				valid		: out main_array(0 to 4)(0 downto 0));		
	end component;
	
	component decode is
		port(clk	: in std_logic;
			  reset : in std_logic;
			  stall_in : in std_logic;
			  inst1 : in std_logic_vector(15 downto 0);
			  inst2 : in std_logic_vector(15 downto 0);
			  PC1			: in std_logic_vector(6 downto 0);
			  PC2			: in std_logic_vector(6 downto 0);
			  
			  ------- CALCULATED uOPS RESGITERS ------
			  REG1	: out std_logic_vector(35 downto 0);
			  REG2	: out std_logic_vector(35 downto 0));
	end component;
	
	component demux is
	
		generic(X : integer;			-- NUMBER OF PORTS IN THE DEMUX
				  Y : integer);		-- DATA WIDTH OF THE DEMUX
		port(input : in std_logic_vector(Y-1 downto 0);
			  output  : out main_array(0 to X-1)(Y-1 downto 0);
			  sel		: in std_logic_vector(natural(log2(real(X)))-1 downto 0));
			  
	end component;
	
	component dispatch_unit is
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
	end component;

	
	component dispatch_unit_bch is
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
			  execute1 : out std_logic_vector(X-1 downto 0)
			  );
	end component;
	
	component fetch is
		port(clk 		: in std_logic;
			  reset		: in std_logic;
			  stall		: in std_logic;
			  inst1		: out std_logic_vector(22 downto 0);
			  inst2		: out std_logic_vector(22 downto 0));
	end component;
	
	component fetch_decode is
		port(clk 		: in std_logic;
			  reset		: in std_logic;
			  stall		: in std_logic;
			  
				------- CALCULATED uOPS RESGITERS ------
			  REG1	: out std_logic_vector(35 downto 0);
			  REG2	: out std_logic_vector(35 downto 0));
	end component;
	
	component inc IS
		PORT
		(
			data0x		: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
			data1x		: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
			result		: OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
		);
	END component;
	
	component instruction_memory IS
		PORT
		(
			address_a		: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
			address_b		: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
			clock		: IN STD_LOGIC  := '1';
			data_a		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			data_b		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			wren_a		: IN STD_LOGIC  := '0';
			wren_b		: IN STD_LOGIC  := '0';
			q_a		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
			q_b		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		);
	END component;
	
	
	component multiplexer is
	
		generic(X : integer;
				  Y : integer);
		port(output : out std_logic_vector(Y-1 downto 0);
			  input  : in main_array(0 to X-1)(Y-1 downto 0);
			  sel		: in std_logic_vector(natural(log2(real(X)))-1 downto 0));

	end component;
	
	component mux2 is 
		generic (N : integer);
		port( in0,in1 : in std_logic_vector(N-1 downto 0); 
				sel : in std_logic; 
				output : out std_logic_vector(N-1 downto 0));
	end component;
	
	component registers is
		generic(N  : integer);
		port(input : in std_logic_vector(N-1 downto 0);
			  enable: in std_logic;
			  output: out std_logic_vector(N-1 downto 0);
			  clk   : in std_logic;
			  reset : in std_logic);
	end component;
	
	component register_file is
		port(reset : in std_logic;
			  clk   : in std_logic;
			  stall_out : out std_logic;
			  
			  -- From Decode
			  REG1 : in std_logic_vector(35 downto 0);
			  REG2 : in std_logic_vector(35 downto 0);
			  
			  -- To Reservation Station
			  register1 : out std_logic_vector(71 downto 0);
			  register2 : out std_logic_vector(71 downto 0);
			  
			  -- From Write Back for ARF
			  in_sel1				: in std_logic_vector(2 downto 0);
			  in_sel2				: in std_logic_vector(2 downto 0);
			  
			  input1					: in std_logic_vector(15 downto 0);
			  input2					: in std_logic_vector(15 downto 0);
			  
			  wren1					: in std_logic;
			  wren2					: in std_logic;
			  
			  -- From Execute Complete for ROB
			  broadcast				: in main_array(0 to 4)(21 downto 0);	-- Max of 5 units can return
																							-- Data 		= 16 bits
																							-- Tag  		= 5  bits (RRF size)
																							-- Validity = 1 bit
																							-- (In the above order) --
			  -- TO COMPLETE FROM ROB
			  complete1				: out std_logic_vector(37 downto 0);
			  complete2				: out std_logic_vector(37 downto 0));
		
	end component;
	
	
	component reservation_station is
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
	end component;
	
	component ROB is
		generic(N : integer := 32);			-- Represents total number of entries
		port(reset 	: in std_logic;
				clk	: in std_logic;
				stall_out : out std_logic;
				broadcast	: in main_array(0 to 4)(21 downto 0);	-- Max of 5 units can return
				-- Data 		= 16 bits
				-- Tag  		= 5  bits (RRF size)
				-- Validity = 1 bit
				-- (In the above order) --
			 
				-- FROM DECODE
				 instruction1 : in std_logic_vector(22 downto 0);
				 instruction2 : in std_logic_vector(22 downto 0);
				 -- If write back					: 1  bit
				 -- Instruction type 			: 2  bits
				 -- Register affected 			: 3  bits
				 -- Data/Memory Address			: 16 bits
				 -- Validity of information 	: 1  bit
				 -- Total							: 23 bits
				 
				 -- TO DECODE
				 inst1_tag : out std_logic_vector(natural(log2(real(N)))-1 downto 0);
				 inst2_tag : out std_logic_vector(natural(log2(real(N)))-1 downto 0);
				 
				 -- TO COMPLETE
				 complete1 : out std_logic_vector(37 downto 0);
				 complete2 : out std_logic_vector(37 downto 0)
				 -- If write back		 : 1  bit
				 -- Inst_type 			 : 2  bits
				 -- Register affected : 3  bits
				 -- Memory affected   : 16 bits
				 -- Data				    : 16 bits
				 -- validity		    : 1  bit
			 );
			 
	end component;

	
	component update_unit is
		generic(N : integer := 62;				-- DATA LENGTH 
				  X : integer := 16);			-- Specifies the number of entries in the reservation station
		port(broadcast	: in main_array(0 to 4)(21 downto 0);	-- Max of 5 units can return
			  -- Data 		= 16 bits
			  -- Tag  		= 5  bits (RRF size)
			  -- Validity  = 1 bit
			  -- (In the above order) --
			  
			  -- FROM the RS
			  busy : in main_array(0 to X-1)(0 downto 0);									-- INDICATES OCCUPANCY OF A RS ENTRY
			  data_in : in main_array(0 to X-1)(N-1 downto 0);
			  
			  -- To RS
			  validity_out : out main_array(0 to X-1)(0 downto 0);
			  validity_en	: out main_array(0 to X-1)(0 downto 0);
			  data			: out main_array(0 to X-1)(N-1 downto 0);
			  data_en		: out main_array(0 to X-1)(0 downto 0);
			  
			  -- To Dispatch unit
			  index_out : out main_array(0 to 4)(natural(log2(real(X)))-1 downto 0);		-- INDICATES READY REGISTERS
			  index_val : out main_array(0 to 4)(0 downto 0)										-- INDICATES READY REGISTERS
			);
	end component;
	
end package;