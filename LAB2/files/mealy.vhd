library ieee;
use ieee.std_logic_1164.all;

entity mealy is
    port(PR: in std_logic;
        clk: in std_logic;
        reset: in std_logic;
        CA, CB, A, B: out std_logic);
end mealy;

architecture arch of mealy is

type states is (chk_any, chk_A, chk_B, chk_no);
signal c_state, nxt_state: states;


begin

-- State reg
process(clk, reset)
begin
    if reset = '1' then
        c_state <= chk_any;
    elsif rising_edge(clk) then
        c_state <= nxt_state;
    end if;
end process;

-- Next state logic
process(c_state, reset, PR)
    variable v_nxt_state: states;
begin
    v_nxt_state := c_state;
    if (reset = '0') then
        case c_state is
            when chk_any =>
                if (PR = '1') then
                    v_nxt_state := chk_any;
                else
                    v_nxt_state := chk_A;
                end if;
            when chk_A =>
                if (PR = '1') then
                    v_nxt_state := chk_no;
                else
                    v_nxt_state := chk_B;
                end if;
            when chk_B =>
                if (PR = '1') then
                    v_nxt_state := chk_any;
                else
                    v_nxt_state := chk_no;
                end if;
            when chk_no =>
                if (PR = '1') then
                    v_nxt_state := chk_any;
                else
                    v_nxt_state := chk_no;
                end if;
        end case;
    else
        v_nxt_state := chk_any;
    end if;
    nxt_state <= v_nxt_state;
end process;

-- Output logic
process(c_state, reset, PR)
    variable v_CA, v_CB, v_A, v_B : std_logic;
begin
    if (reset = '0') then
        case c_state is
            when chk_any =>
                v_CA := '0';
                v_CB := '0';
                v_A := '0';
                v_B := '0';
            when chk_A =>
                if (PR = '1') then
                    v_CA := '0';
                    v_CB := 'Z';
                    v_A := '0';
                    v_B := '0';
                else
                    v_CA := '0';
                    v_CB := 'Z';
                    v_A := '1';
                    v_B := '0';
                end if;
            when chk_B =>
                if (PR = '1') then
                    v_CA := 'Z';
                    v_CB := '0';
                    v_A := '0';
                    v_B := '0';
                else
                    v_CA := 'Z';
                    v_CB := '0';
                    v_A := '0';
                    v_B := '1';
                end if;
            when chk_no =>
                v_CA := '0';
                v_CB := '0';
                v_A := '0';
                v_B := '0';
        end case;
    end if;

    CA <= v_CA;
    CB <= v_CB;
    A <= v_A;
    B <= v_B;

end process;

end arch;