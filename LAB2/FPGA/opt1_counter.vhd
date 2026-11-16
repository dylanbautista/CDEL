-- Quartus II VHDL Template
-- Binary Counter

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity opt1_counter is

	generic
	(
		MIN_COUNT : natural := 0;
		MAX_COUNT : natural := 195999
	);

	port
	(
		clk		  : in std_logic;
		nreset	  : in std_logic;
		lock	  : in std_logic;
		ce		  : out integer range MIN_COUNT to MAX_COUNT
	);

end entity;

architecture rtl of opt1_counter is
begin

	process (clk)
		signal   cnt		   : integer range MIN_COUNT to MAX_COUNT;
	begin
		if (rising_edge(clk)) then

			if nreset = '1' then
				-- Reset the counter to 0
				cnt <= 0;

			elsif lock = '1' then
				-- Increment the counter if counting is enabled			   
				cnt <= cnt + 1;

			end if;
		end if;

		-- Output the current count
		ce <= cnt;
	end process;

end rtl;
