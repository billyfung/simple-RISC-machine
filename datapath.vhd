-- synthesis VHDL_INPUT_VERSION VHDL_2008
library ieee;
use ieee.std_logic_1164.all;
use work.alu_declarations.all;
use work.shifter_declarations.all;
use work.register_file_declarations.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

package datapath_declarations is
  component datapath is
    generic( word_size : integer := 16; addr_width : integer := 8 );
    port (clk          : in std_logic;
        reset        : in std_logic;
        write        : in std_logic;
		  --ft_mdata		: in std_logic_vector(15 downto 0);
		 -- ft_use_mdata : in std_logic;
		  mwrite			: in std_logic;
		  msel			: in std_logic;
		  loadir			: in std_logic;
		  loadpc			: in std_logic;
			--readnum      : in std_logic_vector(2 downto 0);
        vsel         : in std_logic_vector(1 downto 0);
		--	sximm5       : in std_logic_vector(word_size-1 downto 0);
		--	sximm8       :in std_logic_vector(word_size-1 downto 0);
        loada        : in std_logic;
        loadb        : in std_logic;
		--	shift        : in std_logic_vector(1 downto 0);
        asel         : in std_logic;
        bsel         : in std_logic;
		--	ALUop        : in std_logic_vector(1 downto 0);
        loadc        : in std_logic;
        loads        : in std_logic;
		  nsel			: in std_logic_vector(1 downto 0);
		--	writenum     : in std_logic_vector(2 downto 0);
		   opcode      : out std_logic_vector(2 downto 0);
		   op           : out std_logic_vector(1 downto 0);
        status       : out std_logic_vector(2 downto 0);
		
		datapath_out : out std_logic_vector(word_size-1 downto 0) 
		);
  end component;
end package;

library ieee;
use ieee.std_logic_1164.all;
use work.register_file_declarations.all;
use work.ff.all;
use work.shifter_declarations.all;
use work.alu_declarations.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity datapath is
  generic( word_size : integer := 16; addr_width : integer := 8 );
  port (clk          : in std_logic;
        reset        : in std_logic;
       -- datapath_in  : in std_logic_vector(7 downto 0);
        write        : in std_logic;
		  --ft_mdata		: in std_logic_vector(15 downto 0);	--ft stands for 'for test' and must be commented unless used for testbench
		  --ft_use_mdata	: in std_logic;
		  mwrite			: in std_logic;
		  msel			: in std_logic;
		  loadir			: in std_logic;
		  loadpc			: in std_logic;
        --readnum      : in std_logic_vector(2 downto 0);
        vsel         : in std_logic_vector(1 downto 0);
		 -- sximm5, sximm8:in std_logic_vector(word_size-1 downto 0);
        loada        : in std_logic;
        loadb        : in std_logic;
		--	shift        : in std_logic_vector(1 downto 0);
        asel         : in std_logic;
        bsel         : in std_logic;
       -- ALUop        : in std_logic_vector(1 downto 0);
        loadc        : in std_logic;
        loads        : in std_logic;
       -- writenum     : in std_logic_vector(2 downto 0);
		  nsel			: in std_logic_vector( 1 downto 0);
		  
		  opcode			: out std_logic_vector(2 downto 0);
		  op				: out std_logic_vector(1 downto 0);

        status       : out std_logic_vector(2 downto 0);
        datapath_out : out std_logic_vector(word_size-1 downto 0) 
		);
end datapath;

architecture impl of datapath is

	signal read_value, write_value, ainbsel, binbshft, binbsel, ain, bin, aluout, cout, mdata, irout, sximm5, sximm8: std_logic_vector (word_size-1 downto 0);
	signal msel_out, PC_out, rst_out, loadpc_out, incrementer_out: std_logic_vector (addr_width-1 downto 0);
	signal Rn, Rd, Rm, nsel_out, writenum, readnum: std_logic_vector(2 downto 0);
	signal ALUop, shift: std_logic_vector(1 downto 0);
	--signal imm5 : std_logic_vector(4 downto 0);
	--signal ft_mdata_in : std_logic_vector(15 downto 0);
	signal sx_11	: std_logic_vector(10 downto 0);
	signal sx_8		: std_logic_vector(7 downto 0);

	signal taken: std_logic;
	

