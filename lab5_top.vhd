-- synthesis VHDL_INPUT_VERSION VHDL_2008

library ieee;
use ieee.std_logic_1164.all;
use work.datapath_declarations.all;
use work.sseg_constants.all;

entity lab5_top is
  port( KEY: in std_logic_vector(3 downto 0);
        SW: in std_logic_vector(17 downto 0);
        LEDR: out std_logic_vector(17 downto 0);
        LEDG: out std_logic_vector (7 downto 0);
        HEX0, HEX1, HEX2, HEX3: out sseg_type;
        HEX4, HEX5, HEX6, HEX7: out sseg_type );
end entity;

architecture impl of lab5_top is
  signal data: std_logic_vector(15 downto 0);
begin
  DP: datapath port map( clk         => not KEY(0), -- KEY is 1 when NOT pushed
                         reset       => not KEY(3),

                         datapath_in => SW(7 downto 0),
                         write       => SW(8), 

                         -- register operand fetch stage
                         readnum     => SW(11 downto 9),
                         vsel        => SW(12),
                         loada       => SW(13),
                         loadb       => SW(14),

                         -- computation stage (sometimes called "execute")
                         shift       => SW(10 downto 9),
                         asel        => SW(11),
                         bsel        => SW(12),
                         ALUop       => SW(14 downto 13),
                         loadc       => SW(15),
                         loads       => SW(16),

                         -- set when "writing back" to register file
                         writenum    => SW(11 downto 9),

                         -- outputs
                         status      => LEDG(0),
                         datapath_out => data
                       );

  H0: sseg port map( data(3 downto 0), HEX0 );   -- displays HEX digits: 0,1,2...9,A,B,C,D,E,F
  H1: sseg port map( data(7 downto 4), HEX1 );
  H2: sseg port map( data(11 downto 8), HEX2 );
  H3: sseg port map( data(15 downto 12), HEX3 );
  HEX4 <= (others => '1'); -- disable
  HEX5 <= (others => '1'); -- disable
  HEX6 <= (others => '1'); -- disable
  HEX7 <= (others => '1'); -- disable
end impl;
