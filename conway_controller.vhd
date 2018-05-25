-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- controller accepts imported RAM, updates RAM 1 and outputs RAM 1 to next generation
-- ( in RAM 2), and the last role for the controller is to output current state 
-- to the VGA

ENTITY controller is
port( clk : in std_logic;
		clear : in std_logic;

		--location : in std_logic_vector(12 downto 0)
        alive_or_dead : out std_logic);
END controller;

Architecture behavior of controller is



type state_type is (update_vga, update_RAM, load_init_cond);

signal current_state, next_state : state_type;


signal ROM1 is array (0 to 4800) of std_logic_vector(33 down to 0) := location;

signal ROM2 is array (0 to 4800) of std_logic_vector(33 down to 0);


-- 



BEGIN 

state_update: process(clk)
begin
	if rising_edge(clk) then
    	current_state<=next_state;
    end if;
end process state_update;


-- load_enable ~> used for importing initial cells


-- update_enable ~> 


-- register_position ~> to index the register address

-- 

signal load_VGA_enable, load_enable, update_enable : std_logic := '0';

signal register_position : std_logic_vector(3 downto 0);

signal 

update_proc : process(clk)

BEGIN
	if rising_edge(clk) then
		-- if load_VGA_enable = '1' implies RAM is ready to be written to RAM2 
		-- and for VGA to read it
		if (load_VGA_enable = '0') then

			if (update_enable = '1') then
			-- update_RAM state

				if (register_position = "0000") then



				end if;

			end if;
			--update_VGA STATE

		end if;

	end if;

end process update_proc;





