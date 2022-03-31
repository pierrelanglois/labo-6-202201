---------------------------------------------------------------------------------------------------
--
-- PolyRISC_le_programme_pkg.vhd
--
-- contenu de la mémoire des instructions
--
---------------------------------------------------------------------------------------------------
use work.PolyRISC_utilitaires_pkg.all;

package PolyRISC_le_programme_pkg is

    -----------------------------------------------------------------------------------------------
    -- partie 0 : programme de démonstration, suite de Fibonacci
    constant memoireInstructions : memoireInstructions_type := (
    (memoire, lireGPIO_in, 0, 0, 0),               -- 0 : R0 := lire GPIO_in
    (reg_valeur, passeB, 1, 0, 2),                 -- 1 : R1 := #2
    (reg_valeur, passeB, 3, 0, 0),                 -- 2 : R3 := #0
    (memoire, ecrireGPIO_out, 3, 0, 0),            -- 3 : GPIO_out := R3
    (reg_valeur, passeB, 4, 0, 1),                 -- 4 : R4 := #1
    (memoire, ecrireGPIO_out, 4, 0, 0),            -- 5 : GPIO_out := R4
    (reg, AplusB, 5, 3, 4),                        -- 6 : R5 := R3 + R4
    (reg, passeA, 3, 4, 0),                        -- 7 : R3 := R4
    (reg, passeA, 4, 5, 0),                        -- 8 : R4 := R5
    (memoire, ecrireGPIO_out, 4, 0, 0),            -- 9 : GPIO_out := R4
    (reg_valeur, AplusB, 1, 1, 1),                 -- 10 : R1 := R1 + #1
    (branchement, ppe, 0, 1, -5),                  -- 11 : si R1 <= R0 goto CP + -5
    STOP,
    NOP);

    -----------------------------------------------------------------------------------------------
    -- parties 1 et 2 : votre code à développer
    -- placez le code de la partie 0 en commentaires
    -- utilisez le code de la partie 0 pour vous inspirer

--    constant memoireInstructions : memoireInstructions_type := (
--    (memoire, lireGPIO_in, 0, 0, 0),               -- 0 : R0 := lire GPIO_in
--
--    -- votre code ici
--
--    STOP,
--    NOP);

end package;
