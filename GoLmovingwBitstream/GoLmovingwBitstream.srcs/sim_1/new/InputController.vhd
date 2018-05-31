----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/30/2018 05:05:59 AM
-- Design Name: 
-- Module Name: InputController - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity InputController is
    Port ( up : in STD_LOGIC;
           down : in STD_LOGIC;
           left : in STD_LOGIC;
           right : in STD_LOGIC;
           delete : in STD_LOGIC;
           pause : in STD_LOGIC;
           clear : in STD_LOGIC;
           enter : in STD_LOGIC;
           cursor_addr : out STD_LOGIC;
           paused : out STD_LOGIC;
           data_out : out STD_LOGIC;
           RAM_EN : out STD_LOGIC;
           game_tick : out STD_LOGIC);
end InputController;

architecture Behavioral of InputController is

begin


end Behavioral;
