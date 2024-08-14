library ieee;
library std;
use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_MAC_Dadda_23m1200_2_final_file is
end entity;

architecture stim of test_MAC_Dadda_23m1200_2_final_file is
		
	signal T_A, T_B : std_logic_vector(15 downto 0) := (others => '0');
	signal T_C : std_logic_vector(31 downto 0) := (others => '0');
	signal T_MAC_out, T_MAC_out_golden : std_logic_Vector(31 downto 0);
	signal T_MAC_Carry_out : std_logic;
	signal T_MAC_A, T_MAC_B : std_logic_vector(31 downto 0);
	
begin

  dut1 : entity work.MAC_Dadda_23m1200_2 (ar1)
				port map (T_A,T_B,T_C,T_MAC_out,T_MAC_Carry_out,T_MAC_A,T_MAC_B);
  
  Process
    variable err_flag : boolean := false;
	 variable Temp_A, Temp_B : bit_vector(15 downto 0);
	 variable Temp_C, Temp_MAC_out : bit_vector(31 downto 0);
	 variable Temp_MAC_Carry_out : bit;


	 --for file read/write
	 variable input_line, output_line:Line;
	 file infile: text open read_mode is "test_MAC_Dadda_23m1200_inputs.txt";
	 file outfile: text open write_mode is "test_MAC_Dadda_23m1200_outputs.txt";
    begin
	   while not endfile(infile) loop
		  readline(infile,input_line);
		  read(input_line,Temp_A);
		  read(input_line,Temp_B);
		  read(input_line,Temp_C);
		  read(input_line,Temp_MAC_out);
		  read(input_line,Temp_MAC_Carry_out);
		  
		  T_A <= to_stdlogicvector(Temp_A);
		  T_B <= to_stdlogicvector(Temp_B);
		  T_C <= to_stdlogicvector(Temp_C);
		  T_MAC_out_golden <= to_stdlogicvector(Temp_MAC_out);
		  
		  wait for 20 ns; -- wait for response to get stable
        write(output_line,to_bitvector(T_MAC_out));
		  write(output_line,' ');
		  write(output_line,to_bit(T_MAC_Carry_out));
        write(output_line,' ');		  
	  if (((T_MAC_out_golden = T_MAC_out)) and (to_stdulogic(Temp_MAC_Carry_out) = T_MAC_Carry_out)) then
            write(output_line,'P');
		  else
          write(output_line,'F');
          err_flag := true;			 
		  end if;
		  writeline(outfile,output_line);
		end loop;
      assert (err_flag) report "SUCCESS, all tests passed." severity note;
      assert (not err_flag) report "FAILURE, some tests failed." severity error;		
		wait;
  end process;
end architecture;