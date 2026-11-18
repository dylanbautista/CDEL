library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity opt1_counter is
	generic
	(
		MIN_COUNT : natural := 0;
		MAX_COUNT : natural := 762
	);
	port
	(
		clk		  : in  std_logic;
		nrst	  : in  std_logic; 
		lock	  : in  std_logic;
		ce		  : out std_logic  
	);
end entity;

architecture rtl of opt1_counter is
	signal cnt : integer range MIN_COUNT to MAX_COUNT := MIN_COUNT;
begin

	process(clk)
	begin
		if rising_edge(clk) then
			if nrst = '0' then
				cnt <= MIN_COUNT;
				ce  <= '0';

			elsif lock = '1' then
				if cnt = MAX_COUNT then
					cnt <= MIN_COUNT;
					ce  <= '1';
				else
					cnt <= cnt + 1;
					ce  <= '0';
				end if;

			else
				cnt <= MIN_COUNT;
				ce  <= '0';
			end if;
		end if;
	end process;

end rtl;
