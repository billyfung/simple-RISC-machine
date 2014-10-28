library ieee;
use ieee.std_logic_1164.all;
use work.register_file_declarations.all;
use work.ff.all;
use work.shifter_declarations.all;
use work.alu_declarations.all;
use work.datapath_declarations.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use std.env.all;

entity datapath_tbb is
end datapath_tbb;

architecture test of datapath_tbb is

		constant word_size : integer := 16;
		constant addr_width : integer := 8;

		signal clk          :  std_logic;
		signal reset        :  std_logic;
		--signal datapath_in  :  std_logic_vector(7 downto 0);
		signal write        :  std_logic;
		signal ft_mdata		: std_logic_vector(15 downto 0);
		signal ft_use_mdata	: std_logic;
		signal mwrite			:  std_logic;
		signal msel			:  std_logic;
		signal loadir			:  std_logic;
		signal loadpc			:  std_logic;
		--signal readnum      :  std_logic_vector(2 downto 0);
      signal vsel         :  std_logic_vector(1 downto 0);
		--signal sximm5, sximm8: std_logic_vector(word_size-1 downto 0);
      signal loada        :  std_logic;
      signal loadb        :  std_logic;
		--signal shift        :  std_logic_vector(1 downto 0);
      signal asel         :  std_logic;
      signal bsel         :  std_logic;
      --signal ALUop        :  std_logic_vector(1 downto 0);
      signal loadc        :  std_logic;
      signal loads        :  std_logic;
		signal writenum     :  std_logic_vector(2 downto 0);
      signal nsel				: std_logic_vector(1 downto 0);
		signal opcode 		: std_logic_vector(2 downto 0);
		signal op 				: std_logic_vector(1 downto 0);
      --signal datapath_out :  std_logic_vector(word_size-1 downto 0)
begin
	DUT: datapath generic map(word_size, addr_width) port map(	clk => clk,
																					reset => reset,
																					--datapath_in  => datapath_in,
																					write => write,
																					ft_mdata => ft_mdata,
																					ft_use_mdata => ft_use_mdata,
																					mwrite => mwrite,
																					opcode => opcode,
																					op => op,
																					msel => msel,
																					loadir => loadir,
																					loadpc => loadpc,
																					--readnum => readnum,
																					vsel => vsel,
																					--sximm5 => sximm5,
																					--sximm8 => sximm8,
																					loada => loada,
																					loadb => loadb,
																					--shift => shift,
																					asel => asel,
																					bsel => bsel,
																					--ALUop => ALUop,
																					loadc => loadc,
																					loads => loads,
																					--writenum => writenum,
																					
																					nsel => nsel);
																					--ft_irout => ft_irout);
																					--datapath_out => datapath_out
																					
	process begin
		clk <= '0';
		wait for 10 ns;
		clk  <= '1';
		wait for 10 ns;
	end process;
	
	process begin
	--instantiate everything to 0 (rst to 1 so pc will be zeroes)
	wait for 10 ns;
	reset <= '1';
	write <= '0';
	ft_mdata <= "0000000000000000";
	loadir <= '1';
	ft_use_mdata <= '0'; --mdata shouldn't be anything yet, so we're using a forced value
	mwrite <= '0';
	msel <= '1';
	loadir <= '1';
	loadpc <= '0';
	vsel <= "00";
	loada <= '0';
	loadb <= '0';
	asel <= '0';
	bsel <= '0';
	loadc <= '0';
	loadb <= '0';
	nsel <= "00";
	wait for 20 ns;
	reset <= '0';
	wait for 20 ns;
	
	--increment to PC to 3
	loadpc <= '1';
	wait for 60 ns;
	loadpc <= '0';
	
	
	loadpc <= '0';
	ft_mdata <= "0000000000100100"; --Rn = 000, Rd = 001, Rm = 100
	vsel <= "01"; --Getting PC as value
	write <= '1'; -- 000 gets value 3
	wait for 20 ns;
	write <= '0';
	
	loadpc <= '1';
	wait for 20 ns; --PC goes to 4
	loadpc <= '0';
	
	nsel <= "01";
	write <= '1';
	wait for 20 ns; -- 001 get value 4
	write <= '0';
	loadb <= '1';
	wait for 20 ns; -- b gets value 4
	
	nsel <= "00";
	loadb <= '0';
	loada <= '1';
	wait for 20 ns; -- a gets value 3
	
	loada <= '0';
	loadc <= '1';
	wait for 20 ns; -- c gets value 7
	ft_mdata <= "0000100000100100";
	wait for 40 ns; -- c gets value -1, status should be 010;
	
	loadc <= '0';
	vsel <= "00";
	nsel <= "10";
	write <= '1';
	wait for 20 ns;	-- 100 gets value -1
	write <= '0';
	
	asel <= '1';
	ft_mdata <= "0000000000100100";
	wait for 20 ns;
	--loadc <= '1';
	wait for 20 ns; -- c gets value 4 (use for adress)
	loadb <= '1';
	loadc <= '0';
	wait for 40 ns; -- b gets value -1;
	loadb <= '0';
	ft_use_mdata <= '1'; --So we can see what mdata will be!
	loadir <= '0';
	--msel <= '1';
	mwrite <= '1';
	wait for 20 ns; -- Adress 4 should get value -1, which means mdata should become 1111111111111111
	mwrite <= '0';
	wait for 20 ns;
	
	stop(0);
	
	
	end process;
		
			
end test;		