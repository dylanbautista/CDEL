library ieee;
library work;
use ieee.std_logic_1164.all;

entity sw_det is
    port(clk, P, init: in std_logic;
            CA, CB, A, B: out std_logic);
end sw_det;

architecture arch of sw_det is
    component mealy
        port(PR: in std_logic;
        clk: in std_logic;
        reset: in std_logic;
        CA, CB, A, B: out std_logic);
    end component;

    signal PR_q : std_logic;
begin

    mealy_i: mealy port map(
        PR => PR_q,
        clk => clk,
        reset => init,
        CA => CA,
        CB => CB,
        A => A,
        B => B);
    
    process(clk, init)
    begin
        if (init = '0') then
            if falling_edge(clk) then 
                PR_q <= P;
            end if;
        else
            PR_q <= '0';
        end if;
    end process;
    
end arch;