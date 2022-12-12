library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.util_pkg.all;
entity fir_param is
 generic(fir_ord : natural := 20;
         WIDTH : natural := 24;
         FIXED_POINT_POSITION:natural:=23);
 Port (  clk_i : in STD_LOGIC;
         rst : in STD_LOGIC;
         we_i : in STD_LOGIC;
         coef_addr_i : std_logic_vector(log2c(fir_ord+1)-1 downto 0);
         coef_i : in STD_LOGIC_VECTOR (WIDTH-1 downto 0);
         data_i : in STD_LOGIC_VECTOR (WIDTH-1 downto 0);
         data_o : out STD_LOGIC_VECTOR (WIDTH-1 downto 0));
end fir_param;
architecture Behavioral of fir_param is
     type std_2d is array (fir_ord downto 0) of
        std_logic_vector(2*WIDTH-1 downto 0);
         signal mac_inter : std_2d:=(others=>(others=>'0'));
 type coef_t is array (fir_ord downto 0) of
        std_logic_vector(WIDTH-1 downto 0);
 signal b_s : coef_t := (others=>(others=>'0'));

begin
 --proces koji modeluje sinkroni upis u memoriju b_s
 process(clk_i)
 begin
     if(clk_i'event and clk_i = '1')then
         if we_i = '1' then
             b_s(to_integer(unsigned(coef_addr_i))) <= coef_i;
         end if;
     end if;
 end process;
 --instanca prvog MAC-a ?iji je ulaz sec_i jednak 0
 first_section:
 entity work.simple_multiplier(behavioral)
 generic map(WIDTH=>WIDTH)
 port map(clk_i => clk_i,
         rst => rst,
         a_i => data_i,
         b_i => b_s(fir_ord),
         c_i => (others=>'0'),
         c_o => mac_inter(0));
 --instanciranje ostalih MAC modula filtra
 other_sections:
 for i in 1 to fir_ord generate
     fir_section:
     entity work.simple_multiplier(behavioral)
     generic map(WIDTH=>WIDTH)
     port map(clk_i => clk_i,
              rst => rst,
              a_i => data_i,
              b_i => b_s(fir_ord-i),
              c_i => mac_inter(i-1), --sec_o signal prethodnog MAC modula
              c_o => mac_inter(i));
 end generate;
 --registrovanje izlaznog signala
 process(clk_i)
 begin
     if(clk_i'event and clk_i='1')then
         data_o <= mac_inter(fir_ord)( (WIDTH + FIXED_POINT_POSITION - 1) downto FIXED_POINT_POSITION );
     end if;
 end process;
end Behavioral;
