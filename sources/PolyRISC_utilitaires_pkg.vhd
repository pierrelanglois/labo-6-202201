---------------------------------------------------------------------------------------------------
--
-- PolyRISC_utilitaires_pkg.vhd
--
-- v. 1.0, 2020/11/15 Pierre Langlois
-- v. 1.0c 2021-11-28 inclut RB := GPIO_in, solution du labo #5
--
-- Déclarations et fonctions utilitaires pour le processeur PolyRISC
--
---------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

package PolyRISC_utilitaires_pkg is

    -- taille du processeur
    constant Nreg : positive := 16;    -- nombre de registres
    constant Wd : positive := 32;      -- largeur du chemin des données en bits
    constant Mi : positive := 8;       -- largeur du PC et nombre de bits d'adresse de la mémoire d'instructions
    constant Md : positive := 8;       -- nombre de bits d'adresse de la mémoire des données

    type lesRegistres_type is array(0 to Nreg - 1) of signed(Wd - 1 downto 0);
    type memoireDonnees_type is array(0 to 2 ** Md - 1) of signed(Wd - 1 downto 0);

    -- catégories d'instructions
    constant reg : natural := 0;
    constant reg_valeur : natural := 1;
    constant branchement : natural := 2;
    constant memoire : natural := 3;

    -- détails d'instructions pour la catégorie mémoire
    constant lireMemoire : natural := 0;
    constant ecrireMemoire : natural := 1;
    constant lireGPIO_in : natural := 2;
    constant ecrireGPIO_out : natural := 3;

    -- encodage des opérations de l'UAL
    constant passeA  : natural := 0;
    constant passeB  : natural := 1;
    constant AplusB  : natural := 2;
    constant AmoinsB : natural := 3;
    constant AetB    : natural := 4;
    constant AouB    : natural := 5;
    constant nonA    : natural := 6;
    constant AouxB   : natural := 7;
    constant absA    : natural := 8;
    constant minAB   : natural := 9;
    constant maxAB   : natural := 10;

    -- encodage des conditions de branchement
    constant egal : natural := 0;
    constant diff : natural := 1;
    constant ppq : natural := 2;
    constant pgq : natural := 3;
    constant ppe : natural := 4;
    constant pge : natural := 5;
    constant toujours : natural := 6;
    constant jamais : natural := 7;

    -- structure pour l'encodage d'une instruction
    type instruction_type is record
        categorie : natural range 0 to 3;
        details : natural range 0 to 15;
        reg1 : natural range 0 to Nreg - 1;
        reg2 : natural range 0 to Nreg - 1;
        valeur : integer range -32768 to 32767;
    end record;

    -- instructions prédéfinies
    constant NOP : instruction_type := (branchement, jamais, 0, 0, 0);
    constant STOP : instruction_type := (branchement, toujours, 0, 0, 0);

    type memoireInstructions_type is array (natural range <>) of instruction_type;

end package;