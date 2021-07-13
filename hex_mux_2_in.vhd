-- Anthony Canzona: Group 9 Anthony Canzona, Lucas Thiessen --
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hex_mux_2_in is

    Port ( mux_sel 	: in  STD_LOGIC;
           num1  		: in  STD_LOGIC_VECTOR (3 downto 0);
           num0  		: in  STD_LOGIC_VECTOR (3 downto 0);
           mux_out 	: out STD_LOGIC_VECTOR (3 downto 0)
			 );
			  
end hex_mux_2_in;

architecture mux_2 of hex_mux_2_in is
begin

-- Mux design 
 with mux_sel select 
 mux_out <= num0 when '0', 
				num1 when '1';
	 
end mux_2;