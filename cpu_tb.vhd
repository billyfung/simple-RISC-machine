library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.ff.all;
use work.datapath_declarations.all;
use work.controller_declarations.all;
use std.env.all;

entity cpu_tb is
end entity;

architecture test of cpu_tb is

	signal reset		: std_logic;
	signal clk		: std_logic;
	
begin
	DUT : controller port map(  reset => reset,
						                  clk	  => clk);
						
	process begin
		clk <= '0'; wait for 5 ps;
		clk <= '1'; wait for 5 ps;
	end process;
	
	process begin
		
		--Put  2 into register 0
		reset <= '1';
		<<signal DUT.DATPATH.mdata: std_logic_vector>> <= force "1101000000000010";
		wait for 10 ps;
		reset <= '0';
		wait for 30 ps;
		
		--Put 4 into register 1
		<<signal DUT.DATPATH.mdata: std_logic_vector>> <= force "1101000100000100";
		reset <= '1';
		wait for 10 ps;
		reset <= '0';
		wait for 30 ps;
		
		--Add reg0 and reg1 together to get 6
		<<signal DUT.DATPATH.mdata: std_logic_vector>> <= force "1010000001000001";
		reset <= '1';
		wait for 10 ps;
		reset <= '0';
		wait for 60 ps;
		
		--Compares Register 1 to Register 0, since 4 > 2, status should be 010
		<<signal DUT.DATPATH.mdata: std_logic_vector>> <= force "1010100100000000";
		reset <= '1';
		wait for 10 ps;
		reset <= '0';
		wait for 50 ps;
		
		--Shifts output of register 0 from 10 to 100 and ANDs it with Register 2, should give us 100 into reg 3
		<<signal DUT.DATPATH.mdata: std_logic_vector>> <= force "1011001001101000";
		reset <= '1';
		wait for 10 ps;
		reset <= '0';
		wait for 80 ps;
		
		--Nots register 2 to give 1111111111111001 and stores it in register 4
		<<signal DUT.DATPATH.mdata: std_logic_vector>> <= force "1011100010000010";
		reset <= '1';
		wait for 10 ps;
		reset <= '0';
		wait for 80 ps;
		
		--Puts 1111111111111001 into memory at address 110 (register 2) 
		<<signal DUT.DATPATH.mdata: std_logic_vector>> <= force "1000001010000000";
		reset <= '1';
		wait for 10 ps;
		reset <= '0';
		wait for 80 ps;
		
		--Recalls 1111111111111001 from memory at address 110 (register 2), puts into register 5 
		<<signal DUT.DATPATH.mdata: std_logic_vector>> <= force "0110001010100000";
		reset <= '1';
		wait for 10 ps;
		reset <= '0';
		wait for 40 ps;
		<<signal DUT.DATPATH.mdata: std_logic_vector>> <= release;
		wait for 80 ps;
		
		--Shifts 1111111111111001 to 1111111111111000 and stores it in register 6
		<<signal DUT.DATPATH.mdata: std_logic_vector>> <= force "1100000011011101";
		reset <= '1';
		wait for 20 ps;
		reset <= '0';
		wait for 80 ps;
		
		<<signal DUT.DATPATH.mdata: std_logic_vector>> <= release;
		
		stop(0);
		
	end process;
end test;
