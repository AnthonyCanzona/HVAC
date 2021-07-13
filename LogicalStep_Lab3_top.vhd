-- Anthony Canzona: Group 9 Anthony Canzona, Lucas Thiessen --
library ieee;
use ieee.std_logic_1164.all;


entity LogicalStep_Lab3_top is port (
	clk_in		: in 	std_logic;
	pb		: in	std_logic_vector(3 downto 0);
 	sw   		: in  std_logic_vector(7 downto 0); 	
   	leds		: out std_logic_vector(11 downto 0)		
	
); 
end LogicalStep_Lab3_top;

architecture design of LogicalStep_Lab3_top is

-- Provided Project Components Used
------------------------------------------------------------------- 
	
	component Tester port (
	MC_TESTMODE				: in  std_logic;
	I1EQI2,I1GTI2,I1LTI2			: in	std_logic;
	input1					: in  std_logic_vector(3 downto 0);
	input2					: in  std_logic_vector(3 downto 0);
	TEST_PASS  				: out	std_logic							 
	); 
	end component;
	
	component HVAC 	port (
	clk			: in std_logic; 
	run_n		   	: in std_logic;
	increase, decrease	: in std_logic;
	temp			: out std_logic_vector (3 downto 0)
	);
	end component;

------------------------------------------------------------------
-- Add Other Components here


-- Magnitude Comparator Component 
	component Compx4 port 	(
	in_A, in_B				: in std_logic_vector (3 downto 0);
	out_greater, out_equal, out_less	: out std_logic
	);
	end component;

	
-- 2-1 Mux Component 
	component hex_mux_2_in port (
	mux_sel : in  STD_LOGIC;
	num1  	: in  STD_LOGIC_VECTOR (3 downto 0);
	num0  	: in  STD_LOGIC_VECTOR (3 downto 0);
	mux_out : out STD_LOGIC_VECTOR (3 downto 0)
	);
	end component hex_mux_2_in;
 
 
 -- Energy Monitor Component 
	 component Energy_Monitor port ( 
	 cm_greater, cm_equals, cm_less  				: in  std_logic; 
	 vacation_mode, MC_test_mode, window_open, door_open 		: in std_logic;	
	 furnace, at_temp, AC, blower, window, door, vacation, increase, decrease, run_n : out std_logic
	);
	 end component Energy_Monitor;
 
 
------------------------------------------------------------------	
-- Create any signals to be used

signal desired_temp, vacation_temp, mux_temp, current_temp : std_logic_vector (3 downto 0); 

signal vacation_mode, window_open, door_open, MC_test_mode, clk, cm_greater, cm_less, cm_equal : std_logic;

signal increase, decrease, run_n : std_logic;

------------------------------------------------------------------- 
	
-- Here the circuit begins

begin

-- Linking input temperatures to ports
desired_temp 	<= sw(3 downto 0);
vacation_temp 	<= sw(7 downto 4);

-- Linking mode inputs to ports
vacation_mode 	<= pb(3);
MC_test_mode 	<= pb(2);
window_open 	<= pb(1);
door_open 		<= pb(0);

-- Linking clock
clk <= clk_in;


-- Temp Setting Mux instance
desired_mux: hex_mux_2_in port map (
					vacation_mode,
					vacation_temp, desired_temp,
					mux_temp
				);
-- Magnitude Comparator instance			
comp_mag: Compx4 port map (
				mux_temp, current_temp,
				cm_greater, cm_equal, cm_less
			);		
									
-- Energy Monitor instance										
Energy_Monitor_system: Energy_Monitor port map (
						cm_greater, cm_equal, cm_less,
						vacation_mode, MC_test_mode, window_open, door_open,
						leds(0), leds(1), leds(2), leds(3), leds(4), leds(5), leds(7), increase, decrease, run_n
						);		
																
-- HVAC instance								
HVAC_system: HVAC port map (
				clk, run_n,
				increase, decrease,	
				current_temp		
			);									
									
-- Tester instance									
MC_test_system: Tester port map (
				MC_test_mode, cm_equal, cm_greater, cm_less,
				desired_temp, current_temp,
				leds(6)
				);
																
-- Linking current temperature	to output leds															
leds(11 downto 8) <= current_temp;
																
end design;

