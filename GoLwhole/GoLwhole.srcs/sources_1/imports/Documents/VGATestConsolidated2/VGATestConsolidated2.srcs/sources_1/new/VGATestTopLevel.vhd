----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Seth Chatterton
-- 
-- Create Date: 05/27/2018 12:06:46 AM
-- Design Name: 
-- Module Name: VGATestTopLevel - Behavioral
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

-- 5/30/2018- attempting to get it to work with the game controller
-- 5/31/2018 9:30 pm- all signals mapped where they need to go
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity VGATestTopLevel is
  Port( mclk : in STD_LOGIC;
  up : in STD_LOGIC;
  down : in STD_LOGIC;
  left : in STD_LOGIC;
  right : in STD_LOGIC;
  delete : in STD_LOGIC;
  pause : in STD_LOGIC; -- slide switch
  clear : in STD_LOGIC; -- slide switch, only when paused
  enter : in STD_LOGIC;
  R1, R2, R3, G1, G2, G3, B2, B3 : out STD_LOGIC;
  V_Sync, H_Sync: out STD_LOGIC);
end VGATestTopLevel;

architecture Behavioral of VGATestTopLevel is

component game_controller is
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
END component;

component VGA is
Port(   clk	  :	    in	   STD_LOGIC; --100 MHz clock
        V_sync    :     out    STD_LOGIC;
        H_sync    :     out    STD_LOGIC;
        video_on  :     out    STD_LOGIC;
        pixel_x   :     out    STD_LOGIC_VECTOR(9 downto 0);
        pixel_y   :   out    STD_LOGIC_VECTOR(9 downto 0));
end component;


component Input_Controller is
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
           clear_out : out STD_LOGIC;
           game_tick : out STD_LOGIC);
end component;


component vga_test_pattern is
	port(row,column			: in std_logic_vector(9 downto 0);
    	data_in 			: in std_logic_vector(0 downto 0);--RAM gives a 1 bit std_logic_vector
	    video_on            : in std_logic; -- added control
	    cursor_addr         : in std_logic_vector(12 downto 0);
        --clk 				: in std_logic; -- the original vga_test_pattern was unclocked
		color				: out std_logic_vector(7 downto 0);
        --data_out			: out std_logic_vector(0 downto 0); --just for testing purposes
        addr				: out std_logic_vector(12 downto 0); -- addresses RAM
        RAM_EN				: out std_logic);
end component;

component old_state_RAM IS
  PORT (
    clka : IN STD_LOGIC;
    rsta : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    clkb : IN STD_LOGIC;
    rstb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    rsta_busy : OUT STD_LOGIC;
    rstb_busy : OUT STD_LOGIC
  );
END component;

signal RGB : STD_LOGIC_VECTOR(7 downto 0);
signal pixel_y_i : STD_LOGIC_VECTOR(9 downto 0);
signal pixel_x_i : STD_LOGIC_VECTOR(9 downto 0);
signal video_on_i : STD_LOGIC :='0';
signal RAM_EN_i : STD_LOGIC := '1';
signal addr_old_a : STD_LOGIC_VECTOR(12 downto 0) := "0000000000000";
signal data_in_vga : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal doutb_old : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal rsta_busy_i_old : STD_LOGIC := '0';
signal rstb_busy_i_old : STD_LOGIC := '0';
signal rsta_busy_i_new : STD_LOGIC := '0';
signal rstb_busy_i_new : STD_LOGIC := '0';
signal old_enb : STD_LOGIC := '0';

signal dout_a_new : STD_LOGIC_VECTOR(0 downto 0) := "0";

signal old_web : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal addr_old_b : STD_LOGIC_VECTOR := "0000000000000";
signal old_dinb : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal doutb_new : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal new_enb : STD_LOGIC := '0';

-- TO DO:
-- finish making these signals, then connect every wire to wher it is supposed to go
signal new_web : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal addr_new_b : STD_LOGIC_VECTOR(12 downto 0) := "0000000000000";
signal new_dinb : STD_LOGIC_VECTOR(0 downto 0) := "0";

signal cursor_addr_i : STD_LOGIC_VECTOR(12 downto 0) := "0000000000001"; -- set to 1 to test if red appears in right spot
signal paused_i : STD_LOGIC := '0';
signal controller_data_out : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal controller_ram_en : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal game_tick : STD_LOGIC := '0';
signal clear_out_i :STD_LOGIC := '0';
--signal up_i : STD_LOGIC := '0';
--signal down_i : STD_LOGIC := '0';
--signal left_i : STD_LOGIC := '0';
--signal right_i : STD_LOGIC := '0';

