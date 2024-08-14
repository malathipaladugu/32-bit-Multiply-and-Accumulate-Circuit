library ieee;
use ieee.std_logic_1164.all;
use work.ANDgate_23m1200_package.all;
use work.XORgate_23m1200_package.all;
use work.ABCgate_23m1200_package.all;
use work.Cin_map_G_23m1200_package.all;

package FA_package is
	Component FA
	  port( A,B,Cin : in std_logic;
			  Sum, Cout: out std_logic);
	end Component;
end package;