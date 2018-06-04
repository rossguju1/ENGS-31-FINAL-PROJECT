----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Ross Guju and Seth Chatterton
-- 
-- Create Date: 05/25/2018 03:13 PM
-- Design Name: 
-- Module Name: game_controller - Behavioral
-- Project Name: Game of Life
-- Target Devices: Baysis 3
-- Tool Versions: 
-- Description: This is the Game of life controller that operates the rules of the game
--              and transfers the data from new_state RAM to old_state RAM
-- 
-- Dependencies: 
-- 
-- Revision:

--v6.4:0212 -> all commented 
--v5.29:0802 -> added more edge cases in request state
--v5.28:1206 -> gamecontroller works, but still need specefic cases
--v5.28:1202 -> redesigned state machine
--v5.28:1041 -> re-coded request state
--v5.28:0703 -> building controller
--v5.25:1513 -> building controller

-- Additional Comments:
-- The first half of the state machine uses the game rules to write the next generation to new_state RAM
-- once compelete the rest of the state machine transfers the new_state memory to old_state memory 
-- which completes an whole iteration of the game
----------------------------------------------------------------------------------



library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


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

type state_type is (start, read_update, write_update, receive, request, read_transfer, write_transfer, idle);
 
signal current_state, next_state : state_type := start;

-- signals for 1D memmory RAM control and internal signals declaration

signal nbr_count : integer := 0;

signal check_counter : integer := 0;

signal position : unsigned(12 downto 0) := "0000000000000";

signal risingGameTick : std_logic := '0';

signal lastGameTick : std_logic := '0';



signal r_enable_old_i : std_logic := '0';

signal w_enable_old_i : std_logic := '0';

signal old_r_addr_i : std_logic_vector(12 downto 0) := "0000000000000";

signal old_w_data_i : std_logic := '0';


signal r_enable_new_i : std_logic := '0';

signal w_enable_new_i : std_logic := '0';

signal new_r_addr_i : std_logic_vector(12 downto 0) := "0000000000000";

signal new_w_data_i : std_logic := '0';
    


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




-- proc is the game_controller process

