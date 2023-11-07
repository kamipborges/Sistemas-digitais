--------------------------------------------------------------------------------
-- RELOGIO DE XADREZ
-- Author - Fernando Moraes - 25/out/2023
-- Revision - Iaçanã Ianiski Weber - 30/out/2023
--------------------------------------------------------------------------------
library IEEE;
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;

entity relogio_xadrez is
    port(  reset         :           in std_logic;
            clock        :           in std_logic;
            load         :           in std_logic;
            init_time    :           in std_logic_vector( 7 downto 0);
            j1           :           in std_logic;
            j2           :           in std_logic;
            contj1, contj2:          out std_logic_vector (15 downto 0);
            winJ1, winJ2  :          out std_logic
    );
end relogio_xadrez;

architecture relogio_xadrez of relogio_xadrez is
    -- DECLARACAO DOS ESTADOS
    type states is ( init, carregar, start, jog1, jog2, win_j1, win_j2);
    signal EA, PE : states;
    -- ADICIONE AQUI OS SINAIS INTERNOS NECESSARIOS
    -- sinais internos
    signal en_1, en_2, load_int;   --sinais internos
   
begin

    -- INSTANCIACAO DOS CONTADORES
    contador1 : entity work.temporizador port map (         
            --clock relogio_xadrez => clock do temporizador
            clock => clock,                             --in
            reset => reset,      
            load_int => load,
            en => en_1,
            init_time => init_time,
            cont => contj1   --saida eh o contrario 
        );

    contador2 : entity work.temporizador port map (
        contador1 : entity work.temporizador port map (         
            --clock relogio_xadrez => clock do temporizador
            clock => clock,    
            reset => reset,
            load_int => load,
            en => en_1,
            init_time => init_time,
            cont => contj2   --saida eh o contrario 
        );


    -- PROCESSO DE TROCA DE ESTADOS
    process (clock, reset)
        if reset = '1' then 
            EA <= init
        elsif rising_edge(clock) then
            EA <= PE
        end if;
    end process;

    -- PROCESSO PARA DEFINIR O PROXIMO ESTADO
    process ( ) --<<< Nao esqueca de adicionar os sinais da lista de sensitividade
    begin
        case EA is
            when init => if carregar = '1' then
                        PE <= carregar;
                    else 
                        PE <= init;
                    end if;
                    when carregar => 
                    PE <= start;
               
                    when start => 
                    if j1 = '1' then 
                    PE <= j1
                    elseif j2='1'
                    PE <= j2;
                    end if;
               
                    when j1 =>
                    if j1 ='1' then 
                    PE <= j2;
                    end if;
                    if count1 = "0000" then 
                    PE <= win_j2;
                    end if;
               
                    when j2 =>
                    if j2 ='1' then 
                    PE <= j1;
                    end if;
                    if count2 = "0000" then
                    PE <= win_j1;
                    end if;

        end case;
    end process;

    
    -- ATRIBUICAO COMBINACIONAL DOS SINAIS INTERNOS E SAIDAS - Dica: faca uma maquina de Moore, desta forma os sinais dependem apenas do estado atual!!
    en_1 <= '1' when EA = j1 else '0'; --decrementar 
    en_2 <= '1' when EA = j2 else '0';
    load_int <= '1' when EA = load else '0'; --
    j1 <= '1' then 
    


end relogio_xadrez;
--





--