begin
  
  REGA:		vDFFE generic map(word_size) port map(clk, loada, read_value, ainbsel );
  SHIFTR:	shifter port map(binbshft, shift, binbsel);
  REGB:		vDFFE generic map(word_size) port map(clk, loadb, read_value, binbshft );
  ALUDP:	alu 	port map(ain, bin, ALUop, aluout, status);
  REGC:		vDFFE generic map(word_size) port map(clk, loadc, aluout, cout );
  REGFIL:	register_file generic map(word_size) port map(clk, readnum, writenum, write_value, write, read_value);
 
--------------------------------------------------------------------------------------------------------------
  PC: 		vDFF generic map(addr_width) port map(clk, rst_out, PC_out);												--
  RAMM:		RAM generic map (word_size, addr_width, "data.bin", "data.mif") port map (clk, msel_out, mwrite, bin, mdata );		--
  IR:		vDFFE generic map(word_size) port map(clk, loadir, mdata, irout);											--
--------------------------------------------------------------------------------------------------------------
  
--------------------------------------------------------------------------------------------------------------																													--
		incrementer_out <= (PC_out + 1);	
		datapath_out <= cout;																							--																															--
																																				--
	process(all) begin																													--
		case loadpc is																														--
			when '1' => loadpc_out <= incrementer_out;																			--
			when others => loadpc_out <= pc_out;																					--
		end case;																															--
	end process;																															--
	
	process(all) begin
		case msel is
			when '1' => msel_out <= cout(addr_width-1 downto 0);
			when others => msel_out <= PC_out;
		end case;
	end process;
	
	process(all) begin
		case reset is
			when '1' => rst_out <= (others=>'0');
			when others => rst_out <= loadpc_out;
		end case;
	end process;
	
	
	-- for testing purposes, so we can force what mdata is
	/*
	process(all) begin
		case ft_use_mdata is
			when '1' => ft_mdata_in <= mdata;
			when others => ft_mdata_in <= ft_mdata;
		end case;
	end process;
	--*/

	
			
  ------------------------------------------------------------------------------------------------------------
  
  
  process(all) begin
		case bsel is
			when '1' => bin <= sximm5;
			when others => bin <= binbsel;
		end case;
  end process;
  
  process(all) begin
		case asel is
			when '1' => ain <= (16b"0");
			when others => ain <= ainbsel;
		end case;
  end process;
  
  process(all) begin
		case vsel is
			when "11" => write_value <= mdata;
			when "10" => write_value <= sximm8;
			when "01" => write_value <= (8b"0" & PC_out);
			when others => write_value <= cout;
		end case;
  end process;
  
  
  
  ------------- Instruction Decoder ----------------
  
  process(all) begin
	ALUop <= irout(12 downto 11);
	sx_11 <= (others=>irout(4));
	sx_8 	<= (others=>irout(7));
	sximm5 <= (sx_11 & irout(4 downto 0));
	sximm8 <= (sx_8 & irout(7 downto 0));
	shift <= (irout(4 downto 3));
	readnum <= nsel_out;
	writenum <= nsel_out;
	Rn <= irout(10 downto 8);
	Rd <= irout(7 downto 5);
	Rm <= irout(2 downto 0);
	case nsel is
		when "00" => nsel_out <= Rn;
		when "01" => nsel_out <= Rd;
		when "10" => nsel_out <= Rm;
		when others => nsel_out <= Rn;
	end case;
	opcode <= irout(15 downto 13);
	op <= irout(12 downto 11);
  end process; 

   ------------- Branch Unit ----------------
	taken <= '1' when ((execb = '1') and
						(cond = "000"))
end impl;
