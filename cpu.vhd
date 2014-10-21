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