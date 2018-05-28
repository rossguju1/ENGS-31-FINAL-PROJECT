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
    
    enable : in std_logic);
END game_controller;

architecture behavior of game_controller is

-------- State type and state signals declarations ------------------------------

type state_type is (start, read_update, write_update, receive, request, read_transfer, write_transfer, idle);
 
signal current_state, next_state : state_type;

-- Register 1D memmory and signals declaration

signal nbr_count : integer := 0;

signal check_counter : integer := 0;

signal position : unsigned(12 downto 0) := "0000000000000";



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

proc : process(current_state)
begin
	next_state <= current_state;
	case (current_state) is
    
		when (start) => if (enable = '1') then
        					position <= "0000000000000";
							check_counter <= 0;
                        end if;
                        next_state <= request;
						
		when (request) =>  r_enable_old <= '1';
        				if check_counter = 0 then 
               				old_r_addr <= std_logic_vector(position - "0000001010001");
							next_state <= receive;
						elsif check_counter = 1 then 
                        	old_r_addr <= std_logic_vector(position - "0000001010000");
							next_state <= receive;
                           
                        elsif check_counter = 2 then
							old_r_addr <= std_logic_vector(position - "0000001001111");
							next_state <= receive;
                            
						elsif (check_counter = 3) then
							old_r_addr <= std_logic_vector(position - "0000000000001");
							next_state <= receive;
                            
						elsif (check_counter = 4) then
							old_r_addr <= std_logic_vector(position + "0000000000001");
							next_state <= receive;
                        elsif (check_counter = 5) then
                        	old_r_addr <= std_logic_vector(position + "0000001001111");
                            next_state <= receive;
                        elsif (check_counter = 6) then
							old_r_addr <= std_logic_vector(position + "0000001010000");
							next_state <= receive;
                            
						elsif (check_counter = 7) then
							old_r_addr <= std_logic_vector(position + "0000001010001");
							next_state <= receive;
                            
						elsif (check_counter = 8) then
							old_r_addr <= std_logic_vector(position);
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
                               		position <= position + 1;
                                	next_state <= request;
                              	end if;
        when (read_transfer) => r_enable_new <= '1';
        						new_r_addr <= std_logic_vector(position);
                                next_state <= write_transfer;

		when (write_transfer) => if (position = "1001011000000") then
        							next_state <= idle;
                                 else
									w_enable_old <= '1';
                                    old_r_addr <= std_logic_vector(position);
									old_w_data <= new_r_data;
									position <= position + 1;
                                    next_state <= read_transfer;
                                 end if;
		when idle => if (enable = '1') then
        				next_state <= start;
                     end if; 
		when others => next_state <= idle;

	end case;
    
	
end process;
	--data_in <= new_w_data;

	--data_out <= old_w_data;
end behavior;








