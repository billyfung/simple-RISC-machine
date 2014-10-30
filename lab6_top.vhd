-- synthesis VHDL_INPUT_VERSION VHDL_2008

library ieee;
use ieee.std_logic_1164.all;
use work.sseg_constants.all;
use work.datapath_declarations.all;
use work.controller_declarations.all;

entity lab6_top is
  port( KEY: in std_logic_vector(3 downto 0);
        SW: in std_logic_vector(17 downto 0);
        LEDR: out std_logic_vector(17 downto 0);
        LEDG: out std_logic_vector (7 downto 0);
        HEX0, HEX1, HEX2, HEX3: out sseg_type;
        HEX4, HEX5, HEX6, HEX7: out sseg_type );
end entity;

architecture impl of lab6_top is
  signal data : std_logic_vector(word_size-1 downto 0) ;
  signal pc: std_logic_vector(7 downto 0);


  signal clk, reset: std_logic;
begin
  CPU: controller port map( clk         => clk, -- KEY is 1 when NOT pushed
                         reset       => reset,
                         datapath_out => data,
                         pc_out=> pc
                       );


  clk <= NOT key(0);
  reset <= NOT key(1);

  H0: sseg port map( data(3 downto 0), HEX0 );   -- displays HEX digits: 0,1,2...9,A,B,C,D,E,F
  H1: sseg port map( data(7 downto 4), HEX1 );
  H2: sseg port map( data(11 downto 8), HEX2 );
  H3: sseg port map( data(15 downto 12), HEX3 );
  H4: sseg port map( pc(3 downto 0), HEX4 );
  H5: sseg port map( pc(7 downto 0), HEX5 );
end impl;
