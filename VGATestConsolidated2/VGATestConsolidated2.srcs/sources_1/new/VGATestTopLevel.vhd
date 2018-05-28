----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Seth Chatterton
-- 
-- Create Date: 05/27/2018 12:06:46 AM
-- Design Name: 
-- Module Name: VGATestTopLevel - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity VGATestTopLevel is
  Port( mclk : in STD_LOGIC;
  R1, R2, R3, G1, G2, G3, B2, B3 : out STD_LOGIC;
  V_Sync, H_Sync: out STD_LOGIC);
end VGATestTopLevel;

architecture Behavioral of VGATestTopLevel is

component VGA is
Port(   clk	  :	    in	   STD_LOGIC; --100 MHz clock
        V_sync    :     out    STD_LOGIC;
        H_sync    :     out    STD_LOGIC;
        video_on  :     out    STD_LOGIC;
        pixel_x   :     out    STD_LOGIC_VECTOR(9 downto 0);
        pixel_y   :   out    STD_LOGIC_VECTOR(9 downto 0));
end component;


component vga_test_pattern is
	port( row, column			: in std_logic_vector(9 downto 0);
	      video_on             : in std_logic; -- added control
		  color					: out std_logic_vector(7 downto 0));
end component;

signal RGB : STD_LOGIC_VECTOR(7 downto 0);
signal pixel_y_i : STD_LOGIC_VECTOR(9 downto 0);
signal pixel_x_i : STD_LOGIC_VECTOR(9 downto 0);
signal video_on_i : STD_LOGIC :='0';

begin

display : vga_test_pattern port map(
    row => pixel_y_i,
    column => pixel_x_i,
    video_on => video_on_i,
    color => RGB);

timing :  VGA port map(   
        clk => mclk,
        V_sync => V_sync,
        H_sync => H_Sync,
        video_on => video_on_i,
        pixel_x => pixel_x_i,
        pixel_y => pixel_y_i);
        
--might need to change which signals mapped to which pins
R1 <= RGB(5);
R2 <= RGB(6);
R3 <= RGB(7);
G1 <= RGB(2);
G2 <= RGB(3);
G3 <= RGB(4);
B2 <= RGB(0);
B3 <= RGB(1);

end Behavioral;
