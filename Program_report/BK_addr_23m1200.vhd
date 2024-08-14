library ieee;
use ieee.std_logic_1164.all;
use work.ANDgate_23m1200_package.all;
use work.XORgate_23m1200_package.all;
use work.ABCgate_23m1200_package.all;
use work.Cin_map_G_23m1200_package.all;

entity BK_addr_23m1200 is
	generic ( N	 : INTEGER := 32); -- N is the number of bits in each operand
	port (A, B	 : in std_logic_vector(N-1 downto 0);
			Cin	 : in std_logic;
			BK_out : out std_logic_vector(N-1 downto 0);
			C_inrl : out std_logic_vector(N downto 1);
			Cout 	 : out std_logic);
end entity;

architecture st1 of BK_addr_23m1200 is
  
  signal Ctemp : std_logic_vector(N downto 1);
  signal P0 : std_logic_vector(N-1 downto 0);
  signal G0 : std_logic_vector(N-1 downto 0);
  signal P1 : std_logic_vector(15 downto 0);
  signal G1 : std_logic_vector(15 downto 0);
  signal P2 : std_logic_vector(7 downto 0);
  signal G2 : std_logic_vector(7 downto 0);
  signal P3 : std_logic_vector(3 downto 0);
  signal G3 : std_logic_vector(3 downto 0);
  signal P4 : std_logic_vector(1 downto 0);
  signal G4 : std_logic_vector(1 downto 0);
  signal P5 : std_logic;
  signal G5 : std_logic;
  
begin

	C_inrl <= Ctemp;
	
	ic1: Cin_Map_G_23m1200 port map(A(0),B(0),Cin,Ctemp(1)); -- C(1)
	G0(0) <= Ctemp(1); -- G0(0) is same as C(1);

	
-- finding P0 and G0 for all input bits	
	P0G0: for i in 0 to N-1 generate
     P0if: if i = 0 generate
	    ip0 : XORgate_23m1200 port map(A(i), B(i), P0(i));
	  end generate P0if;
	  P0G0if: if i > 0 generate
	    ip0_1 : XORgate_23m1200 port map(A(i), B(i), P0(i));
		 iG0 : ANDgate_23m1200 port map(A(i), B(i), G0(i));
	  end generate P0G0if;
	end generate P0G0;
	
-- finding P1 and G1
	P1G1: for i in 0 to 15 generate
	  ip1 : ANDgate_23m1200 port map(P0(((i+1)*2)-1),P0(i*2),P1(i));
	  ig1 : ABCgate_23m1200 port map(G0(((i+1)*2)-1),P0(((i+1)*2)-1),G0(i*2),G1(i));
	end generate P1G1;
	
-- finding P2 and G2
	P2G2: for i in 0 to 7 generate
	  ip2 : ANDgate_23m1200 port map(P1(((i+1)*2)-1),P1(i*2),P2(i));
	  ig2 : ABCgate_23m1200 port map(G1(((i+1)*2)-1),P1(((i+1)*2)-1),G1(i*2),G2(i));
	end generate P2G2;
	
-- finding P3 and G3
	P3G3: for i in 0 to 3 generate
	  ip3 : ANDgate_23m1200 port map(P2(((i+1)*2)-1),P2(i*2),P3(i));
	  ig3 : ABCgate_23m1200 port map(G2(((i+1)*2)-1),P2(((i+1)*2)-1),G2(i*2),G3(i));
	end generate P3G3;

-- finding P4 and G4
	P4G4: for i in 0 to 1 generate
	  ip4 : ANDgate_23m1200 port map(P3(((i+1)*2)-1),P3(i*2),P4(i));
	  ig4 : ABCgate_23m1200 port map(G3(((i+1)*2)-1),P3(((i+1)*2)-1),G3(i*2),G4(i));
	end generate P4G4;	
	
-- finding P5 and G5
	  ip5 : ANDgate_23m1200 port map(P4(1),P4(0),P5);
	  ig5 : ABCgate_23m1200 port map(G4(1),P4(1),G4(0),G5);
	  
-- finding carry and sum
	Ctemp(2)  <= G1(0);
	Ctemp(4)  <= G2(0);
	Ctemp(8)  <= G3(0);
	Ctemp(16) <= G4(0);
	Ctemp(32) <= G5;
	
--Finding all other odd carry terms
	CTm1: for i in 1 to 15 generate  
	  CT1 : ABCgate_23m1200 port map(G0(i*2),P0(i*2),Ctemp(i*2),Ctemp((i*2)+1));
	end generate CTm1;
	
-- finding C6,10,14,18,22,26,30
	CTm2: for i in 1 to 7 generate  
	  CT2 : ABCgate_23m1200 port map(G1(i*2),P1(i*2),Ctemp(i*4),Ctemp((i*4)+2));
	end generate CTm2;
	
-- finding C12,20,28,
	CTm3: for i in 1 to 3 generate  
	  CT4 : ABCgate_23m1200 port map(G2(i*2),P2(i*2),Ctemp(i*8),Ctemp((i*8)+4));
	end generate CTm3;		

-- finding C24
	ic24 : ABCgate_23m1200 port map(G3(2),P3(2),Ctemp(16),Ctemp(24));
	
-- Final carry out
	Cout <= G5;
	
-- Final Sum
	BK0 : XORgate_23m1200 port map(P0(0), Cin, BK_out(0));
	SBK: for i in 1 to 31 generate
	  BK : XORgate_23m1200 port map(P0(i), Ctemp(i), BK_out(i));
	end generate SBK;
	
end architecture;