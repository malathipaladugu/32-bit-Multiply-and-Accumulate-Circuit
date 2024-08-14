library ieee;
use ieee.std_logic_1164.all;

package XORgate_23m1200_package is
	component XORgate_23m1200
		port ( A, B : in std_logic;
				 uneq : out std_logic);
	end component;
end package;