----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Seth Chatterton
-- 
-- Create Date: 05/28/2018 04:41:25 PM
-- Design Name: 
-- Module Name: PixelGenerator - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: talks to RAM to access data, then outputs that data on an 80 x 60 grid screen
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


--Reformatted J. Graham Keggi's vga_test_pattern for requesting from RAM and displaying game of life cells

-- v 1.0 5/28/18 preliminary version, untested
-- v 1.1 5/28/18 6:30 pm- tested, works as expected with the testbench
-- v 1.2 5/28/18 6:42 pm- added gridlines every 8 pixels vertically and horizontally

--OLD DESCRIPTION:
----------------------------------------------------------------------------------
-- Engineer:		J. Graham Keggi
-- 
-- Create Date:	15:10:36 07/12/2010 
-- Module Name:	vga_test_pattern - Behavioral
-- Target Device:	Spartan3E-500 Nexys2
--
-- Description:	Reads in current pixel X and Y as 2 10-bit vectors and supplys
--						an 8-bit color code consistent with the VGA test pattern
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use IEEE.NUMERIC_STD.ALL;

-- might need to pre load data, in which case, use a clk
entity vga_test_pattern is
	port(row,column			: in std_logic_vector(9 downto 0);
    	data_in 			: in std_logic_vector(0 downto 0);--RAM gives a 1 bit std_logic_vector
	    video_on            : in std_logic; -- added control
        --clk 				: in std_logic; -- the original vga_test_pattern was unclocked
		color				: out std_logic_vector(7 downto 0);
        --data_out			: out std_logic_vector(0 downto 0); --just for testing purposes
        addr				: out std_logic_vector(12 downto 0); -- addresses RAM
        RAM_EN				: out std_logic);
        
end vga_test_pattern;

architecture Behavioral of vga_test_pattern is
	
	-- Predefined 8-bit colors that nearly match real test pattern colors
	constant RED		: std_logic_vector(7 downto 0) := "11100000";
	constant GREEN		: std_logic_vector(7 downto 0) := "00011100";
	constant BLUE		: std_logic_vector(7 downto 0) := "00000011";
	constant CYAN		: std_logic_vector(7 downto 0) := "00011111";
	constant YELLOW		: std_logic_vector(7 downto 0) := "11111100";
	constant PURPLE		: std_logic_vector(7 downto 0) := "11100011";
	constant WHITE		: std_logic_vector(7 downto 0) := "11011011";
	constant BLACK		: std_logic_vector(7 downto 0) := "00000000";
	constant GRAY0		: std_logic_vector(7 downto 0) := "01001001";
	constant GRAY1		: std_logic_vector(7 downto 0) := "10010010";
	constant DARK_BLU	: std_logic_vector(7 downto 0) := "00001010";
	constant DARK_PUR	: std_logic_vector(7 downto 0) := "01000010";

	signal register_position : integer := 0;
    
begin

	-- set the colors based on the current pixel
process(row,column, video_on)
	begin
	if (video_on = '1') then --added control
		RAM_EN <= '1';
        register_position <= (to_integer(unsigned(row(9 downto 3)))) * 80 + (to_integer(unsigned(column(9 downto 3))));
        if row(2 downto 0) = "000" then-- if it is divisible by 8, draw a horizontal gray line
           color <= GRAY1;
        elsif column(2 downto 0) = "000" then -- if it is divisible by 8, draw a vertical gray line
           color <= GRAY1;
        else
		   if (data_in = "1") then
			 color <= BLACK;
		   else
			 color <= WHITE;
		   end if;
	    end if;
    else
    	RAM_EN <= '0';
        color <= BLACK;
    end if;
end process;
    
addr <= std_logic_vector(to_unsigned(register_position, 13));

end Behavioral;