---------------------------------------------------------------------------------------------------
--
-- top_labo_6.vhd
--
-- Pierre Langlois
-- v. 1.0, 2020/11/15 pour le laboratoire #5
-- v. 1.1, 2021/04/02 modifications d'identificateurs d'entité etc.
-- v. 1.2, 2022/03/29 modifications mineures de format
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.utilitaires_inf3500_pkg.all;
use work.all;

entity top_labo_6 is
    port(
        clk  : in  std_logic;                      -- l'horloge de la carte à 100 MHz
        sw   : in  std_logic_vector(15 downto 0);  -- les 16 commutateurs
        led  : out std_logic_vector(15 downto 0);  -- les 16 LED
        seg  : out std_logic_vector(7 downto 0);   -- les cathodes partagées des quatre symboles à 7 segments + point
        an   : out std_logic_vector(3 downto 0);   -- les anodes des quatre symboles à 7 segments + point
        btnC : in  std_logic;                      -- bouton du centre
        btnU : in  std_logic;                      -- bouton du haut
        btnL : in  std_logic;                      -- bouton de gauche
        btnR : in  std_logic;                      -- bouton de droite
        btnD : in  std_logic;                      -- bouton du bas
        RsRx : in  std_logic;                      -- pour carte Basys 3, interface USB-RS-232 réception
        RsTx : out std_logic                       -- pour carte Basys 3, interface USB-RS-232 transmission
--        UART_TXD_IN : in std_logic;                -- pour carte Nexys A7 100T, patte C4, réception RS232 (du point du vue du FPGA), voir le manuel de l'utilisateur
--        UART_RXD_OUT : out std_logic               -- pour carte Nexys A7 100T, patte D4, transmission RS232 (du point du vue du FPGA), voir le manuel de l'utilisateur
    );
end;

architecture arch of top_labo_6 is

signal symboles : quatre_symboles;

signal GPIO_in, GPIO_out : signed(31 downto 0);
signal GPIO_in_valide, GPIO_out_valide : std_logic;

signal clk_1Hz : std_logic;

begin

    -- sanity check
    led(15) <= clk_1Hz;
    led(14) <= sw(14);

    -- génération d'une horloge à 1 Hz pour pouvoir interagir avec les être humains
    horloge_humaine : entity generateur_horloge_precis(arch)
        generic map (freq_in => 100e6, freq_out => 1      )
        port map    (clk_in  => clk  , clk_out  => clk_1Hz);

    -- instantiation du processeur
    leprocesseur : entity PolyRISC(arch)
        port map (
            clk             => clk_1Hz,
            reset           => btnC,
            GPIO_in         => GPIO_in,
            GPIO_in_valide  => GPIO_in_valide,
            GPIO_out        => GPIO_out,
            GPIO_out_valide => GPIO_out_valide
        );

    -- on relie les 16 commutateurs à GPIO_in
    -- et un bouton à GPIO_in_valide
    GPIO_in(15 downto 0) <= signed(sw);
    GPIO_in(31 downto 16) <= (others => '0');
    GPIO_in_valide <= btnU;

    -- Pour la carte Basys 3 :
    --   Connexion de la sortie GPIO_out aux affichages à 7 segments.
    --   On suppose ici que GPIO_out est exprimé sur 16 bits.
    --   Les bits plus signficatifs supplémentaires ne seront pas affichés.
    -- Pour la carte Nexys A7, on pourrait rajouter 4 chiffres (symboles(7), symboles(6), symboles(5) et symboles(4)).
    symboles(3) <= hex_to_7seg(GPIO_out(15 downto 12));
    symboles(2) <= hex_to_7seg(GPIO_out(11 downto  8));
    symboles(1) <= hex_to_7seg(GPIO_out( 7 downto  4));
    symboles(0) <= hex_to_7seg(GPIO_out( 3 downto  0));

    led(0) <= GPIO_out_valide;

   -- Circuit pour sérialiser l'accès aux quatre symboles à 7 segments.
   -- L'affichage contient quatre symboles chacun composé de sept segments et d'un point.
    process(all)
    variable clkCount : unsigned(19 downto 0) := (others => '0');
    begin
        if (clk'event and clk = '1') then
            clkCount := clkCount + 1;
        end if;
        case clkCount(clkCount'left downto clkCount'left - 1) is     -- L'horloge de 100 MHz est ramenée à environ 100 Hz en la divisant par 2^19
            when "00" => an <= "1110"; seg <= symboles(0);
            when "01" => an <= "1101"; seg <= symboles(1);
            when "10" => an <= "1011"; seg <= symboles(2);
            when others => an <= "0111"; seg <= symboles(3);
        end case;
    end process;

end arch;