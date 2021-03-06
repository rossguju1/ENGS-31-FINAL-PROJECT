----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Ross Guju and Seth Chatterton
-- 
-- Create Date: 05/30/2018 06:22:33 AM
-- Design Name: 
-- Module Name: game_controller - Behavioral
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


-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- controller accepts imported RAM, updates RAM 1 and outputs RAM 1 to next generation
-- ( in RAM 2), and the last role for the controller is to output current state 
-- to the VGA

ENTITY game_controller is
port(clk : in std_logic;

	old_r_data : in std_logic;

	r_enable_old : out std_logic;

	w_enable_old : out std_logic;

	old_r_addr : out std_logic_vector(12 downto 0);

	old_w_data : out std_logic;

	new_r_data : in std_logic;

	r_enable_new : out std_logic;

	w_enable_new : out std_logic;

	new_r_addr : out std_logic_vector(12 downto 0);

	new_w_data : out std_logic;
    
    game_tick : in std_logic);
END game_controller;

architecture behavior of game_controller is

-------- State type and state signals declarations ------------------------------

type state_type is (start, read_update, write_update, receive, request, read_transfer, write_transfer, idle, wait_state, wait_transfer_state);
 
signal current_state, next_state : state_type;

-- Register 1D memmory and signals declaration

signal nbr_count : integer := 0;

signal check_counter : integer := 0;

signal position : unsigned(12 downto 0) := "0000000000000";

signal risingGameTick : std_logic := '0';
signal lastGameTick : std_logic := '0';



signal data_in : std_logic := '0';

signal data_out : std_logic := '0';

--signal data_switch : std_logic := '0';

begin
state_update: process(clk)
begin
	if rising_edge(clk) then
    	current_state <= next_state;
    end if;
end process state_update;


Game_tick_proc : process(clk, game_tick)
begin
	if rising_edge(clk) then
    	if game_tick = '1' then
    		if lastGameTick = '0' then
        		risingGameTick <= '1';
            else
            	risingGameTick <= '0';
            end if;
        else
        	risingGameTick <= '0';
        end if;
        lastGameTick <= game_tick;    	
    end if;
end process Game_tick_proc;


