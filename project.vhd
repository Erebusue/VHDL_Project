---------------------------------------
--Project for Coen 313
--Done by: Mohammad Sharafat 40209284
--Simulated using Simulink
--Synthesized using Vivado
-------------------------------------

--Initializing libraries.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


-- Entity declaration

entity project is
port( 
--X is the input to inrement, Y is to decrement
X, Y : in std_logic;
--Max_occupancy is a modifier we can control to choose what the max number of people is.
max_occupancy : in std_logic_vector(5 downto 0);
--Clock and reset are basic clock and reset
clk, reset : in std_logic;
--Z is one when max_occupancy is equal to current_occupancy.
Z : out std_logic);
end;


architecture rtl of project is
begin
--process is sensitive to the synchornous clock and asynchronous reset.
process(clk, reset)
--This variable is the current occupancy.
variable current_occupancy : std_logic_vector(5 downto 0);
begin
if reset = '1' then
	current_occupancy := "000000";
	Z <= '0';
elsif clk'event and clk = '1' then
	--So if current_occupancy is equal to max_occupany we set Z to 1 shining the bright red light
	
	if current_occupancy = max_occupancy then
		Z <= '1';
		if Y = '1' then
			current_occupancy := current_occupancy - "000001";
		end if;
	else
		Z <= '0';
		if X = '1' then
			current_occupancy := current_occupancy + "000001";
		end if;
		if Y = '1' then
			current_occupancy := current_occupancy - "000001";
		end if;
	end if;
end if;
end process;

end rtl;
