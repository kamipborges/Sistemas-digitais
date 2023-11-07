library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;

entity temporizador is
    port( 
        clock, reset, load, en : in std_logic;
        init_time : in std_logic_vector(7 downto 0);
        cont : out std_logic_vector(15 downto 0)
    );
end temporizador;

architecture a1 of temporizador is
    signal segL, segH, minL, minH : std_logic_vector(3 downto 0);
    signal en1, en2, en3, en4: std_logic;
begin

    en1 <= en AND NOT (segL = "0000" AND segH = '0000' AND minL = '0000' AND minH = '0000'); 
    --Contadores = 0------ 
    
    en2 <= en1 and segL = '0000';
    
    en3 <= en2 and segH = '0000';
    
    en4 <= en3 and minL = '0000';

    sL : entity work.dec_counter port map (
        clock => clock,
        reset => reset,
        load  => en1,
        en    => en2,
        first_value => "0000"
        limit => "1001",   --limite 9
        cont  => segL
    );
-- limite 5 sh
--os outros tem limite 9
    sH : entity work.dec_counter port map (
        clock => clock,
        reset => reset,
        load  => en2,
        en    => en3,
        first_value => "0000"
        limit => "0101",   --limite 5
        cont  => segH
    );

    mL : entity work.dec_counter port map (
        clock => clock,
        reset => reset,
        load  => en3,
        en    => en4,
        first_value => "0000", 
        limit => "1001",   --limite 9
        cont  => minL
    );

    mH : entity work.dec_counter port map (
        clock => clock,
        reset => reset,
        load  => en4,
        en    => '1',
        first_value => "0000",
        limit => "1001",     --limite 9
        cont  => minH
    );

    cont <= minH & minL & segH & segL;

end a1;
