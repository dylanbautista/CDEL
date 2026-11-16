--4x4 keypad analyser
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity part1 is
  port (
    clk, nrst    : in  std_logic;
    col          : in  std_logic_vector(3 downto 0);
    key          : out std_logic;
    keycode, row : out std_logic_vector(3 downto 0));
end part1;

architecture arc_keypad of part1 is
  component count4b
    port ( clk, nrst : in  std_logic;
           output    : out integer range 0 to 15);
  end component;


  type   states is (wait0, check0, check0b, kra0, kra1, kra2, kra3,
                    wait1, check1, check1b);
  signal curr_st, next_st      : states;
  signal comp                  : integer range 0 to 15;
  signal rowq, colq, colqq     : std_logic_vector(3 downto 0);
  signal look, kpressed, look_i : std_logic;
  signal enable                : std_logic;
begin  

--look generation
  counter : count4b port map ( clk => clk, nrst => nrst, output => comp);
  look <= '1' when comp = 15 else '0';

--columns register and kpressed generation
  reg4 : process (clk, nrst)
  begin  -- process reg4
    if nrst = '0' then colq <= "0000";
    elsif clk'event and clk = '0' then colq <= col;
    end if;
  end process reg4;

  kpressed <= not (colq(3) and colq(2) and colq(1) and colq(0));

  enable <= not clk;

  whatkey : process (enable, nrst)
  begin
    if nrst = '0' then curr_st <= wait0;
    elsif enable'event and enable = '1' then curr_st <= next_st; look_i <= look;
    end if;
  end process whatkey;

  next_st <=   check0  when (curr_st = wait0 and look_i = '1')
         else  wait0   when (((curr_st = wait0 or curr_st = kra3 or
                               curr_st = check1b) and kpressed = '0') or
                              (curr_st = wait0 and look = '0'))
         else  check0b when (curr_st = check0)                      
         else  kra0    when (curr_st = check0b and kpressed = '1')  
         else  kra1    when (curr_st = kra0 and kpressed = '0')
         else  kra2    when (curr_st = kra1 and kpressed = '0')
         else  kra3    when (curr_st = kra2 and kpressed = '0')
         else  wait1   when (((curr_st = kra0 or curr_st = kra1 or
                               curr_st = kra2 or curr_st = kra3 or
                               curr_st = check1b) and kpressed = '1') or
                              (curr_st = wait1 and look = '0'))
         else  check1  when (curr_st = wait1 and look = '1')
         else  check1b when (curr_st = check1)                      
         else  wait0;   


  with curr_st select
    rowq <= "1111" when wait0  | wait1,
            "0000" when check0 | check0b | check1 | check1b,
            "1110" when kra0,
            "1101" when kra1,
            "1011" when kra2,
            "0111" when kra3,
            "1111" when others;

  key <= '0' when (curr_st = wait0 or curr_st = wait1 or
                   curr_st = check0 or curr_st = check0b or
                   curr_st = check1 or curr_st = check1b or
                   colq = "1111") else '1';

  keycode <= x"1" when (curr_st = kra0 and colq(0) = '0')
        else x"2" when (curr_st = kra0 and colq(1) = '0')
        else x"3" when (curr_st = kra0 and colq(2) = '0')
        else x"a" when (curr_st = kra0 and colq(3) = '0')
        else x"4" when (curr_st = kra1 and colq(0) = '0')
        else x"5" when (curr_st = kra1 and colq(1) = '0')
        else x"6" when (curr_st = kra1 and colq(2) = '0')
        else x"b" when (curr_st = kra1 and colq(3) = '0')
        else x"7" when (curr_st = kra2 and colq(0) = '0')
        else x"8" when (curr_st = kra2 and colq(1) = '0')
        else x"9" when (curr_st = kra2 and colq(2) = '0')
        else x"c" when (curr_st = kra2 and colq(3) = '0')
        else x"e" when (curr_st = kra3 and colq(0) = '0')
        else x"0" when (curr_st = kra3 and colq(1) = '0')
        else x"f" when (curr_st = kra3 and colq(2) = '0')
        else x"d" when (curr_st = kra3 and colq(3) = '0')
        else x"0";


  tribuf: for i in 0 to 3 generate
    row(i) <= '0' when rowq(i) = '0' else 'Z';
  end generate tribuf;

end arc_keypad;

--key <= '1' when curr_st /= wait0 and curr_st /= check0
--                  and curr_st /= wait1 and curr_st /= check1
--                  and ((colq = "0111" and col = "0111")
--                    or (colq = "1011" and col = "1011")
--                    or (colq = "1101" and col = "1101")
--                    or (colq = "1110" and col = "1110"))
--         else '0';


--key <= '1' when curr_st /= wait0 and curr_st /= check0
--                  and curr_st /= wait1 and curr_st /= check1
--                  and ((colq = "0111" and col = "0111")
--                    or (colq = "1011" and col = "1011")
--                    or (colq = "1101" and col = "1101")
--                   or (colq = "1110" and col = "1110"))
--        else '0  ';