proc : process(current_state)
begin
	next_state <= current_state;
	case (current_state) is
    
		when (start) => position <= "0000000000000";
						check_counter <= 0;
                        next_state <= request;
						
		when (request) =>  r_enable_old <= '1';
        if (position < "0000001001111") then 
        	if check_counter = 0 then
            	-- position + 4721 = minus 81
            	old_r_addr <= std_logic_vector(position + "1001001110001");
                next_state <= wait_state;
            elsif check_counter = 1 then
            	old_r_addr <= std_logic_vector(position + "1001001110000");
                next_state <= wait_state;
            elsif check_counter = 2 then 
            	old_r_addr <= std_logic_vector(position + "1001001101111");
                next_state <= wait_state;
            elsif (check_counter = 3) then
				old_r_addr <= std_logic_vector(position - "0000000000001");
				next_state <= wait_state;
            elsif (check_counter = 4) then
				old_r_addr <= std_logic_vector(position + "0000000000001");
				next_state <= wait_state;
            elsif (check_counter = 5) then
                old_r_addr <= std_logic_vector(position + "0000001001111");
                next_state <= wait_state;
            elsif (check_counter = 6) then
				old_r_addr <= std_logic_vector(position + "0000001010000");
				next_state <= wait_state;
            elsif (check_counter = 7) then
				old_r_addr <= std_logic_vector(position + "0000001010001");
				next_state <= wait_state;
            elsif (check_counter = 8) then
				old_r_addr <= std_logic_vector(position);
				next_state <= wait_state;
			end if;
         elsif (position > "1001001101111") then
         		
         				if check_counter = 0 then 
               				old_r_addr <= std_logic_vector(position - "0000001010001");
							next_state <= wait_state;
						elsif check_counter = 1 then 
                        	old_r_addr <= std_logic_vector(position - "0000001010000");
							next_state <= wait_state;
                           
                        elsif check_counter = 2 then
							old_r_addr <= std_logic_vector(position - "0000001001111");
							next_state <= wait_state;
                            
						elsif (check_counter = 3) then
							old_r_addr <= std_logic_vector(position - "0000000000001");
							next_state <= wait_state;
                            
						elsif (check_counter = 4) then
							old_r_addr <= std_logic_vector(position + "0000000000001");
							next_state <= wait_state;
                        elsif (check_counter = 5) then
                        	old_r_addr <= std_logic_vector(position - "1001001110000");
                            next_state <= wait_state;
                        elsif (check_counter = 6) then
							old_r_addr <= std_logic_vector(position - "1001001110001");
							next_state <= wait_state;
                            
						elsif (check_counter = 7) then
							old_r_addr <= std_logic_vector(position - "1001001101111");
							next_state <= wait_state;
                            
						elsif (check_counter = 8) then
							old_r_addr <= std_logic_vector(position);
					 		next_state <= wait_state;
						end if;
        
        		else
        				if check_counter = 0 then 
               				old_r_addr <= std_logic_vector(position - "0000001010001");
							next_state <= wait_state;
						elsif check_counter = 1 then 
                        	old_r_addr <= std_logic_vector(position - "0000001010000");
							next_state <= wait_state;
                           
                        elsif check_counter = 2 then
							old_r_addr <= std_logic_vector(position - "0000001001111");
							next_state <= wait_state;
                            
						elsif (check_counter = 3) then
							old_r_addr <= std_logic_vector(position - "0000000000001");
							next_state <= wait_state;
                            
						elsif (check_counter = 4) then
							old_r_addr <= std_logic_vector(position + "0000000000001");
							next_state <= wait_state;
                        elsif (check_counter = 5) then
                        	old_r_addr <= std_logic_vector(position + "0000001001111");
                            next_state <= wait_state;
                        elsif (check_counter = 6) then
							old_r_addr <= std_logic_vector(position + "0000001010000");
							next_state <= wait_state;
                            
						elsif (check_counter = 7) then
							old_r_addr <= std_logic_vector(position + "0000001010001");
							next_state <= wait_state;
                            
						elsif (check_counter = 8) then
							old_r_addr <= std_logic_vector(position);
					 		next_state <= wait_state;
						end if;
                   end if;
        when(wait_state) => if (check_counter < 8) then 
        						next_state <= request;
                            elsif(check_counter = 8) then
                            	next_state <= write_update;
                            end if;
                        
			--just request address and set equal to out read addresss
			-- recieved data of address, use logic to increment nbr_counter
		when (receive) => if (old_r_data = '1') then
							nbr_count <= nbr_count + 1;
                            end if;
							check_counter <= check_counter + 1;
                            next_state <= request;

		when (write_update) => w_enable_new <= '1';
        						new_r_addr <= std_logic_vector(position);
                                if (old_r_data = '1') then
                                	if (nbr_count = 2) then
                                    	new_w_data <= '1';
                                    elsif (nbr_count = 3) then
                                    	new_w_data <= '1';
                                    else
										new_w_data <= '0';
                                    end if;
                                elsif (old_r_data = '0') then
									if (nbr_count = 2) then
										new_w_data <= '1';
                                    else
										new_w_data <= '0';
									end if;
                                end if;
                                
								if (position = "1001011000000") then
                                	position <= "0000000000000";
									next_state <= read_transfer;
                                else 
                                	check_counter <= 0;
                                    nbr_count <= 0;
                               		position <= position + 1;
                                	next_state <= request;
                              	end if;
        when (read_transfer) => r_enable_new <= '1';
        						new_r_addr <= std_logic_vector(position);
                                next_state <= wait_transfer_state;
                                
       	when (wait_transfer_state) => next_state <= write_transfer;

		when (write_transfer) => if (position = "1001010111111") then
        							next_state <= idle;
                                 else
									w_enable_old <= '1';
                                    old_r_addr <= std_logic_vector(position);
									old_w_data <= new_r_data;
									position <= position + 1;
                                    next_state <= read_transfer;
                               end if;
		when idle => if (risingGameTick = '1') then
        				next_state <= start;
                     end if; 
		when others => next_state <= idle;

	end case;
    
	
end process;
	--data_in <= new_w_data;

	--data_out <= old_w_data;
end behavior;
