library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;   
use IEEE.std_logic_signed.all;

entity simple_multiplier is
generic (WIDTH:natural:=17;
        FIXED_POINT_POSITION:natural:=3;
        SIGNED_UNSIGNED: string:= "unsigned");
Port (  clk_i: in std_logic;
        rst: in std_logic;
        a_i: in std_logic_vector (WIDTH - 1 downto 0);
        b_i: in std_logic_vector (WIDTH - 1 downto 0);
        c_i: in std_logic_vector ( 2 * WIDTH - 1 downto 0);
        c_o: out std_logic_vector( 2 * WIDTH - 1 downto 0));
end simple_multiplier;
architecture Behavioral of simple_multiplier is
-----------------------------------------------------------------------------------
-- Atributes that need to be defined so Vivado synthesizer maps appropriate
-- code to DSP cells
attribute use_dsp : string;
attribute use_dsp of Behavioral : architecture is "yes";
-----------------------------------------------------------------------------------
---------------------
-----------------------------------------------------------------------------------
---------------------
-- Pipeline registers.
signal a_reg_s: std_logic_vector(WIDTH - 1 downto 0);
signal b_reg_s: std_logic_vector(WIDTH - 1 downto 0);
signal c_reg_s: std_logic_vector(2 * WIDTH - 1 downto 0);
signal c1_reg_s: std_logic_vector(2 * WIDTH - 1 downto 0);
signal m_reg_s: std_logic_vector(2 * WIDTH - 1 downto 0);
signal p_reg_s: std_logic_vector(2 * WIDTH - 1 downto 0);
-----------------------------------------------------------------------------------
---------------------
begin

process (clk_i) is
begin
    if (rising_edge(clk_i))then
        if(rst = '1') then
            a_reg_s <= (others => '0');
            b_reg_s <= (others => '0');
            --c_reg_s <= (others => '0');
            --c1_reg_s <= (others => '0');
            m_reg_s <= (others => '0');
            p_reg_s <= (others => '0');
            
        else
            a_reg_s <= a_i;
            b_reg_s <= b_i;
            --c_reg_s <= c_i;
            --c1_reg_s <= c_reg_s;
            if (SIGNED_UNSIGNED = "signed") then
                m_reg_s <= std_logic_vector(signed(a_reg_s) * signed(b_reg_s));
                p_reg_s <= std_logic_vector(signed(m_reg_s) + signed(c_i));
            else
                m_reg_s <= std_logic_vector(unsigned(a_reg_s) * unsigned(b_reg_s));
                p_reg_s <= std_logic_vector(unsigned(m_reg_s) + unsigned(c_i));
            end if;
        end if;
    end if;
end process;
c_o <= p_reg_s;
-- ( (WIDTH + FIXED_POINT_POSITION - 1) downto FIXED_POINT_POSITION )
end Behavioral;
