library ieee;
use ieee.std_logic_1164.all;

entity ANDgate_23m1200 is
	port ( A, B : in std_logic;
		    prod : out std_logic);
end entity;

architecture ar1 of ANDgate_23m1200 is 

begin
	prod <= A and B after 300 ps; -- delay = 300 + 00 ps = 300ps (23m1200)
end architecture;