---------------------------------------
--Project for Coen 313
--Done by: Mohammad Sharafat 40209284
--Simulated using Simulink
--Synthesized and implemented using Vivado
--Designed for the xc7a100tcsg324-1 board.
-- This is the test bench
-------------------------------------

--Initializing libraries.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


-- Entity declaration

entity project_tb is
--Since this is a test bench, we dont have any ports.
end;


architecture BehaviourTester of project_tb is
  
  --Lets define our project component
  component project
    port( 
	  X, Y : in std_logic;
	  max_occupancy : in std_logic_vector(5 downto 0);
	  clk, reset : in std_logic;
	  Z : out std_logic);
  end component;


	Signal X_test, Y_Test, Z_Test, reset_test : std_logic := '0';
	signal max_occupancy_test : std_logic_vector(5 downto 0) := "111111";
	signal clk_test : std_logic;
	constant clock_period : time := 100 ns; 


begin

	--Basically generating the clock.

	clk_generator : process
	begin
		clk_test <= '1';
		wait for clock_period/2;
		clk_test <= '0';
		wait for clock_period/2;
	end process;

	projecttest : project port map( clk => clk_test, reset => reset_test, Z => Z_test, Y => Y_test, X => X_test, max_occupancy => max_occupancy_test);

	Stimulus_process : process
	begin
		--Let's start by reseting everything and waiting for a bit to confirm the initial max occupancy
		reset_test <= '1'; wait for 200 ns;
		--Let's set a new max occupancy, to confirm that that function works, then let's also add one
		--So current occupancy should equal one now
		max_occupancy_test <= "000011"; reset_test <= '0'; X_test <= '1'; Y_test <= '0'; wait for 200 ns;
		--current occupancy should equal two now
		max_occupancy_test <= "000011"; X_test <= '1'; Y_test <= '0'; wait for 200 ns;
		--current occupancy should equal three now, and Z should light up in the simulation
		--So if Z lights up now, we confirm the functionality of both incrementing with X
		--and that we can detect when the current occupants in the room are equal to the max occupants.
		max_occupancy_test <= "000011"; X_test <= '1'; Y_test <= '0'; wait for 200 ns;
		--Now the Z is stuck at 1 until reset is called, so let's call for reset so we can bring the system 
		--back to initial state. We should confirm that X, Y, and Z are equal to zero now
		reset_test <= '1'; wait for 200 ns;
		--Let's now set the max occupancy to two, this is so we can test decrement.
		--current occupancy should be equal to 1 right now.
		max_occupancy_test <= "000010"; X_test <= '1'; Y_test <= '0'; reset_test <= '0'; wait for 200 ns;
		--Assuming Decrement worked right, current occupancy should be equal to zero now
		max_occupancy_test <= "000010"; X_test <= '0'; Y_test <= '1'; wait for 200 ns;
		--Let's run the command twice now and if after two runs Z = 1, that confirms that decrement works
		--thus all of the functionality works.
		max_occupancy_test <= "000010"; X_test <= '1'; Y_test <= '0'; wait for 200 ns;
		max_occupancy_test <= "000010"; X_test <= '1'; Y_test <= '0'; wait for 200 ns;
		max_occupancy_test <= "000010"; X_test <= '0'; Y_test <= '1'; wait for 200 ns;
		max_occupancy_test <= "000010"; X_test <= '0'; Y_test <= '0'; wait for 200 ns;
		report "Basic functionality has been tested, now testing extrema current occupancy = 63 = max occupancy" severity note;
		--Let's do one last test now to test for the max possible occupancy
		max_occupancy_test <= "111111";X_test <= '0';reset_test <= '1'; wait for 200 ns;
		max_occupancy_test <= "111111";reset_test <= '0'; wait for 200 ns;
		for i in 0 to 63 loop
			max_occupancy_test <= "111111"; X_test <= '1'; Y_test <= '0'; wait for 200 ns;
			if (Z_test = '1') then
				report "Max occupancy detected properly" severity note;
				reset_test <= '1'; wait for 200 ns;
			end if;
		end loop;
		report "the test bench functionality has ended" severity note;
		wait;

		
	wait; end process;

		
		
end BehaviourTester;

