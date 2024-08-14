library ieee;
use ieee.std_logic_1164.all;

package Cin_map_G_23m1200_package is
	component Cin_map_G_23m1200
		port ( A, B, Cin : in std_logic;
				 Bit0_G : out std_logic);
	end component;
end package;