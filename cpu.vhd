--CPU controller 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.ff.all;
use work.datapath_declarations.all;

package controller_declarations is

  constant MOV: std_logic_vector(2 downto 0) := "110";
  constant ALU: std_logic_vector(2 downto 0) := "101";
  constant LDR: std_logic_vector(2 downto 0) := "011";
  constant STR: std_logic_vector(2 downto 0) := "100";
  
  constant state_loadIR: std_logic_vector(2 downto 0) := "000";
  constant updatePC: std_logic_vector(2 downto 0) := "001";
  constant decode: std_logic_vector(2 downto 0) := "010";
  constant readrm: std_logic_vector(2 downto 0) := "011";
  constant state_alu: std_logic_vector(2 downto 0) := "100";
  constant memory: std_logic_vector(2 downto 0) := "101";
  constant writerdrn: std_logic_vector(2 downto 0) := "110";

  component controller is
    port (
      reset        : in std_logic;
		clk			 : in std_logic
		 -- opcode	   : in std_logic_vector(2 downto 0);
		--  op		   : in std_logic_vector(1 downto 0);
     -- status       : buffer std_logic;
		 -- loadir	   : out std_logic;
     -- loadpc	   : out std_logic;
		 -- vsel		   : out std_logic;
		 -- nsel         : out std_logic_vector(1 downto 0)
		  );
  end component;
end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.ff.all;
use work.datapath_declarations.all;

entity controller is
    --generic( );
    port (
      reset        : in std_logic;
		clk			 : in std_logic
		  --opcode	     : in std_logic_vector(2 downto 0);
		  --op		      : in std_logic_vector(1 downto 0);
     -- status       : buffer std_logic;
		 -- loadir	   : buffer std_logic;
      --loadpc	   : buffer std_logic;
		 -- vsel		   : buffer std_logic_vector(1 downto 0);
		 -- nsel         : buffer std_logic_vector(1 downto 0)
		  );
end ;

--add datapath component

architecture impl of controller is
--type state_type is (state_loadIR, updatePC, decode, readrm, alu, memory, writerdrn);
	signal current_state, next_state, next1: std_logic_vector(2 downto 0);
	signal Rn, Rd, Rm, opcode: std_logic_vector(2 downto 0);

	signal write, loada, loadb, loadc, loadir, loadpc, asel, bsel, loads, mwrite, msel: std_logic;
	signal datapath_in : std_logic_vector(7 downto 0);
	signal status :std_logic_vector(2 downto 0);
	signal op, vsel, nsel: std_logic_vector(1 downto 0);
	
	constant MOV: std_logic_vector(2 downto 0) := "110";
	constant ALU: std_logic_vector(2 downto 0) := "101";
	constant LDR: std_logic_vector(2 downto 0) := "011";
	constant STR: std_logic_vector(2 downto 0) := "100";

	constant state_loadIR: std_logic_vector(2 downto 0) := "000";
	constant updatePC: std_logic_vector(2 downto 0) := "001";
	constant decode: std_logic_vector(2 downto 0) := "010";
	constant readrm: std_logic_vector(2 downto 0) := "011";
	constant state_alu: std_logic_vector(2 downto 0) := "100";
	constant memory: std_logic_vector(2 downto 0) := "101";
	constant writerdrn: std_logic_vector(2 downto 0) := "110";


begin

DATPATH: datapath port map(clk => clk, reset  => reset, write => write, mwrite  => mwrite,msel  => msel, loadir => loadir, loadpc => loadpc, vsel => vsel,
									 loada => loada,loadb => loadb,asel => asel,bsel => bsel,loadc => loadc,loads => loads,nsel  => nsel, opcode => opcode,op => op,status => status);
SR: vDFF generic map(3) port map(clk,next_state,current_state); -- state register

--current_state <= state_type'val(to_integer(unsigned(state_type)));
--next_state <= state_type'val(to_integer(unsigned(state_type)));
--next1 <= state_type'val(to_integer(unsigned(state_type)));

