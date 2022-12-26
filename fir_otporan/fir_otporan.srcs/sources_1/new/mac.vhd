----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2022 18:11:46
-- Design Name: 
-- Module Name: mac - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mac is
    generic (WIDTH:natural:=5;
             FIXED_POINT_POSITION:natural:=3 );
    Port ( u_i : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           c_i : in STD_LOGIC_VECTOR (2 * WIDTH - 1 downto 0);
           u_o : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           c_o : out STD_LOGIC_VECTOR (2 * WIDTH - 1 downto 0));
end mac;

architecture Behavioral of mac is
component dsp
generic(WIDTH:natural:=5;
        FIXED_POINT_POSITION:natural:=3;
        SIGNED_UNSIGNED: string:= "unsigned");
Port (  clk: in std_logic;
        a_i: in std_logic_vector (WIDTH - 1 downto 0);
        b_i: in std_logic_vector (WIDTH - 1 downto 0);
        c_i: in std_logic_vector ( 2 * WIDTH - 1 downto 0);
        res_o: out std_logic_vector( 2 * WIDTH - 1 downto 0));
end component;
begin


end Behavioral;
