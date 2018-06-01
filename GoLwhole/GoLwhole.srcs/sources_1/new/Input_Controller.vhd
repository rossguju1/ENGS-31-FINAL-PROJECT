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
-- Revision 0.01 - File Created 5/30
-- 5/30 10pm- trying to get all the signals to work/output correctly
-- Additional Comments:
-- 5/31 1pm- got the signals working, waveform looks good
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
           pause : in STD_LOGIC; -- slide switch
           clear : in STD_LOGIC; -- slide switch, only when paused
           enter : in STD_LOGIC;
           cursor_addr : out STD_LOGIC_VECTOR(12 downto 0);
           paused : out STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR(0 downto 0);
           RAM_EN : out STD_LOGIC;
           clear_out : out STD_LOGIC;-- need a clear output- clear only works when paused
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
signal game_tick_i : STD_LOGIC := '1';

signal counter : integer := 0;
signal paused_i : STD_LOGIC := '0';
signal data_out_i : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal RAM_EN_i : STD_LOGIC := '0';
signal clear_out_i : STD_LOGIC := '0';

begin

tick_maker: process(clk)
begin	
	if rising_edge(clk) then
        if counter = 9999999 then
            counter <= 0;
            game_tick_i <= '1';
        else
            counter <= counter + 1;
            if counter > 4999999 then
                game_tick_i <= '0';
            end if;
        end if;
    end if;
end process tick_maker;


-- do the priority and signals for inputs that come from buttons/switches
input_mode: process(clk, delete, pause, clear, enter)
begin	
	if rising_edge(clk) then
        if enter_mp = '1' then
        	if pause = '1' then
            	if clear = '1' then
                	clear_out_i <= '1';
                	RAM_EN_i <= '1';
                else
                	clear_out_i <= '0';
        			if delete = '1' then
            			data_out_i <= "0";
						RAM_EN_i <= '1';            	
            		elsif delete = '0' then
            			data_out_i <= "1";
                    	RAM_EN_i <= '1';
            		end if;
				end if;
            end if;
        else
        	clear_out_i <= '0';-- monopulses the clear_out
            RAM_EN_i <= '0';-- monopulses the RAM_EN
        end if;
    end if;
end process input_mode;


-- cursor position
cursor_position: process(clk, up_mp, down_mp, left_mp, right_mp)
begin	
	if rising_edge(clk) then
    	if up_mp = '1' then
        	if cursor_addr_i < "0000001010000" then -- 80
        		cursor_addr_i <= cursor_addr_i + "1001001110000"; -- 4720
        	else
        		cursor_addr_i <= cursor_addr_i - "0000001010000"; -- 80
        	end if;
        elsif down_mp = '1' then
        	if cursor_addr_i > "1001001110000" then -- 4720
        		cursor_addr_i <= cursor_addr_i - "1001001110000"; -- 4720
        	else
        		cursor_addr_i <= cursor_addr_i + "0000001010000"; -- 80
        	end if;
        elsif left_mp = '1' then
        	if cursor_addr_i = "0000000000000" then -- 0
        		cursor_addr_i <= "1001010111111"; -- 4799
        	else
        		cursor_addr_i <= cursor_addr_i - "0000000000001"; -- 1
        	end if;
        elsif right_mp = '1' then
        	if cursor_addr_i = "1001010111111" then -- 4799
        		cursor_addr_i <= "0000000000000"; -- 0
        	else
        		cursor_addr_i <= cursor_addr_i - "0000000000001"; -- 1
        	end if;
        end if;
    end if;
end process cursor_position;



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



game_tick <= game_tick_i;
data_out <= data_out_i;
RAM_EN <= RAM_EN_i;
cursor_addr <= STD_LOGIC_VECTOR(cursor_addr_i);
clear_out <= clear_out_i;
paused <= pause;

end Behavioral;


--end behavior;
        
        