--aluop <= op;

process(all) begin
    case? current_state & opcode & op is
      when state_loadIR & "-----" => next1 <= updatepc;
      when updatepc & "-----" => next1 <= decode;
      when decode & "11010" => next1 <= writerdrn; --mov rn
		when decode & "11000" => next1 <= readrm; --Rd = shifted_Rm
      when decode & "10---" => next1 <= readrm; --alu & str
      when decode & "011--" => next1 <= readrm; --ldr
      when readrm & "110--" => next1 <= state_alu; -- mov rd
      when readrm & "101--" => next1 <= state_alu; -- add, cmp, and, mvn
      when readrm & "011--" => next1 <= state_alu; --ldr
      when readrm & "100--" => next1 <= state_alu; --str
		when state_alu & "110--" => next1 <= writerdrn;
      when state_alu & "10101" => next1 <= state_loadIR; --cmp
      when state_alu & "10100" => next1 <= writerdrn; --add
      when state_alu & "10110" => next1 <= writerdrn; --and
      when state_alu & "10111" => next1 <= writerdrn; --mvn
      when state_alu & "01100" => next1 <= memory; --ldr
      when state_alu & "10000" => next1 <= memory; --str
      when memory & "011--" => next1 <= writerdrn; --ldr to write
      when memory & "100--" => next1 <= state_loadIR; --str to memory & then next instruction
      when writerdrn & "-----" => next1 <= state_loadIR;
      when others => next1 <= state_loadIR;
    end case?;
end process;

loadir <= '1' when current_state = state_loadIR else '0';
loadpc <= '1' when current_state = updatepc else '0';
loada <= '1' when current_state = decode else '0'; -- Rn into regA
loadb <= '1' when current_state = readrm else '0'; -- Rm into regB
loadc <= '1' when current_state = state_alu else '0'; --aluout into regC

--nsel <= "00" when current_state & opcode = writerdrn & mov else "01"; -- nsel = rn for mov_rn, else nsel =rd

process(all) begin --Chooses what nsel should be based on current state (Rn = 00, Rd = 01, Rm = 10)
	case? current_state & opcode & op is
		when writerdrn & mov & "10" => nsel <= "00"; --The only time we need to write to Rn
		--when writerdrn & "-----" => nsel <= "01";	--Wasn't working, will ask Tor, however, still works with when others
		when decode & "-----" => nsel <= "00";			--We 'decode' Rn
		when readrm & "101--" | readrm & "110--" => nsel <= "10";			--We read rm so long as we aren't dealing with RAM
		when others => nsel <= "01";						--Otherwise, we make nsel Rd so, because write rd is the only case not taken care of
	end case?;
end process;

--status flag <= cmp stuff
asel <= '1' when current_state & opcode & op = state_alu & mov & "00" else '0'; -- rd = shifted_rm

--bsel is for mux regB output & sximm5
process(all) begin
  case current_state&opcode is
    when state_alu & LDR => bsel <= '1';
    when state_alu & STR => bsel <= '1';
    when others => bsel <= '0';
  end case;
end process;
msel <= '1' when current_state & opcode = writerdrn & STR else '0';
--enables writing into RAM 
mwrite <= '1' when current_state & opcode = memory & STR else '0';
--vsel selects what value to write into register 11 - mdata, 10-sximm8, 01-Pcout, 00-Cout
vsel <= "10" when current_state & opcode & op  = writerdrn & MOV & "10" else 
        "11" when current_state & opcode  = writerdrn & LDR  else 
        "00"; -- default is Cout as value into registerfile

--regfile address Rn when mov rn, else rd 
--00 Rn, 01 Rd, 10 Rm
--nsel <= "00" when current_state & opcode & op = writerdrn &  MOV & "10" else "01";
write <= '1' when current_state = writerdrn else '0';

  -- add reset
next_state <= state_loadIR when reset else next1;
  
end;