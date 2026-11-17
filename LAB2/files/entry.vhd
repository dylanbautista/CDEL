library ieee;
library work;
use ieee.std_logic_1164.all;

entity entry is
    port(clk, nrst : in std_logic;
        HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7 : out std_logic_vector (6 downto 0);
        LED_GREEN : out std_logic_vector(8 downto 0);
        row : out std_logic_vector(3 downto 0);
        col          : in  std_logic_vector(3 downto 0);
        LED_RED : out std_logic_vector(17 downto 0)
    );
end entry;

architecture arch of entry is

    component part1
        port (clk, nrst    : in  std_logic;
            col          : in  std_logic_vector(3 downto 0);
            key          : out std_logic;
            keycode, row : out std_logic_vector(3 downto 0));
    end component;

    component part2
        port ( clk, nrst, key          : in  std_logic;
            keycode                 : in  std_logic_vector(3 downto 0);
            good, bad1, bad2, bad3, lock, rev  : out std_logic;
            num_reveal				: out std_logic_vector(15 downto 0);
            shift                   : out std_logic );
    end component;

    component hex_disps is
        port ( num0, num1, num2, num3, num4, num5, num6, num7 : in std_logic_vector (3 downto 0);
         HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7 : out std_logic_vector (6 downto 0));
    end component;
    
    component opt1_counter 
		generic
		(
			MIN_COUNT : natural := 0;
			MAX_COUNT : natural := 195999
		);
		port
		(
			clk		  : in  std_logic;
			nrst	  : in  std_logic; 
			lock	  : in  std_logic;
			ce		  : out std_logic  
		);
	end component;


   -- signal col, row : std_logic_vector(3 downto 0);
    signal pressed : integer; --range 0 to 16;

    --signal clk : std_logic := '0';
    signal key : std_logic := '0';
    signal lock : std_logic;
    signal blink : std_logic;
    signal ce : std_logic;
    signal rev : std_logic;
    signal num_reveal 			 : std_logic_vector (15 downto 0);
    signal keycode : std_logic_vector(3 downto 0);
    signal good, bad1, bad2, bad3, shift : std_logic;

    signal num0, num1, num2, num3, num4, num5, num6, num7 : std_logic_vector (3 downto 0) := "0000";
    --signal HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7 : std_logic_vector (6 downto 0);

    signal bad1_led, bad2_led, bad3_led : std_logic_vector(5 downto 0);

    signal hex0q, hex1q, hex2q, hex3q : std_logic_vector(3 downto 0);
begin

    part1_i: part1 port map(
        clk => clk,
        nrst => nrst,
        col => col,
        key => key,
        keycode => keycode,
        row => row
    );

    part2_i: part2 port map(
        clk => clk,
        nrst => nrst,
        key => key,
        keycode => keycode,
        good => good,
        bad1 => bad1,
        bad2 => bad2,
        bad3 => bad3,
        lock => lock,
        rev => rev,
        num_reveal => num_reveal,
        shift => shift
    );
    
    opt1_counter_i: opt1_counter port map(
        clk => clk,
        nrst => nrst,
        lock => lock,
        ce => ce
	);
	
    hex_dsps_i: hex_disps port map(
        num0 => num0, 
        num1 => num1, 
        num2 => num2, 
        num3 => num3, 
        num4 => num4, 
        num5 => num5, 
        num6 => num6, 
        num7 => num7,
        HEX0 => HEX0, 
        HEX1 => HEX1, 
        HEX2 => HEX2, 
        HEX3 => HEX3, 
        HEX4 => HEX4, 
        HEX5 => HEX5, 
        HEX6 => HEX6, 
        HEX7 => HEX7
    );

    num0 <= hex0q;
    num1 <= hex1q;
    num2 <= hex2q;
    num3 <= hex3q;
    num4 <= "0000";
    num5 <= "0000";
    num6 <= "0000";
    num7 <= "0000";

    -- Display D-flip-flops to retain numbers introduced by user
    process(clk, nrst) -- could this process be sensitive to key, rather than clk?
    begin
        if nrst = '0' then
			hex0q <= "0000";
			hex1q <= "0000";
			hex2q <= "0000";
			hex3q <= "0000";
        elsif rising_edge(clk) then
            if key = '1' and rev = '0' then
                hex0q <= keycode;
                hex1q <= hex0q;
                hex2q <= hex1q;
                hex3q <= hex2q;
             
             elsif rev = '1' then
				hex0q <= num_reveal(15 downto 12);
                hex1q <= num_reveal(11 downto 8);
                hex2q <= num_reveal(7 downto 4);
                hex3q <= num_reveal(3 downto 0);
            end if;
        end if;
    end process;
    
	process(clk, nrst)
	begin
		if nrst = '0' then
			blink <= '0';
		elsif rising_edge(clk) then
			if lock = '0' then
				blink <= '0';
			elsif ce = '1' then
				blink <= not blink; 
			end if;
		end if;
	end process;

    -- bad/good LED logic
    LED_GREEN <= "111111111" when good = '1' else "000000000";
    bad1_led <= "111111" when bad1 = '1' else "000000";
    bad2_led <= "111111" when bad2 = '1' else "000000";
    bad3_led <= "111111" when bad3 = '1' else "000000";
    --LED_RED <= bad1_led & bad2_led & bad3_led;
	LED_RED <= bad1_led & bad2_led & bad3_led when lock = '0' else
           "111111111111111111" when blink = '1' else
           "000000000000000000";

end arch;