---------------------------------------------------------------------------------------------------
--
-- top_labo_5.vhd
--
-- v. 1.0 Pierre Langlois 2022-03-17
--
-- Digilent Basys 3 Artix-7 FPGA Trainer Board
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.utilitaires_inf3500_pkg.all;
use work.all;

entity top_labo_5 is
    port (
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
        RsRx : in  std_logic;                      -- interface USB-RS-232 réception
        RsTx : out std_logic                       -- interface USB-RS-232 transmission
    );
end;

architecture arch of top_labo_5 is

    signal reset : std_logic;
    signal clk_1_MHz, clk_2_Hz : std_logic;

    signal symboles : quatre_symboles;

    signal btnC_stable, btnU_stable, btnL_stable, btnR_stable, btnD_stable : std_logic;
    signal NC1, NC2, NC3, NC4, NC5 : std_logic;    -- pour fils Non Connectés

    signal go_tx : std_logic;

    signal le_caractere : character;
    signal valide : std_logic;
    signal A0, B0, A, B, A_affichage, B_affichage : unsigned(7 downto 0);

    signal go_processeur, processeur_fini : std_logic;

begin

    -- génération des horloges du circuit à partir de l'horloge à 100 MHz de la carte
    gen_horloge_1_MHz : entity generateur_horloge_precis(arch) generic map (100e6, 1e6) port map (clk, clk_1_MHz);
    gen_horloge_2_Hz  : entity generateur_horloge_precis(arch) generic map (100e6,   2) port map (clk, clk_2_Hz);

    -- stabilisation et synchronisation des boutons avec l'horloge du circuit, on suppose une durée de rebond de 5 ms
    -- on prend une horloge de référence de 1 MHz pour avoir une impulsion qui dure 1 microseconde
    lebtnC : entity monopulseur(arch) generic map ('1', '1', integer(1e6 * 0.005), 1) port map (clk_1_MHz, btnC, btnC_stable, NC1);
    reset <= btnC_stable;

    interface : entity interface_utilisateur(arch)
		generic map (100e6, 9600)
		port map (reset, clk, RsRx, RsTx, A0, B0, go_processeur);

    processeur : entity pgfc3(arch)
        generic map (8)
        port map (reset, clk, A0, B0, go_processeur, A, B, processeur_fini);

    led(0) <= processeur_fini;
    led(1) <= go_processeur;
    A_affichage <= A0 when sw(0) = '1' else A;
    B_affichage <= B0 when sw(0) = '1' else B;
    symboles(3) <= hex_to_7seg(unsigned(A_affichage(7 downto 4)));
    symboles(2) <= hex_to_7seg(unsigned(A_affichage(3 downto 0)));
    symboles(1) <= hex_to_7seg(unsigned(B_affichage(7 downto 4)));
    symboles(0) <= hex_to_7seg(unsigned(B_affichage(3 downto 0)));

    -- circuit pour sérialiser l'accès à l'affichage
    -- l'affichage contient quatre symboles chacun composé de sept segments et d'un point
    process(all)
    variable clkCount : unsigned(19 downto 0) := (others => '0');
    begin
        if rising_edge(clk) then
            clkCount := clkCount + 1;
        end if;
        case clkCount(clkCount'left downto clkCount'left - 1) is     -- L'horloge de 100 MHz est ramenée à environ 100 Hz en la divisant par 2^19
            when   "00" => an <= "1110"; seg <= symboles(0);         -- Effectivement on prend les deux bits les plus significatifs d'un compteur de 20 bits.
            when   "01" => an <= "1101"; seg <= symboles(1);
            when   "10" => an <= "1011"; seg <= symboles(2);
            when others => an <= "0111"; seg <= symboles(3);
        end case;
    end process;

end arch;