proc : process(clk, current_state)
begin
if rising_edge(clk) then 
    --next_state <= current_state;
    case (current_state) is
    
        when (start) => position <= "0000000000000";
                        check_counter <= 0;
                        next_state <= request;
                        
        when (request) =>  r_enable_old_i <= '1';
                           w_enable_new_i <= '0'; 
        if (position =  "0000000000000") then 
                    if (check_counter = 0) then
                        -- get value in address 4721
                        old_r_addr_i <= std_logic_vector("1001001110001");
                        next_state <= receive;
                        --get value in address 4720
                    elsif (check_counter = 1) then
                        old_r_addr_i <= std_logic_vector("1001001110000");
                        next_state <= receive;
                        --get value in address 4719
                    elsif (check_counter = 2) then 
                        old_r_addr_i <= std_logic_vector("1001001101111");
                        next_state <= receive;
                        --get value in address 4799
                    elsif (check_counter = 3) then
                        old_r_addr_i <= std_logic_vector("1001010111111");
                        next_state <= receive;
                        --get value in address 1
                    elsif (check_counter = 4) then
                        old_r_addr_i <= std_logic_vector("0000000000001");
                        next_state <= receive;
                        -- get value in address 79
                    elsif (check_counter = 5) then
                        old_r_addr_i <= std_logic_vector("0000001001111");
                        next_state <= receive;
                        -- get value in address 80
                    elsif (check_counter = 6) then
                        old_r_addr_i <= std_logic_vector("0000001010000");
                        next_state <= receive;
                        -- get value in address 81
                    elsif (check_counter = 7) then
                        old_r_addr_i <= std_logic_vector("0000001010001");
                        next_state <= receive;
                        -- once check_counter hits 8, now get value at target cell
                    elsif (check_counter = 8) then
                        old_r_addr_i <= std_logic_vector(position);
                        next_state <= write_update;
                    end if;
                    -- if position is 4799
        elsif (position = "1001010111111") then 
        		--get value in address 4718 (4799 - 81)
             		if (check_counter = 0) then 
                            old_r_addr_i <= std_logic_vector(position - "0000001010001");
                            next_state <= receive;
                --get value in address 4719 (4799 - 80)
                    elsif check_counter = 1 then 
                            old_r_addr_i <= std_logic_vector(position - "0000001010000");
                            next_state <= receive;
                --get value in address 4720 (4799 - 79                  
                    elsif check_counter = 2 then
                            old_r_addr_i <= std_logic_vector(position - "0000001001111");
                            next_state <= receive;
                 --get value in address 4798
                    elsif (check_counter = 3) then
                            old_r_addr_i <= std_logic_vector(position - "0000000000001");
                            next_state <= receive;
                 --get value in address 0              
                    elsif (check_counter = 4) then
                            old_r_addr_i <= std_logic_vector("0000000000000");
                            next_state <= receive;
                 --get value in address 79 (4799 - 4720)           
                    elsif (check_counter = 5) then
                            old_r_addr_i <= std_logic_vector(position - "1001001110000");
                            next_state <= receive;
                 --get value in address 80 (4799 - 4719)
                    elsif (check_counter = 6) then
                            old_r_addr_i <= std_logic_vector(position - "1001001101111");
                            next_state <= receive;
                 --get value in address 81 (4799 - 4718)
                    elsif (check_counter = 7) then
                            old_r_addr_i <= std_logic_vector(position - "1001001101110");
                            next_state <= receive;
                    elsif (check_counter = 8) then
                            old_r_addr_i <= std_logic_vector(position);
                            next_state <= write_update;
                     end if;
            -- if position is less than 79 (top row)
        elsif (position < "0000001001111") then 
        	-- get value at address position + 4721
            if (check_counter = 0) then
                old_r_addr_i <= std_logic_vector(position + "1001001110001");
                next_state <= receive;
           -- get value at address position + 4720
            elsif (check_counter = 1) then
                old_r_addr_i <= std_logic_vector(position + "1001001110000");
                next_state <= receive;
            -- get value at address position + 4719
            elsif (check_counter = 2) then 
                old_r_addr_i <= std_logic_vector(position + "1001001101111");
                next_state <= receive;
             -- get value at address position - 1    
            elsif (check_counter = 3) then
                old_r_addr_i <= std_logic_vector(position - "0000000000001");
                next_state <= receive;
            -- get value at address position + 1
            elsif (check_counter = 4) then
                old_r_addr_i <= std_logic_vector(position + "0000000000001");
                next_state <= receive;
              -- get value at address position + 79
            elsif (check_counter = 5) then
                old_r_addr_i <= std_logic_vector(position + "0000001001111");
                next_state <= receive;
             -- get value at address position + 80   
            elsif (check_counter = 6) then
                old_r_addr_i <= std_logic_vector(position + "0000001010000");
                next_state <= receive;
              -- get value at address position + 81
            elsif (check_counter = 7) then
                old_r_addr_i <= std_logic_vector(position + "0000001010001");
                next_state <= receive;
              -- get value at target cell
            elsif (check_counter = 8) then
                old_r_addr_i <= std_logic_vector(position);
                next_state <= write_update;
            end if;
         -- if position is greater than 4719, ie all positions in the last row
         elsif (position > "1001001101111") then
         -- get value at position - 81
            if (check_counter = 0) then 
                    old_r_addr_i <= std_logic_vector(position - "0000001010001");
                    next_state <= receive;
             -- get value at position - 80
            elsif check_counter = 1 then 
                    old_r_addr_i <= std_logic_vector(position - "0000001010000");
                    next_state <= receive;
            -- get value at position - 79               
            elsif check_counter = 2 then
                    old_r_addr_i <= std_logic_vector(position - "0000001001111");
                    next_state <= receive;
            -- get value at position + 1                
            elsif (check_counter = 3) then
                    old_r_addr_i <= std_logic_vector(position + "0000000000001");
                    next_state <= receive;
            -- get value at position - 1                   
            elsif (check_counter = 4) then
                    old_r_addr_i <= std_logic_vector(position - "0000000000001");
                    next_state <= receive;
           -- get value at position - 4720   
            elsif (check_counter = 5) then
                    old_r_addr_i <= std_logic_vector(position - "1001001110000");
                    next_state <= receive;
           -- get value at position - 4721
            elsif (check_counter = 6) then
                    old_r_addr_i <= std_logic_vector(position - "1001001110001");
                    next_state <= receive;
           -- get value at position - 4719
            elsif (check_counter = 7) then
                    old_r_addr_i <= std_logic_vector(position - "1001001101111");
                    next_state <= receive;
            -- get value at target cell
            elsif (check_counter = 8) then
                    old_r_addr_i <= std_logic_vector(position);
                    next_state <= write_update;
            end if;
            -- for all non-edge case position, check the 8 cells around the target cell
            else
            -- get value at position - 81
                if (check_counter = 0) then 
                    old_r_addr_i <= std_logic_vector(position - "0000001010001");
                    next_state <= receive;
             -- get value at position 80
                elsif (check_counter = 1) then 
                    old_r_addr_i <= std_logic_vector(position - "0000001010000");
                    next_state <= receive;
             -- get value at position 79
                elsif (check_counter = 2) then
                    old_r_addr_i <= std_logic_vector(position - "0000001001111");
                    next_state <= receive;
             -- get value at position - 1
                elsif (check_counter = 3) then
                    old_r_addr_i <= std_logic_vector(position - "0000000000001");
                    next_state <= receive;
             --get value at position + 1
                elsif (check_counter = 4) then
                    old_r_addr_i <= std_logic_vector(position + "0000000000001");
                    next_state <= receive;
             --get value at position + 79
                elsif (check_counter = 5) then
                    old_r_addr_i <= std_logic_vector(position + "0000001001111");
                    next_state <= receive;
              --get value at position + 80
                elsif (check_counter = 6) then
                    old_r_addr_i <= std_logic_vector(position + "0000001010000");
                    next_state <= receive;
              --get value at position + 81
                elsif (check_counter = 7) then
                    old_r_addr_i <= std_logic_vector(position + "0000001010001");
                    next_state <= receive;
                elsif (check_counter = 8) then
                    old_r_addr_i <= std_logic_vector(position);
                    next_state <= write_update;
                    end if;
                end if;
    
       		        
            			-- old_r_data is the data value from the address in request state
       when (receive) => if (old_r_data = '1') then
       						-- increase neighbor count by one
                            nbr_count <= nbr_count + 1;
                            -- increase check_counter to get other neighbor values
                            check_counter <= check_counter + 1;
                            next_state <= request;
                          else
                            check_counter <= check_counter + 1;
                            next_state <= request;
                          end if;

						--after checking the 8 neighboring cells, determine if target
                        -- cell should be alive or dead
        when (write_update) => w_enable_new_i <= '1';
                                 r_enable_new_i <= '0';
                                 r_enable_old_i <= '0';
                                 --write the new value dead or alive to the next generation memory
                                new_r_addr_i <= std_logic_vector(position);
                                -- if target cell is currently alive
                                if (old_r_data = '1') then
                                -- if 2 nbrs are alive, target cell is alive
                                    if (nbr_count = 2) then
                                        new_w_data_i <= '1';
                                -- if 3 nbrs are alive, target cell is alive  
                                    elsif (nbr_count = 3) then
                                        new_w_data_i <= '1';
                                        
                                    else
                                    -- target cell is dead
                                        new_w_data_i <= '0';
                                    end if;
                                    -- if target cell is currently dead
                                elsif (old_r_data = '0') then
                                -- if 3 nbr cells are alive, cell stays alive
                                    if (nbr_count = 3) then
                                        new_w_data_i <= '1';
                                    else
                                    -- target cell is dead
                                        new_w_data_i <= '0';
                                    end if;
                                end if;
                                --position is 4799, we have completed the next generation
                                if (position = "1001010111111") then
                                    position <= "0000000000000";
                                    -- now copy new_state RAM to old_state RAM
                                    next_state <= read_transfer;
                                else 
                                -- get the next target cell and check its neighbors
                                    check_counter <= 0;
                                    nbr_count <= 0;
                                    position <= position + 1;
                                    next_state <= request;
                                end if;
                    -- read the new_state memory and copy it over to old_state memory
        when (read_transfer) => r_enable_new_i <= '1';
                                w_enable_old_i <= '0';
                                --address of new_state memory
                                new_r_addr_i <= std_logic_vector(position);
                                next_state <= write_transfer;
                                
        --when (wait_transfer_state) => next_state <= write_transfer;

        when (write_transfer) =>  w_enable_old_i <= '1';
                                  r_enable_new_i <= '0';
                                  -- at position 4799, we completed memory transfer
                                 if (position = "1001010111111") then
                                 -- write the last position 4799 to old state memory
                                      old_r_addr_i <= std_logic_vector(position);
                                      old_w_data_i <= new_r_data;
                                      position <= "0000000000000";
                                      next_state <= idle;
                                 else
                                    -- write new_state value/address in old_state value/address
                                    old_r_addr_i <= std_logic_vector(position);
                                    old_w_data_i <= new_r_data;
                                    position <= position + 1;
                                    next_state <= read_transfer;
                               end if;
                   -- once memory is transfered, the next generation is read to be read by VGA
        when (idle) => if (risingGameTick = '1') then   
                     r_enable_new_i <= '0';
                     w_enable_old_i <= '0';               
                     next_state <= start;     
                     end if; 
                     
        when others => next_state <= idle;
    end case;
end if;

end process;


    r_enable_old <= r_enable_old_i;

    w_enable_old <= w_enable_old_i;

    old_r_addr <= old_r_addr_i;

    old_w_data <= old_w_data_i;


    r_enable_new <= r_enable_new_i;

    w_enable_new <= w_enable_new_i;

    new_r_addr <= new_r_addr_i;


end behavior;
