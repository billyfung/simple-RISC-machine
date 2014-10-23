--CPU controller 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

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

entity controller is
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
end ;

entity datapath is 
end;

architecture impl of controller is
type state_type is (loadIR, updatePC, decode, readrm, alu, computeaddress, writerdrn);
signal current_state, next_state, next1: state_type;
signal Rn, Rd, Rm: std_logic_vector(2 downto 0);

--perhaps it would be easier to use states defined by their opcode


process(all) begin
    case current_state is
      when loadir =>  
        next1 <= updatepc; -- 
        msel <= '0';
        reset <= '0';
        loadpc <= '0'
  	  when updatepc => 
        next1<= decode; -- Rn into register A, Rm into register B
        read_value <= Rn;
        loada <= 1;

  	  when decode => 
        case opcode&op is
          when MOV & "10" => next1 <= writerdrn;
          when ALU => next1 <=

          when others =>  state <= S1;
          end case;
      when others =>  
        next1 <= std_logic_vector'(SWIDTH-1 downto 0 => '-'); 
        lights <= "------";
    end case;
  end process;

  -- add reset
  next_state <= loadir when reset else next1;
  
 end process