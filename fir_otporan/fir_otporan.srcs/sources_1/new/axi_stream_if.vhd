library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--! @brief Config RTL Design
--!
--! @details
--! This core sends out the given control word to the connected ip block
entity config is
  Generic (
    WIDTH : natural := 1 --! Width of TDATA in number of bytes
  );
  Port ( 
    m_axis_tdata : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
    m_axis_tvalid : out STD_LOGIC;
    m_axis_tready : in STD_LOGIC;
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC
  );
end config;
architecture Behavioral of config is
  signal done : std_logic := '0'; --! 1 if config is configured, 0 otherwise
  signal m_axis_tvalid_reg : std_logic := '0';
begin
  m_axis_tdata <= C_TDATA_VALUE(WIDTH - 1 downto 0);
  m_axis_tvalid <= m_axis_tvalid_reg;
  process(aclk) begin
    if rising_edge(aclk) then
      if aresetn /= '1' then
        done <= '0';
        m_axis_tvalid_reg <= '0';
      elsif (done = '1') or ((m_axis_tready = '1') and (m_axis_tvalid_reg = '1')) then
        -- already done or just done right now
        done <= '1';
        m_axis_tvalid_reg <= '0';
      else
        m_axis_tvalid_reg <= '1';
        done <= '0';
      end if;
    end if;
  end process;
end Behavioral;