-- use this to control if input controller edits old, or game_controller edits old
signal RAM_EN_b_old_mux : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal addr_b_old_mux : STD_LOGIC_VECTOR(12 downto 0) := "0000000000000";
signal enb_old_mux : STD_LOGIC := '0';-- multiplex with input controller and game
signal web_old_mux : STD_LOGIC_VECTOR(0 downto 0) := "0";  -- 
--signal addrb_old_mux : STD_LOGIC_VECTOR := "";  --needed?
signal dinb_old_mux : STD_LOGIC_VECTOR(0 downto 0) := "0";



begin

--fill in with RAM connections
display : vga_test_pattern port map(
    row => pixel_y_i,
    column => pixel_x_i,
    data_in => data_in_vga,
    video_on => video_on_i,
    cursor_addr => cursor_addr_i,
    color => RGB,
    addr => addr_old_a,
    RAM_EN => RAM_EN_i);




timing :  VGA port map(   
        clk => mclk,
        V_sync => V_sync,
        H_sync => H_Sync,
        video_on => video_on_i,
        pixel_x => pixel_x_i,
        pixel_y => pixel_y_i);
        
        
 -- these all need ports to go to     
inputs : input_controller port map(
    clk => mclk,
    up => up,
    down => down,
    left => left,
    right => right,
    delete => delete,
    pause => pause,
    clear => clear,
    enter => enter,
    cursor_addr => cursor_addr_i,
    paused => paused_i,
    data_out => controller_data_out,
    RAM_EN => controller_ram_en(0),
    clear_out => clear_out_i,
    game_tick => game_tick
);

-- disables game controller when game is paused 
-- multiplex address, enable, write data (read data is an output)
pause_control : process(pause) 
begin
if pause = '1' then
    -- from input controller
    RAM_EN_b_old_mux <= controller_ram_en;-- this is write enable
    addr_b_old_mux <= cursor_addr_i;
    enb_old_mux <= '0'; --read enable disabled
    dinb_old_mux <= controller_data_out;  
       
else
    -- from game_controller
    RAM_EN_b_old_mux <= old_web; -- write enable
    addr_b_old_mux <= addr_old_b;
    enb_old_mux <= old_enb;-- multiplex with input controller and game
    dinb_old_mux <= old_dinb;
end if; 

end process pause_control;

old_state : old_state_RAM port map(
    clka => mclk,
    rsta => '0', -- display doesnt reset
    ena => RAM_EN_i, -- from display
    wea => "0",-- we arent writing anything to a, yet
    addra => addr_old_a, -- goes from display
    dina => "0", -- doesnt matter, since we arent writing through this port and not enabling write
    douta => data_in_vga,
    clkb => mclk,
    rstb => clear_out_i, -- only can be active when paused (from input_controller)
    enb => enb_old_mux,-- multiplex with input controller and game
    web => RAM_EN_b_old_mux,  
    addrb => addr_b_old_mux,
    dinb => dinb_old_mux, --goes to game controller
    doutb => doutb_old, 
    rsta_busy => rsta_busy_i_old,
    rstb_busy => rstb_busy_i_old
);

-- the ports below are the most likely thing to go wrong on this file
GameController : game_controller port map(
    clk => mclk,

	old_r_data => doutb_old(0),
--
	r_enable_old => old_enb,

	w_enable_old => old_web(0),

	old_r_addr => addr_old_b,

	old_w_data => old_dinb(0),

	new_r_data => doutb_new(0),

	r_enable_new => new_enb,

	w_enable_new => new_web(0),

	new_r_addr => addr_new_b,

	new_w_data => new_dinb(0),
    
    game_tick => game_tick);

-- change ports for new
new_state : old_state_RAM port map( -- second port doesnt actually get used in new_state
    clka => mclk,
    rsta => '0',
    ena => '0',--RAM_EN_i, -- should be something different
    wea => "0",-- we arent writing anything to a, yet
    addra => "0000000000000",--addr_ol_a,-- this isnt supposed to be here
    dina => "0", -- doesnt matter, since we arent writing through this port and not enabling write
    douta => dout_a_new,
    clkb => mclk,
    rstb => '0',
    enb => new_enb,
    web => new_web,
    addrb => addr_new_b,
    dinb => new_dinb,
    doutb => doutb_new,
    rsta_busy => rsta_busy_i_new,
    rstb_busy => rstb_busy_i_new
);

   
--might need to change which signals mapped to which pins
R1 <= RGB(5);
R2 <= RGB(6);
R3 <= RGB(7);
G1 <= RGB(2);
G2 <= RGB(3);
G3 <= RGB(4);
B2 <= RGB(0);
B3 <= RGB(1);

end Behavioral;
