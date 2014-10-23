--CPU controller 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.datapath_declarations.all;

package controller_declarations is

  constant MOV: std_logic_vector(2 downto 0) := "110"
  constant ALU: std_logic_vector(2 downto 0) := "101"
  constant LDR: std_logic_vector(2 downto 0) := "011"
  constant STR: std_logic_vector(2 downto 0) := "100"

  component controller is
    generic( );
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
type state_type is (loadIR, updatePC, decode, readrm, alu, computeaddress, load, writerdrn);
signal current_state, next_state, next1: state_type;
signal Rn, Rd, Rm: std_logic_vector(2 downto 0);

--perhaps it would be easier to use states defined by their opcode

reset <='1';
loadpc <='0';
loadir <='0';
msel <='0';
vsel <= "11";
nsel <= "11";
aluop <= op;

process(all) begin
    case current_state is
      when loadir =>  
        --load instruction into IR
        next1 <= updatepc; 
        msel <= '0';
        reset <= '0';
        loadpc <= '0';
        loadir <= '1';

  	  when updatepc => 
        next1 <= decode; 
        loadpc <= '1';

  	  when decode => 
      -- read Rn into register A
      --decode and determine which opcode state to go into
        read_value <= Rm;
        loada <= 1;
        nsel <= "11";

        case? opcode&op is
          when "11010" => next1 <= writerdrn; --mov Rn,#<imm8>
          when "101--" => next1 <= readrm; --read rm state
          when "01100" => next1 <= computeaddress; --compute address for ldr str
          when "10000" => next1 <= computeaddress; -- compute address for ldr str
          when others => next1 <= '-';
        end case?;

      when readrm =>
        -- load Rm into register B
        loadb <= '1';
        loada <= '0';
        nsel <= "01";
        bsel <= '0';
        case? opcode&op is
          when "101--" => next1 <= alu; -- alu options
          when "11000" => next1 <= writerdrn; asel <= 1; bsel<=0; loadc<=1; --mov rd
          when others => next1 <= '-';
        end case?;

      when alu =>
        loadb <= 0;
        aluop <= op;
        loadc <= 1;
        next1 <= writerdrn;

      when computeaddress =>
        bsel <= '1'; --bin is sximm5
        aluop <= "00";
        loadc <= '1' -- load the value of alu into register c
        case opcode is
          when "011" => next1 <= load; 
          when "100" => next1 <= writerdrn;
          when others => next1 <= loadir;
        end case;

      when load => 
        --mdata = output of register C
        msel <= '1';
        next1 <= writerdrn;

      when writerdrn =>
          case? opcode&op is
            when "11010" => next1 <= loadir; rd <= sximm8; nsel <= "11"; --mov rn
            when "10000" => next1 <= loadir; rd <= cout; mwrite <= '1'; --str 
            when "101--" => next1 <= loadir; rd <= cout; nsel <="10"; -- alu operations
            when "01100" => next1 <= loadir; rd <= mdata; nsel <= 10;
            when others => next1 <= loadir;
          end case?
      when others => next1 <= loadir;
    end case;
  end process;

  -- add reset
  next_state <= loadir when reset else next1;
  
 end process