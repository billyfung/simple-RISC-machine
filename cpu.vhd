--CPU controller 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.datapath_declarations.all;

package controller_declarations is

  constant MOV: std_logic_vector(2 downto 0) := "110";
  constant ALU: std_logic_vector(2 downto 0) := "101";
  constant LDR: std_logic_vector(2 downto 0) := "011";
  constant STR: std_logic_vector(2 downto 0) := "100";

  component controller is
    port (reset        : in std_logic;
		  opcode	   : in std_logic_vector(2 downto 0);
		  op		   : in std_logic_vector(1 downto 0);

      status       : buffer std_logic;
		  loadir	   : out std_logic;
      loadpc	   : out std_logic;
		  vsel		   : out std_logic;
		  nsel         : out std_logic_vector(1 downto 0)
		  );
  end component;
end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.datapath_declarations.all;

entity controller is
    generic( );
    port (
      reset        : in std_logic;
		  opcode	     : in std_logic_vector(2 downto 0);
		  op		      : in std_logic_vector(1 downto 0);
      status       : buffer std_logic;
		  loadir	   : out std_logic;
      loadpc	   : out std_logic;
		  vsel		   : out std_logic;
		  nsel         : out std_logic_vector(1 downto 0)
		  );
end ;



entity cpu is 

end;

architecture impl of controller is
type state_type is (loadIR, updatePC, decode, readrm, alu, memory, writerdrn);
signal current_state, next_state, next1: state_type;
signal Rn, Rd, Rm: std_logic_vector(2 downto 0);

--perhaps it would be easier to use states defined by their opcode
begin

current_state <= state_type'val(to_integer(unsigned(state_type)));
next_state <= state_type'val(to_integer(unsigned(state_type)));
next1 <= state_type'val(to_integer(unsigned(state_type)));

aluop <= op;

process(all) begin
    case? current_state&opcode&op is
      when loadir & "-----" => next1 <= updatepc;
      when updatepc & "-----" => next1 <= decode;
      when decode & "11010" => next1 <= writerdrn; --mov rn
      when decode & "10---" => next1 <= readrm; --alu & str
      when decode & "011---" => next1 <= readrm; --ldr
      when readrm & "110---" => next1 <= writerdrn; -- mov rd
      when readrm & "101---" => next1 <= alu; -- add, cmp, and, mvn
      when readrm & "011---" => next1 <= alu; --ldr
      when readrm & "100---" => next1 <= alu; --str
      when alu & "10101" => next1 <= loadir; --cmp
      when alu & "10100" => next1 <= writerdrn; --add
      when alu & "10110" => next1 <= writerdrn; --and
      when alu & "10111" => next1 <= writerdrn; --mvn
      when alu & "01100" => next1 <= memory; --ldr
      when alu & "10000" => next1 <= memory; --str
      when memory & "011--" => next1 <= writerdrn; --ldr to write
      when memory & "100--" => next1 <= loadir; --str to memory & then next instruction
      when writerdrn & "-----" => next1 <= loadir;
      when others => next1 <= loadir;
    end case?
end process;

loadir <= '1' when current_state = loadir else '0';
loadpc <= '1' when current_state = updatepc else '0';
read_value <= Rm when current_state = decode else "000";
loada <= '1' when current_state = decode else '0'; -- Rm into regA
loadb <= '1' when current_state = readrm else '0';
--Rn <= sximm8 when current_state&opcode = writerdrn & "10" else "---"; -- rn=sximm8 
nsel <= "11" when current_state & opcode = writerdrn & "10" else "10"; -- nsel = rn for mov_rn, else nsel =rd
loadc <= '1' when current_state = alu else '0';
--status flag <= cmp stuff
asel <= '1' when current_state & opcode = writerdrn & "00" else '0;' -- rd = shifted_rm

  case current_state&opcode is
    when alu&"011" => bsel <= '1';
    when alu&"100" => bsel <= '1';
    when others => bsel <= '0';
  end case;
msel <= '1' when bsel = '1' else '0';
mwrite <= '1' when current_state & opcode = memory & "100"
vsel <= "10" when current_state & opcode&op = writerdrn & "110" & "00" else 
        "11" when current_state & opcode = writerdrn & "011"



  -- add reset
  next_state <= loadir when reset else next1;
  
 end;