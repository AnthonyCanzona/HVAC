-- Anthony Canzona: Group 9 Anthony Canzona, Lucas Thiessen --
library ieee;
use ieee.std_logic_1164.all;


entity Energy_Monitor is port (

 cm_greater, cm_equals, cm_less  							: in  std_logic; 
 vacation_mode, MC_test_mode, window_open, door_open 					: in std_logic;	
 furnace, at_temp, AC, blower, window, door, vacation, increase, decrease, run_n 	: out std_logic
		 
										); 
end Energy_Monitor;

architecture EM_design of Energy_Monitor is

----------------------------------------------------------------
-- Signal Declaration --
----------------------------------------------------------------

signal run_var, blow_var : std_logic ;

----------------------------------------------------------------
-- Energy Monitor Design --
----------------------------------------------------------------

begin

-- Linking direct input to output signals
window 		<= window_open;
door		<= door_open;
vacation	<= vacation_mode;
AC 		<= cm_less;
furnace 	<= cm_greater;


-- Blower properties process
blower_Function: process (cm_equals, window_open, door_open, MC_test_mode) is 

begin
	-- When blower should be on 
	if ( (MC_test_mode = '0') AND (window_open = '0') AND (door_open = '0') AND (cm_equals = '0') ) then
      blow_var <= '1';	  
	else
		blow_var <= '0';	 
	end if;
	 
	 -- Linking blower to output
	 blower <= blow_var;

end process;

-- At temp properties process
at_temp_Function: process (cm_equals, blow_var) is 

begin
	
	-- When at temp should be on 
	if ( (cm_equals = '1') AND (blow_var = '0') ) then
		at_temp <= '1';
	else 
		at_temp <='0';
	end if;
	
end process;


-- Run_n properties process
run_n_Function: process (cm_equals, window_open, door_open, MC_test_mode) is 

begin
	
	-- When at temp should be off (run_n is Active - low)
	if (cm_equals = '1') then
		run_var <= '1';
		
	elsif ( (window_open = '1') OR (door_open = '1') ) then 
		run_var <= '1';
		
	elsif ( MC_test_mode = '1' ) then 
		run_var <= '1';
	
	else
	run_var <= '0';
	
	end if;
	
	-- Linking run_n to output
	run_n <= run_var;

end process;

-- Temp Regulation process
change_temp_Function: process (run_var, cm_greater, cm_less) is 

begin

-- When temperature needs to be changed
	if (run_var = '0') then 

		-- When temperature needs to be increased
		if (cm_greater = '1') then 
		increase <= '1';
		
		-- When temperature needs to be decreased
		elsif (cm_less = '1') then 
		decrease <= '1';
		
		else
		increase <= '0';
		decrease <= '0';
		
		end if;
	end if;
	
end process;

end EM_design;
