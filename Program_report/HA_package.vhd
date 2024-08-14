library ieee;
use ieee.std_logic_1164.all;
use work.ANDgate_23m1200_package.all;
use work.XORgate_23m1200_package.all;
use work.ABCgate_23m1200_package.all;
use work.Cin_map_G_23m1200_package.all;

package HA_package is
	component HA
	  port( A,B : in std_logic;
			  Sum, Cout: out std_logic);
	end component;
end package;