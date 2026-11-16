library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity comp is
    port(MQ: in std_logic_vector(3 downto 0);
            MPROG: in std_logic;
            CLK: in std_logic;
            MRUN: in std_logic;
            ZOUT: out std_logic);
end comp;

architecture arch of comp is

signal a_comp, b_comp: std_logic_vector(3 downto 0);
signal gt_comp, eqt_comp, lt_comp: std_logic;

signal mqq: std_logic_vector(3 downto 0);

signal counter: std_logic_vector(3 downto 0);

begin

-- Register
process(clk, MPROG)
begin
    if MPROG = '1'then
        mqq <= "0000";
    else
        if rising_edge(clk) then
            mqq <= MQ;
        end if;
    end if;

end process;

a_comp <= mqq;

-- 4-bit counter
process(clk, MPROG, MRUN)
begin
    if MPROG = '1' then
        counter <= "0000";
    else
        if rising_edge(clk) then
            if MRUN = '1' then
                counter <= std_logic_vector(unsigned(counter) + 1);
            end if;
        end if;
    end if;
end process;

b_comp <= counter;

-- Comparator
gt_comp <= '1' when a_comp > b_comp else '0';
eqt_comp <= '1' when a_comp = b_comp else '0';
lt_comp <= '1' when a_comp < b_comp else '0';

ZOUT <= eqt_comp or lt_comp;

end arch;