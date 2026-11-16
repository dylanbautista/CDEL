library ieee;
library work;
use ieee.std_logic_1164.all;

entity testbench2 is
    port(dummy: out std_logic);
end testbench2;

architecture arch of testbench2 is
    component comp
        port(MQ: in std_logic_vector(3 downto 0);
                MPROG: in std_logic;
                CLK: in std_logic;
                MRUN: in std_logic;
                ZOUT: out std_logic);
    end component;

    signal CLK : std_logic := '0';
    signal MQ: std_logic_vector(3 downto 0);
    signal MPROG, MRUN, ZOUT: std_logic;

begin

    clk <= not clk after 100 ns;
    MPROG <= '0' after 0 ns, '1' after 400 ns, '0' after 600 ns;
    MQ <= x"C" after 0 ns,  x"1" after 1600 ns, x"F" after 5000 ns;
    MRUN <= '0' after 0 ns, '1' after 600 ns; 

    comp_i: comp port map(
        MQ => MQ,
        MPROG => MPROG,
        CLK => CLK,
        MRUN => MRUN,
        ZOUT => ZOUT);

    dummy <= '0';

end arch;