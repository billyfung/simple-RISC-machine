--CPU controller 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

package controller_declarations is
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


process(all) begin
    case current_state is
      when loadir =>  next1 <= updatepc;
	  when updatepc => next1<= decode;.
	  when decode => 
		if ADD  = 
      when YNS => next1 <= GEW; lights <= YNSL;
      when GEW => next1 <= YEW; lights <= GEWL;
      when YEW => next1 <= GNS; lights <= YEWL;
      when others =>  
        next1 <= std_logic_vector'(SWIDTH-1 downto 0 => '-'); 
        lights <= "------";
    end case;
  end process;

  -- add reset
  next_state <= GNS when rst else next1;
  
 end process