# Morse code recevier

### Team members

**Polkorab Jaroslav**
- návrh morse code příjímače, vytvoření a zpracování kódu

**Sedlák Ondřej**
- zpracování schémat, kódový asistent

**Gedeon Dominik**
- dokumentace projektu

**Gočiková Erika**
- Zpracování videa

### Table of contents

* [Project objectives](#objectives)
* [Hardware description](#hardware)
* [VHDL modules description and simulations](#modules)
* [TOP module description and simulations](#top)
* [Video](#video)
* [References](#references)

<a name="objectives"></a>

## Project objectives

- využít desku Nexys-A7 na zadávání morseova kódu pomocí switche
- Morseovy abecedy do textu
- zobrazení textu na 7 segmentovém displeji

<a name="hardware"></a>

## Hardware description
Pro realizaci jsme použili dnesku Nexys-A7:

![deska](https://static.packt-cdn.com/products/9781789805413/graphics/image/12710_01_11.jpg)

Pomocí switchů jsme schopni zadávat námi požadovaný vstupní signál morseovky, u nás tedy: **dot** či **dash**. V našem případě budeme používat pouze jeden switch na zadávání potřebných signálů.
Dále na desce použijeme integrovaný sedmisegmentový display, do kterého zapíšeme dekodovaný výstupní signál.
Do našeho kódu jsme ještě implementovali jeden button na reset.
Deska má sama v sobě generátor impilsů clock, který budeme využívat k dekódovaní i zadávání.

<a name="modules"></a>

## VHDL modules description and simulations
Při kompletaci našeho kódu budeme dodržovat standardní Morseovu abecedu.
**Výchozí převody mezi znaky**

Morseova abeceda:

![morseovka](https://user-images.githubusercontent.com/99871518/166684912-47f13f86-6d93-4eba-90be-3a1a01086570.gif)

Převodník na 7mi segmentový displej:

![unknown](https://user-images.githubusercontent.com/99871518/166684341-8de35626-589e-4e38-aa76-c6ffe7b51a29.png)

**Clock_enable** 
- **Clock_enable** nám zajišťuje zpomalení vnitřního clocku naší desky. To znamená, že nemusíme počítat každou náběžnou hranu clocku s frekncí třeba 400khz, ale počítáme pouze každou 100. náběžnou hranu (více záleží na uživatelském nastavení a na naší potřebě).
Blok našeho **clock_enablu** vypadá takto: 

![clock_enable](https://github.com/Polkorabjaroslav/digital-electronics-1/blob/main/labs/obraz/Clockenable.jpg)

Simulace tohoto **clock_enablu** vypadá následně takto: 
![clock_enablesim](https://github.com/Polkorabjaroslav/digital-electronics-1/blob/main/labs/obraz/clockenablesim.jpg)

**Main**
- Při našem převodu budeme využívat náběžných hran clocku a čítat je, v jednoduchosti pokud se bude switch nacházet v poloze 1 budeme rozeznávat rozdíly mezi **dot** a **dash** podle počtu náběžných hran clocku.
Dále musíme řešit mezery mezi znaky a mezery mezi písmeny. Tento problém řešíme podobně jako rozeznávání dot a dash a to tak, že počítáme dobud náběžných hran když je switch v 0.
Teď když už máme snímání mezer a znaků můžeme začít náš výstup do bufferu. Toto jsme ošetřili tím, že posouváme přepisujeme 10 bitový vektor námi zvolenou hodnotou pro **dot 01** pro **dash 11**. 
Dále námi zadanou hodnotu porovnáme a přiřadíme ji hodnotu výstupu na sedmisegmentový display.



**Schéma našeho main**
![main](https://github.com/Polkorabjaroslav/digital-electronics-1/blob/main/labs/obraz/Main_p.jpg)

**Ukázka našeho ošetření vstupu**
```vhdl 
 p_main : process(clk)
    begin
    enable_slow <= s_enable;
        if rising_edge(clk) then
        
           if (s_enable = '1')then
           
            if (reset = '1') then               -- Synchronous reset
                s_cnt_loc_loopUP <= 0;
                s_cnt_loc_loopDOWN <= 0;
                s_buffer_o <= "0000000000";
                s_buffer<="0000000000";
                end if;
                
                if (en_i = '1') then             -- Switch on
                   s_cnt_loc_loopDOWN  <= 0;
                   s_cnt_loc_loopUP <= s_cnt_loc_loopUP + 1;
                   loopup_o <= s_cnt_loc_loopUP;                         
 
                   
                     if (s_cnt_loc_loopUP > 6) then        --dash
                        s_cnt_num <= 11;
                        s_hold_out <= '1';  
                     elsif (s_cnt_loc_loopUP > 2) then       --dot
                        s_cnt_num <= 01;
                        s_hold_out <= '1'; 
                     end if;

                elsif (en_i = '0') then               --switch off
                  s_cnt_loc_loopDOWN <= s_cnt_loc_loopDOWN + 1;  
                  s_cnt_loc_loopUP <= 0;
                  loopdown_o <= s_cnt_loc_loopDOWN;
                        if (s_hold_out = '1') then
                           s_buffer <= std_logic_vector(shift_left(unsigned(s_buffer), 2));
                         
                             if (s_cnt_num = 11) then 
                                s_buffer(0)<= '1';
                                s_buffer(1)<='1';
                            
                             else
                               s_buffer(0)<= '1';
                               s_buffer(1)<='0';
                             end if;
                         
                             s_hold_out <= '0';
                             end if;  
                                        
                        if (s_cnt_loc_loopDOWN > 6) then        --big space     
                            s_buffer_o<=s_buffer;
                            if(s_cnt_loc_loopDOWN > 20) then  
                                s_buffer <= "0000000000";
                                s_cnt_loc_loopDOWN <= 0;
                           end if;
                        end if;
                    end if;    
            end if;
        end if;
    end process p_main;
```
Simulace a dekódovaní můžeme vidět na této simulaci: 
![7seg](https://github.com/Polkorabjaroslav/digital-electronics-1/blob/main/labs/obraz/Simulace7seg.png)

Na tého simulaci můžeme vidět vstupní signál **s_en** kdy máme **dash dot dot dash** na konci tohoto vstupního signálu můžeme vidět, že náš kód vyčkává 7 náběžných hran **s_enable** poté se k hodnotě bufferu přiřadá hodnota z morseovy abecedy. tedy pro nás **dash dot dot dash** == X a to zapíšeme na 7 segmentový displej pomocí "1100011".
Dále můžeme vidět, že nám **s_reset** nám přepne obvod do začáteční polohy (vymaže buffer, čítání apod.)

Simulace více vstupů po sobě: 
![3_signály](https://github.com/Polkorabjaroslav/digital-electronics-1/blob/main/labs/obraz/7segdecod_3sig.png)

Můžeme vidět, že obvod se vrací zpět původního stavu sám po uplynutí námi nastavené doby.


<a name="top"></a>

## TOP module description and simulations
Náš top soubor zajišťuje kontakt mezi hardware vstupem a výstupem naší desky. 
V tomto topu připojujeme jednotlivým výstupům hodnoty. 


**Schéma našeho topu**
![top](https://github.com/Polkorabjaroslav/digital-electronics-1/blob/main/labs/obraz/Top.png)

<a name="video"></a>

## Video

Video k projektu (https://youtu.be/gulC7z_HuiI)

<a name="references"></a>

## References

1. Nexys-A7 reference manuál (https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual?redirect=1)
2. LAB 04-segment (https://github.com/tomas-fryza/digital-electronics-1/blob/master/labs/04-segment/README.md)
3. LAB 07-display_driver (https://github.com/tomas-fryza/digital-electronics-1/tree/master/labs/07-display_driver)
4. 
