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
c
--------- onstants for grid ----------------------------------------------------

constant columnNum : integer := 80;

constant rowNum : integer := 60;  

constant gridSize : integer := (columns * rows); 


-------- Constants for neighboring organisms positions in a cell ---------------


--------
--xoo---
--o*o---
--ooo---
--------



constant topLeft : integer := (columnNum - 1); 

--------
--oxo---
--o*o---
--ooo---
--------

constant topMiddle : integer := (columnNum); 

--------
--oox---
--o*o---
--ooo---
--------

constant topRight : integer := (columnNum + 1); 

--------
--ooo---
--x*o---
--ooo---
--------


constant middleLeft : integer := 1; 


--------
--ooo---
--o*x---
--ooo---
--------

constant middleRight : integer := 1; 

--------
--ooo---
--o*o---
--xoo---
--------

constant bottomLeft : integer := (columnNum - 1);

--------
--ooo---
--o*o---
--oxo---
--------

constant bottomMiddle : <type> := (columnNum); 

--------
--ooo---
--o*o---
--oox---
--------

constant bottonRight : <type> := (columnNum + 1); 




-------- State type and state signals declarations ------------------------------


type state_type is (update_vga, update_RAM, load_init_cond);

signal current_state, next_state : state_type;


-------- Register 1D memmory and signals declaration ----------------------------

type register_memory is array(0 to gridSize) of std_logic;


signal RAM1, RAM2 : register_memory;


-------- Declaration and initialization of Process Signals ----------------------

signal register_position : integer := 0;


signal load_VGA_enable, load_enable, read_enable : std_logic := '0';

signal nbr_count : unsigned(3 downto 0) := "0000";

-------- state_update process ----------------------------------------------------

BEGIN 

state_update: process(clk)
begin
	if rising_edge(clk) then
    	current_state <= next_state;
    end if;
end process state_update;





update_proc : process(clk)

--variable position : integer := 0;

BEGIN
	if rising_edge(clk) then
		-- if load_VGA_enable = '1' implies RAM is ready to be written to RAM2 
		-- and for VGA to read it
		if (load_VGA_enable = '0') then

			if (read_enable = '1') then
			-- update_RAM state
				if (register_position < 9) then 

					if (RAM1(register_position + 1) = '1') then 

						nbr_count <= nbr_count + 1;
					end if;
				-- only add

					if (RAM1(register_position + (columnNum - 1)) = '1') then 	

						nbr_count <= nbr_count + 1;
					end if; 

					if (RAM1(register_position + columnNum) = '1') then 

						nbr_count <= nbr_count + 1;
					end if;

					if (RAM1(register_position + (columnNum + 1)) = '1') then 

						nbr_count <= nbr_count + 1;
					end if; 			 									

				elsif (register_position > 90) then

					if (RAM1(register_position - 1) = '1') then

						nbr_count <= nbr_count + 1;
					end if;

					if (RAM1(register_position - (columnNum - 1) ) = '1') then

						nbr_count <= nbr_count + 1;
					end if;

					if (RAM1(register_position - 10) = '1') then

						nbr_count <= nbr_count + 1;
					end if;

					if (RAM1(register_position - (columnNum + 1)) = '1') then

						nbr_count <= nbr_count + 1;
					end if;

				-- only subtr

				else 

					if (RAM1(register_position - 1) = '1') then

						nbr_count <= nbr_count + 1;
					end if;

					if (RAM1(register_position - (columnNum - 1)) = '1') then

						nbr_count <= nbr_count + 1;
					end if;

					if (RAM1(register_position - (columnNum)) = '1') then

						nbr_count <= nbr_count + 1;
					end if;	

					if (RAM1(register_position - (columnNum + 1)) = '1') then

						nbr_count <= nbr_count + 1;
					end if;


					if (RAM1(register_position + 1) = '1') then

		 				nbr_count <= nbr_count + 1;
					end if;

					if (RAM1(register_position + (columnNum - 1)) = '1') then

						nbr_count <= nbr_count + 1;
					end if;

					if (RAM1(register_position + columnNum) = '1') then

						nbr_count <= nbr_count + 1;
					end if;

					if (RAM1(register_position + (columnNum + 1)) = '1') then

						nbr_count <= nbr_count + 1;
					end if;

				end if;


			if (RAM1(register_position) = '1') then

				if (nbr_count = "0010") then

						RAM2(register_position) <= '1';

				elsif (nbr_count = "0011") then

					RAM2(register_position) <= '1';

				else

					RAM2(register_position) <= '0';

				end if;

			elsif (RAM1(register_position) = '0') then

				if (nbr_count = "0011") then

					RAM2(register_position) <= '1';

				end if;

			end if;


					

			register_position = register_position + 1;






				end if;

			end if;
			--update_VGA STATE

		end if;

	end if;

end process update_proc;






