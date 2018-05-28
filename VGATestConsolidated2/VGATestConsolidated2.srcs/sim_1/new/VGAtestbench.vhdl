----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/27/2018 04:02:50 PM
-- Design Name: 
-- Module Name: VGAtestbench - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity VGAtestbench is
end VGAtestbench;



architecture testbench of VGAtestbench is

component VGATestTopLevel is
    Port ( mclk : in STD_LOGIC;
           R1 : out STD_LOGIC;
           R2 : out STD_LOGIC;
           R3 : out STD_LOGIC;
           G1 : out STD_LOGIC;
           G2 : out STD_LOGIC;
           G3 : out STD_LOGIC;
           B2 : out STD_LOGIC;
           B3 : out STD_LOGIC;
           V_Sync : out STD_LOGIC;
           H_Sync : out STD_LOGIC);
end component;

signal mclk : STD_LOGIC;
signal R1 : STD_LOGIC;
signal R2 : STD_LOGIC;
signal R3 : STD_LOGIC;
signal G1 : STD_LOGIC;
signal G2 : STD_LOGIC;
signal G3 : STD_LOGIC;
signal B2 : STD_LOGIC;
signal B3 : STD_LOGIC;
signal V_Sync : STD_LOGIC;
signal H_Sync : STD_LOGIC;

begin

uut : VGATestTopLevel port map(
           mclk => mclk,
           R1 => R1,
           R2 => R2,
           R3 => R3,
           G1 => G1,
           G2 => G2,
           G3 => G3,
           B2 => B2,
           B3 => B3,
           V_Sync => V_Sync,
           H_Sync => H_sync);

clk_proc : process
BEGIN

  MCLK <= '0';
  wait for 5 ns;   

  MCLK <= '1';
  wait for 5 ns;

END PROCESS clk_proc;

end testbench;
