--Revisions: v1.0 5/22: first working version with all working inputs and outputs: clk, V_SYNC, H_SYNC, video_on, pixel_x, pixel_y.
--v1.1 5/27 replaced H_Sync in processes with H_sync_i, then wired H_sync_i to H_Sync due to vivado error
-- might need to do the same to vsync
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY VGA IS
PORT ( 	clk		:	in	STD_LOGIC; --100 MHz clock
		V_sync	: 	out	STD_LOGIC;
		H_sync	: 	out	STD_LOGIC;
        video_on:	out	STD_LOGIC;
		pixel_x	:	out	STD_LOGIC_VECTOR(9 downto 0);
        pixel_y	:	out	STD_LOGIC_VECTOR(9 downto 0));
end VGA;


architecture behavior of VGA is

signal H_video_on : STD_LOGIC := '0';
signal V_video_on : STD_LOGIC := '0';
--Add your signals here
signal pclk_count : STD_LOGIC := '0';
signal PCLK : STD_LOGIC := '0';
signal h_count : integer := 0;
signal x_pos : unsigned(9 downto 0) := "0000000000";
signal rising_pclk: STD_LOGIC := '0';

signal v_count : integer := 0;
signal H_Sync_i : STD_LOGIC := '0';
signal H_Sync_last : STD_LOGIC := '0';
signal y_pos : unsigned(9 downto 0) := "0000000000";




--VGA Constants (taken directly from VGA Class Notes)

constant left_border : integer := 48;--48;--2
constant h_display : integer := 640;--640; --9
constant right_border : integer := 16;--16;--2
constant h_retrace : integer := 96;--96;--2
constant HSCAN : integer := left_border + h_display + right_border + h_retrace - 1; --number of PCLKs in an H_sync period


constant top_border : integer := 29;--29;--2
constant v_display : integer := 480;--480;--16
constant bottom_border : integer := 10;--10;--2
constant v_retrace : integer := 2;
constant VSCAN : integer := top_border + v_display + bottom_border + v_retrace - 1; --number of H_syncs in an V_sync period
BEGIN

--PCLK Generating Process
PCLK_proc : process(clk)
begin
	if rising_edge(clk) then
    --put your PCLK generation code here
    	
    	if pclk_count = '1' then
        	if PCLK = '1' then
            	PCLK <= '0';
                
            else
            	PCLK <= '1';
                rising_pclk <= '0';
            end if;   
        	pclk_count <= '0';
        else
        	if PClK <= '0' then
            	rising_pclk <= '1';
            end if;
            
        	pclk_count <= '1';
            
 
        end if;
    end if;
end process PCLK_proc;



--H_sync generating process
Hsync_proc : process(clk, PCLK)
begin
	if rising_edge(clk) then
    	--rising edge (pclk) -- fix rising edge or something for pclk
        	if rising_pclk = '1' then 
            --do rising_edge(pclk) stuff here 
        	--H_sync and H_video_on generation code goes here
        		if h_count = HSCAN then
       	 			h_count <= 0;
                    h_video_on <= '0';
                    H_SYNC_i <= '1';
        		else
                	if (h_count > (left_border - 1)) then
                  
                    	if (h_count < (left_border + h_display)) then
                        	-- if we are here, we are in the display area
                        	h_video_on <= '1';
                            H_SYNC_i <= '1';
                            if h_count = left_border then
                            	x_pos <= "0000000000";
                            else
                            	x_pos <= x_pos + 1;
                            end if;
                    	else
                        	h_video_on <= '0';
                            if (h_count > left_border + h_display + right_border - 1) then
                            	H_SYNC_i <= '0';
                              
                            else
                            	H_Sync_i <= '1';
                            end if;
                            x_pos <= "0000000000";
                    	end if;
                    else
                    	-- if we are within the left border
                    	h_video_on <= '0';
                        H_SYNC_i <= '1';
                        x_pos <= "0000000000";
                    end if;
                    
           			h_count <= h_count + 1;
                end if;
            end if;  
    end if;
end process Hsync_proc;


--V_sync generating process
Vsync_proc : process(clk)
begin
	if rising_edge(clk) then
       --V_sync and V_video_on generation code goes here
       
       --rising edge (pclk) -- fix rising edge or something for pclk
        	if ((H_Sync_last = NOT(H_Sync_i)) AND H_Sync_i = '1') then 
        	
            --do rising_edge(H_Sync) stuff here 
        	--V_sync and V_video_on generation code goes here
        		if v_count = VSCAN then
       	 			v_count <= 0;
                    v_video_on <= '0';
                    V_SYNC <= '1';
        		else
                	if (v_count > (top_border - 1)) then
                  
                    	if (v_count < (top_border + v_display)) then
                        	-- if we are here, we are in the display area
                        	v_video_on <= '1';
                            V_SYNC <= '1';
                            if v_count = top_border then
                            	y_pos <= "0000000000";
                            else
                            	y_pos <= y_pos + 1;
                            end if;
                    	else
                        	v_video_on <= '0';
                            if (v_count > top_border + v_display + bottom_border - 1) then
                            	V_SYNC <= '0';
                            else
                            	V_SYNC <= '1';
                            end if;
                            y_pos <= "0000000000";
                    	end if;
                    else
                    	-- if we are within the top border
                    	V_video_on <= '0';
                        V_SYNC <= '1';
                        y_pos <= "0000000000";
                    end if;
		
                    V_count <= V_count + 1;
                end if;
            end if;  
        H_Sync_last <= H_Sync_i;
    end if;
end process Vsync_proc;

--pixel_proc : process(video_on)
--begin
--if video_on = '1' then
	pixel_x <= STD_LOGIC_VECTOR(x_pos);
    pixel_y	<= STD_LOGIC_VECTOR(y_pos);
--else
--	pixel_x <= "0000000000";
--  pixel_y	<= "0000000000";
--end if;
--end process pixel_proc;

H_Sync <= H_Sync_i;
video_on <= H_video_on AND V_video_on; --Only enable video out when H_video_out and V_video_out are high. It's important to set the output to zero when you aren't actively displaying video. That's how the monitor determines the black level.

end behavior;
        
        