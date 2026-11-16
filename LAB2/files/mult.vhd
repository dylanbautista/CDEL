library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity xx1 is
    generic( n : natural := 8 );
    port( X,Y : in std_logic_vector(n-1 downto 0);
            Z : out std_logic_vector(2*n-1 downto 0) );
end xx1;

architecture arch of xx1 is
begin
    process (X,Y) begin
        Z <= std_logic_vector(unsigned(X)*unsigned(Y));
    end process;
end arch;