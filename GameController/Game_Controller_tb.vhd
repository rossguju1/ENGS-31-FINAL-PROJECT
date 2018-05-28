-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;

ENTITY game_controller_tb is
end game_controller_tb;


architecture testbench of game_controller_tb is

component game_controller IS
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
end component;

signal clk : std_logic;

signal old_r_data: std_logic := '0';

signal r_enable_old : std_logic := '0';

signal w_enable_old : std_logic := '0';

signal old_r_addr : std_logic_vector(12 downto 0) := "0000000000000";

signal old_w_data : std_logic := '0';

signal new_r_data : std_logic := '0';

signal r_enable_new : std_logic := '0';

signal w_enable_new : std_logic := '0';

signal enable : std_logic := '0';

signal new_r_addr : std_logic_vector(12 downto 0) := "0000000000000";

signal new_w_data : std_logic := '1';

begin

uut : game_controller PORT MAP(
    clk => clk,
    
        old_r_data => old_r_data,
        
        r_enable_old => r_enable_old,
        
        w_enable_old => w_enable_old,
        
        old_r_addr => old_r_addr,
        
        old_w_data => old_w_data,
        
        new_r_data => new_r_data,
        
        r_enable_new => r_enable_new,
        
        w_enable_new => w_enable_new,
        
        new_r_addr => new_r_addr,
        
        new_w_data => new_w_data,
        
        enable => enable);
    
    
clk_proc : process
BEGIN

  clk <= '0';
  wait for 5ns;   

  clk <= '1';
  wait for 5ns;

END PROCESS clk_proc;

stim_proc : process
begin

  enable <= '1';
  old_r_data <= '0';
    new_r_data <= '0';
    
    wait for 10 ns;
    enable <= '1';
  old_r_data <= '1';
    new_r_data <= '1';

    wait;
end process stim_proc;


end testbench;


-------- State type and state signals declar






