library ieee;
use ieee.std_logic_1164.all;

package ABCgate_23m1200_package is
	component ABCgate_23m1200
		port ( A, B, C : in std_logic;
				 ABC : out std_logic);
	end component;
end package;