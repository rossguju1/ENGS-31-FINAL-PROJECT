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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Input_Controller is
    Port ( clk : in STD_LOGIC;
           up : in STD_LOGIC;
           down : in STD_LOGIC;
           left : in STD_LOGIC;
           right : in STD_LOGIC;
           delete : in STD_LOGIC;
           pause : in STD_LOGIC;
           clear : in STD_LOGIC;
           enter : in STD_LOGIC;
           cursor_addr : out STD_LOGIC_VECTOR(12 downto 0);
           paused : out STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR(0 downto 0);
           RAM_EN : out STD_LOGIC;
           game_tick : out STD_LOGIC);
end Input_Controller;



architecture Behavioral of Input_Controller is

signal cursor_addr_i : unsigned(12 downto 0) := "0000000000000";
signal enter_sync : STD_LOGIC_VECTOR(1 downto 0) := "00";
signal enter_mp : STD_LOGIC := '0';
signal up_sync : STD_LOGIC_VECTOR(1 downto 0) := "00";
signal up_mp : STD_LOGIC := '0';
signal down_sync : STD_LOGIC_VECTOR(1 downto 0) := "00";
signal down_mp : STD_LOGIC := '0';
signal left_sync : STD_LOGIC_VECTOR(1 downto 0) := "00";
signal left_mp : STD_LOGIC := '0';
signal right_sync : STD_LOGIC_VECTOR(1 downto 0) := "00";
signal right_mp : STD_LOGIC := '0';

signal counter : integer := 0;


begin

tick_maker: process(clk)
begin	
	if rising_edge(clk) then
        if counter = 9999999 then
            counter <= 0;
            game_tick <= '1';
        else
            counter <= counter + 1;
            if counter > 4999999 then
                game_tick <= '0';
            end if;
        end if;
    end if;
end process tick_maker;






-- from lab 4
monopulser: process(clk, up_sync, down_sync, left_sync, right_sync, enter_sync)
begin	
	if rising_edge(clk) then	
		up_sync <= up & up_sync(1);	
		down_sync <= down & down_sync(1);
		left_sync <= left & left_sync(1);
		right_sync <= right & right_sync(1);
		enter_sync <= enter & enter_sync(1);
		
	end if;
	
	    up_mp <= up_sync(1) and not up_sync(0);	
        down_mp <= down_sync(1) and not down_sync(0);	
        left_mp <= left_sync(1) and not left_sync(0);	
        right_mp <= right_sync(1) and not right_sync(0);	
        enter_mp <= enter_sync(1) and not enter_sync(0);	
        
end process monopulser;

--CHANGE THES OR IT WONT WORK
data_out <= "0";
cursor_addr <= "0000000000000";

end Behavioral;
