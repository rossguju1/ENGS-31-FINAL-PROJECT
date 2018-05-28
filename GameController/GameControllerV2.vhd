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
							next_state <= request;
                        elsif (enable = '0') then
                        	next_state <= idle;
                        end if;
						
		when (request) =>  r_enable_old <= '1';

						if (position = "0000000000000") then
							if (check_counter = 0) then
								-- 4639
								old_r_addr <= "1001000011111";
								next_state <= receive;
							elsif (check_counter = 1) then 
								--4719
								old_r_addr <= "1001001101111";
								next_state <= receive;
							elsif (check_counter = 2) then 
							--4797
								old_r_addr <= "1001010111101";
								next_state <= receive;
							

							elsif (check_counter = 2) then 
							--4798
								old_r_addr <= "1001010111110";
								next_state <= receive;
							

							elsif (check_counter = 2) then 
							--4799
								old_r_addr <= "1001010111111";
								next_state <= receive;
							end if;
							

							--position = 79
						elsif (position = "0000001001111") then
							if check_counter = 0 then
								--4560
							elsif (check_counter = 2) then 
								old_r_addr <= "0000001010001";
								next_state <= receive;
								--4640
								old_r_addr <= "000001001110";
								next_state <= receive;
							elsif (check_counter = 1) then 
								--4720
								old_r_addr <= "0000010011111";
								next_state <= receive;
								--4721
							elsif (check_counter = 2) then 
								old_r_addr <= "0000001010001";
								next_state <= receive;
							--4722
							elsif (check_counter = 2) then 
								old_r_addr <= "0000001010001";
								next_state <= receive;
							end if;

							-- position = 4720
						elsif (position = "1001010111111") then
							-- 77
							if (check_counter = 2) then 
								old_r_addr <= "0000001001101";
								next_state <= receive;
						    --78
							elsif check_counter = 0 then
								old_r_addr <= "000000001110";
								next_state <= receive;

							--79
							elsif (check_counter = 1) then 
								old_r_addr <= "0000001001111";
								next_state <= receive;
							--159
							elsif (check_counter = 2) then 
								old_r_addr <= "0000010011111";
								next_state <= receive;
							--239
							elsif (check_counter = 2) then 
								old_r_addr <= "0000011101111";
								next_state <= receive;
							elsif (check_counter = 2) then 
								old_r_addr <= "1001000100000";
								next_state <= receive;
							elsif (check_counter = 2) then 
								old_r_addr <= "1001000100001";
								next_state <= receive;
							elsif (check_counter = 2) then 
								old_r_addr <= "1001001110001";
								next_state <= receive;
							elsif (check_counter = 8) then
								old_r_addr <= std_logic_vector(position);
						 		next_state <= write_update;
							end if;
				
						--4799
						elsif (position = "1001011000000") then
							--0
							if check_counter = 0 then
								old_r_addr <= "0000000000000";
								next_state <= receive;
							--1
							elsif (check_counter = 1) then 
								old_r_addr <= "0000000000001";
								next_state <= receive;
							--2
							elsif (check_counter = 2) then 
								old_r_addr <= "0000000000010";
								next_state <= receive;
							--80
							elsif (check_counter = 3) then 
								old_r_addr <= "0000001010000";
								next_state <= receive;
							--160
							elsif (check_counter = 4) then 
								old_r_addr <= "0000010100000";
								next_state <= receive;
							elsif (check_counter = 5) then
								old_r_addr <= "0000001010000";
								next_state <= receive;
							elsif (check_counter = 6) then
									old_r_addr <= "0000001001111";
									next_state <= receive;
							elsif (check_counter = 7) then
								old_r_addr <= "0000000000001";
								next_state <= receive;
							elsif (check_counter = 8) then
								old_r_addr <= std_logic_vector(position);
						 		next_state <= write_update;
							end if;


							

							end if;
						elsif (to_integer(position) > 0 and to_integer(position) < 79) then
							if (check_counter = 0) then 
	               				old_r_addr <= std_logic_vector(position + "1001001101111");
								next_state <= receive;
							elsif (check_counter = 1) then 
	                        	old_r_addr <= std_logic_vector(position + "1001001110000");
								next_state <= receive;
	                           
	                        elsif (check_counter = 2) then
								old_r_addr <= std_logic_vector(position + "1001001110001");
								next_state <= receive;
							elsif (check_counter = 3) then
								old_r_addr <= std_logic_vector(position + "0000000000001");
								next_state <= receive;
							elsif (check_counter = 4) then
								old_r_addr <= std_logic_vector(position - "0000000000001");
								next_state <= receive;
							elsif (check_counter = 5) then
								old_r_addr <= std_logic_vector(position - "0000001010001");
								next_state <= receive;
							elsif (check_counter = 6) then
								old_r_addr <= std_logic_vector(position - "0000001001110");
								next_state <= receive;
							elsif (check_counter = 7) then
								old_r_addr <= std_logic_vector(position - "0000001010000");
								next_state <= receive;
							elsif (check_counter = 8) then
								old_r_addr <= std_logic_vector(position);
						 		next_state <= write_update;
							end if;




							elsif (to_integer(position) > 4720 and to_integer(position) < 4799) then
								if (check_counter = 0) then 
		               				old_r_addr <= std_logic_vector(position - "1001001101111");
									next_state <= receive;
								elsif (check_counter = 1) then 
		                        	old_r_addr <= std_logic_vector(position - "1001001110000");
									next_state <= receive;
		                           
		                        elsif (check_counter = 2) then
									old_r_addr <= std_logic_vector(position - "1001001110001");
									next_state <= receive;
								elsif (check_counter = 3) then
									old_r_addr <= std_logic_vector(position - "0000000000001");
									next_state <= receive;
		                            
								elsif (check_counter = 4) then
									old_r_addr <= std_logic_vector(position + "0000000000001");
									next_state <= receive;
								elsif (check_counter = 5) then
									old_r_addr <= std_logic_vector(position - "0000001001111");
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
							

							if ((to_integer(position) /= 79) and (to_integer(position) mod 80 = 79) and (to_integer(position) /= 4799)) then
									-- 79 <=> -1
								if (check_counter = 0) then 
		               				old_r_addr <= std_logic_vector(position - "0000001001111");
									next_state <= receive;
								-- plus 1 <=> +79
								elsif (check_counter = 1) then 
		                        	old_r_addr <= std_logic_vector(position + "0000000000001");
									next_state <= receive;
									-- minus 159
								elsif (check_counter = 2) then 
		                        	old_r_addr <= std_logic_vector(position - "0000010011111");
									next_state <= receive;
								elsif (check_counter = 3) then 
		                        	old_r_addr <= std_logic_vector(position - "0000000000001");
									next_state <= receive;
								elsif (check_counter = 4) then 
	                        		old_r_addr <= std_logic_vector(position - "0000001010000");
									next_state <= receive;

								elsif (check_counter = 5) then 
	                        		old_r_addr <= std_logic_vector(position + "0000001010000");
									next_state <= receive;
								elsif (check_counter = 6) then 
		               				old_r_addr <= std_logic_vector(position + "0000001001110");
									next_state <= receive;
								elsif (check_counter = 7) then 
	                        		old_r_addr <= std_logic_vector(position - "0000001010001");
									next_state <= receive;
								elsif (check_counter = 8) then
									old_r_addr <= std_logic_vector(position);
						 			next_state <= write_update;
								end if;
		                           	
		                        



							if ((to_integer(position) /= 0) and (to_integer(position) mod 80 = 0) and (to_integer(position) /= 4720)) then
									-- 79
								if (check_counter = 0) then 
		               				old_r_addr <= std_logic_vector(position - "0000000000001");
									next_state <= receive;
								elsif (check_counter = 1) then 
	                        		old_r_addr <= std_logic_vector(position + "0000001001111");
									next_state <= receive;
								elsif (check_counter = 2) then 
		                        	old_r_addr <= std_logic_vector(position + "0000010011111");
									next_state <= receive;
								elsif (check_counter = 3) then 
	                        		old_r_addr <= std_logic_vector(position - "0000001010000");
									next_state <= receive;
								elsif (check_counter = 4) then 
	                        		old_r_addr <= std_logic_vector(position + "0000001010000");
									next_state <= receive;
								elsif (check_counter = 5) then 
		               				old_r_addr <= std_logic_vector(position - "0000001001110");
									next_state <= receive;
								if (check_counter = 6) then 
		               				old_r_addr <= std_logic_vector(position + "0000000000001");
									next_state <= receive;
								elsif (check_counter = 7) then 
	                        		old_r_addr <= std_logic_vector(position + "0000001010001");
									next_state <= receive;
								elsif (check_counter = 8) then
								old_r_addr <= std_logic_vector(position);
						 		next_state <= write_update;
							end if;
								end if;
						else

	        				if (check_counter = 0) then 
	               				old_r_addr <= std_logic_vector(position - "0000001010001");
								next_state <= receive;
							elsif (check_counter = 1) then 
	                        	old_r_addr <= std_logic_vector(position - "0000001010000");
								next_state <= receive;
	                           
	                        elsif (check_counter = 2) then
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








