library ieee;
use ieee.std_logic_1164.all;

package ANDgate_23m1200_package is
	component ANDgate_23m1200
		port ( A, B : in std_logic;
				 prod : out std_logic);
	end component;
end package;