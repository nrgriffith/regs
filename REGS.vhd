library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---------------------------------------------------
-- Implement 3 registers...
-- -- A counter
-- -- A shift register
-- -- A parallel storage register
---------------------------------------------------

entity REGS is
    port ( clk    : in    std_logic;
           SW0    : in    std_logic;
           SW1    : in    std_logic;
           SW2    : in    std_logic;
           SW3    : in    std_logic;
           rdout  : out   std_logic_vector (7 downto 0)
			  );
end REGS;

architecture BEHAVIORAL of REGS is

    signal streg, rsreg, cntrout: std_logic_vector (7 downto 0);
    signal SEL, FNC: std_logic_vector (1 downto 0);

begin

    SEL <= SW1 & SW0;
    FNC <= SW3 & SW2;
	 
	 rdout <= streg    when SEL = "00" else
	          rsreg    when SEL = "01" else
				 cntrout  when SEL = "10" else
				 "00000000";

---------------------------------------------------
-- Implement 3 registers...
-- -- A counter
-- -- A shift register
-- -- A parallel storage register
---------------------------------------------------

    process (clk, SEL, FNC)
    begin
        if (clk'event and clk = '1' and SEL = "00") then
            if (FNC = "00") then
                streg <= "00000000";
		      elsif (FNC = "01") then
		          streg <= rsreg;
		      elsif (FNC = "10") then
		          streg <= cntrout;
            end if;
        end if;
    end process;

    process (clk, SEL, FNC)
    begin
        if (clk'event and clk = '1' and SEL = "01") then
            if (FNC = "00") then
		          rsreg <= "00000000";
		      elsif (FNC = "01") then
                rsreg <= rsreg(6 downto 0) & rsreg(7);
            elsif (SW3 = '1') then
                rsreg <= rsreg(6 downto 0) & SW2;
            end if;
        end if;
    end process;

    process(clk, SEL, FNC)
    begin
        if (clk'event and clk = '1' and SEL = "10") then

            if (FNC ="00") then
                cntrout <= "00000000";
            elsif (FNC = "01") then
                if (cntrout < "11111111") then
                    cntrout <= cntrout + "00000001";
                else
                    cntrout <= "00000000";
                end if;
            elsif (FNC = "10") then
                if (cntrout > "00000000") then
                    cntrout <= cntrout - "00000001";
                else
                    cntrout <= "11111111";
                end if;
				elsif (FNC = "11") then
				    cntrout <= rsreg;
            end if;
        end if;
	 
    end process;

end BEHAVIORAL;