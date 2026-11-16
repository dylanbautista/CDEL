library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity count16bits is
    port (
        clk, nrst : in std_logic;
        q : out std_logic_vector(15 downto 0)
    );
end count16bits;




architecture arch2 of count16bits is
    signal cnt : unsigned(15 downto 0) := (others => '0');
begin

    process(clk)
    begin
        if falling_edge(clk) then

            if nrst = '0' then
                -- Reset the counter to 0
                cnt <= (others => '0');

            else
                -- Increment the counter
                cnt <= cnt + 1;
            end if;

        end if;
    end process;

    -- Output the current count
    q <= std_logic_vector(cnt);

end arch2;