# Lab 1: Jaroslav Polkorab

### De Morgan's laws

1. Equations of all three versions of logic function f(c,b,a):

   ![Logic function](https://github.com/Polkorabjaroslav/digital-electronics-1/blob/main/labs/obraz/IMG_20220215_110154.jpg)

2. Listing of VHDL architecture from design file (`design.vhd`) for all three functions. Always use syntax highlighting, meaningful comments, and follow VHDL guidelines:

```vhdl
begin
    forg_o  <= (not(b_i) and a_i) or (not(c_i) and not(b_i));
    fnand_o <= ((not b_i nand a_i) nand (not c_i nand not b_i));
    fnor_o  <= b_i nor (a_i nor not c_i);
end architecture dataflow;
```

3. Complete table with logic functions' values:

| **c** | **b** |**a** | **f(c,b,a)** | **f_NAND(c,b,a)** | **f_NOR(c,b,a)** |
| :-: | :-: | :-: | :-: | :-: | :-: |
| 0 | 0 | 0 | 1 | 1 | 1 |
| 0 | 0 | 1 | 1 | 1 | 1 |
| 0 | 1 | 0 | 0 | 0 | 0 |
| 0 | 1 | 1 | 0 | 0 | 0 |
| 1 | 0 | 0 | 0 | 0 | 0 |
| 1 | 0 | 1 | 1 | 1 | 1 |
| 1 | 1 | 0 | 0 | 0 | 0 |
| 1 | 1 | 1 | 0 | 0 | 0 |

### Distributive laws

1. Screenshot with simulated time waveforms. Always display all inputs and outputs (display the inputs at the top of the image, the outputs below them) at the appropriate time scale!

   ![your figure](https://github.com/Polkorabjaroslav/digital-electronics-1/blob/main/labs/obraz/DE11.jpg)

2. Link to your public EDA Playground example:

   [https://www.edaplayground.com/...](https://www.edaplayground.com/x/7KBD)
 
