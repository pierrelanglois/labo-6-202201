library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
use work.PolyRISC_utilitaires_pkg.all;

entity PolyRISC_tb is
end;

architecture arch_tb of PolyRISC_tb is

signal clk : std_logic := '0';
signal reset : std_logic;
signal GPIO_in, GPIO_out : signed(Wd - 1 downto 0);
signal GPIO_in_valide, GPIO_out_valide : std_logic;

constant periode : time := 10 ns;

begin

    clk <= not clk after periode / 2;
    reset <= '1' after 0 sec, '0' after 7 * periode / 4;

    GPIO_in <= to_signed(7, GPIO_in'length) after 0 ns;
    GPIO_in_valide <= '0' after 0 ns, '1' after 30 ns, '0' after 40 ns;

	-- instanciation du module à vérifier
    UUT : entity PolyRISC(arch)
        port map (
            clk => clk,
            reset => reset,
            GPIO_in => GPIO_in,
            GPIO_in_valide => GPIO_in_valide,
            GPIO_out => GPIO_out,
            GPIO_out_valide => GPIO_out_valide
        );

end;