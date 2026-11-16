library ieee;
library work;
use ieee.std_logic_1164.all;

entity testbench is
    port(dummy: out std_logic);
end testbench;

architecture arch of testbench is
    component part1
        port (clk, nrst    : in  std_logic;
            col          : in  std_logic_vector(3 downto 0);
            key          : out std_logic;
            keycode, row : out std_logic_vector(3 downto 0));
    end component;

    component part2
        port ( clk, nrst, key          : in  std_logic;
            keycode                 : in  std_logic_vector(3 downto 0);
            good, bad1, bad2, bad3  : out std_logic;
            shift                   : out std_logic );
    end component;

    -- part1

    signal col, row : std_logic_vector(3 downto 0);
    signal pressed : integer; --range 0 to 16;

    signal clk : std_logic := '0';
    signal nrst, key : std_logic := '0';
    signal keycode : std_logic_vector(3 downto 0);
    signal good, bad1, bad2, bad3, shift : std_logic;

    signal ticks : integer;

    type stimuli is array (0 to 10) of integer;

    -- linear stimulator
    procedure linear_stimulator(variable arr: in stimuli; constant delay: in time; constant n: in integer; signal x: out integer) is
    begin
        for index in 0 to n loop
            x <= arr(index);
            wait for delay;
        end loop;
    end linear_stimulator;

begin

    clk <= not clk after 100 ns;
    nrst <= '0' after 0 ns, '1' after 50 ns;
    --key <= '0' after 0 ns, '1' after 200 ns, '0' after 400 ns;
    --keycode <= x"0" after 0 ns, x"E" after 200 ns, x"0" after 400ns;

    stimulator: process
        variable arr: stimuli := (12,16,0,16,1,16,5,16,9,16,14);
    begin
        linear_stimulator(arr, 4100 ns, 10, pressed);
    end process stimulator;
    

    --pressed <= 12 after 0 ns, 
    --            16 after 4100 ns, 
    --            0 after 7000 ns,
    --            16 after 10100 ns,
    --            1 after 17000 ns,
    --            16 after 20100 ns,
    --            5 after 27000 ns,
    --            16 after 30100 ns,
    --            9 after 37000 ns,
    --            16 after 40100 ns,
    --            14 after 47000 ns;

    process(row)
    begin
        col <= "1111";
        if row = "ZZZ0" then
            if pressed = 0 then
                col <= "1110";
            elsif pressed = 1 then
                col <= "1101";
            elsif pressed = 2 then
                col <= "1011";
            elsif pressed = 3 then
                col <= "0111";
            end if;
        elsif row = "ZZ0Z" then
            if pressed = 4 then
                col <= "1110";
            elsif pressed = 5 then
                col <= "1101";
            elsif pressed = 6 then
                col <= "1011";
            elsif pressed = 7 then
                col <= "0111";
            end if;
        elsif row = "Z0ZZ" then
            if pressed = 8 then
                col <= "1110";
            elsif pressed = 9 then
                col <= "1101";
            elsif pressed = 10 then
                col <= "1011";
            elsif pressed = 11 then
                col <= "0111";
            end if;
        elsif row = "0ZZZ" then
            if pressed = 12 then
                col <= "1110";
            elsif pressed = 13 then
                col <= "1101";
            elsif pressed = 14 then
                col <= "1011";
            elsif pressed = 15 then
                col <= "0111";
            end if;
        elsif row = "0000" then
            if pressed = 3 or pressed = 7 or pressed = 11 or pressed = 15 then
                col <= "0111";
            end if;
            if pressed = 2 or pressed = 6 or pressed = 10 or pressed = 14 then
                col <= "1011";
            end if;
            if pressed = 1 or pressed = 5 or pressed = 9 or pressed = 13 then
                col <= "1101";
            end if;
            if pressed = 0 or pressed = 4 or pressed = 8 or pressed = 12 then
                col <= "1110";
            end if;
        end if;
    end process;
 
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
        shift => shift
    );

    dummy <= '0';

end arch;