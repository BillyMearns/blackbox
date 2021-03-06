<<<<<<< HEAD:blackbox.adb
<<<<<<< HEAD:blackbox.adb
<<<<<<< HEAD:blackbox.adb
--Billy Mearns
WITH Types; USE Types;
=======
>>>>>>> MorganShowman/master:blackbox.adb
WITH Board, Actions, Screen, Windows;
=======
WITH Types, Board, Actions, Screen, Windows, Stacks;
USE  Types, Board, Actions, Screen, Windows, Stacks;
>>>>>>> 94010df9e0727b697800d3fd1e78f9445b7a2e4c:blackbox.adb
WITH Ada.Text_IO;
=======
WITH Types, Board, Actions, Screen, Windows, Stacks, Lists;
USE  Types, Board, Actions, Screen, Windows;
WITH Ada.Text_IO; USE Ada.Text_IO;
>>>>>>> 2672c377b41f3c0a35852f7f347b1223a4dbcec1:blackbox.adb

-- Morgan: maintain master program, write main logic/procedures
-- Billy: Write Retract, Guess, and Help Procedures
-- Tony: Write Setup Board using the Windows Package. Keep a list of the windows.
-- Spencer: Write Move, and Fire Laser

-- Types
-- ************
-- Difficulty: Enumeration of Records containing data for each difficulty
-- Option: Enumeration of each input option during game play
-- BoardType: Record with a field for each window, and a field "Boxes" that points to an array of windows.

PROCEDURE BlackBox IS

	PACKAGE Stack IS NEW Stacks(MoveElement,"<");
	USE		Stack;
	PACKAGE List IS NEW Lists(GuessElement,"<");
	USE		List;

	-- Display Menu - Procedure (Selection : OUT Difficulty) {BlackBox}
	Procedure DisplayMenu (Selection : OUT Difficulty) IS
	BEGIN	-- Display Menu
		NULL;
	END DisplayMenu;
	-- User Input - Procedure (Selection : OUT Option) {BlackBox}-- User Input
	PROCEDURE UserInput (Selection : OUT Option) IS
		Action : Boolean := False;
	BEGIN	-- User Input
		WHILE Action /= True LOOP
			Get_Immediate(Selection,Action);
		END LOOP;
	END UserInput;
	-- Execute - Procedure (Selection : IN Option) {BlackBox}
	PROCEDURE Execute (Selection : IN Option) IS
	BEGIN	-- Execute
		Case Selection
			-- Move - Procedure (Selection : IN Option;GameBoard : IN OUT BoardType) {Actions}
			When Direction
				Move(Selection,GameBoard);
			-- Fire Laser - Procedure (GameBoard : IN OUT BoardType) {Actions}
			When Spacebar
				FireLaser(GameBoard);
			-- Retract - Procedure (GameBoard : IN OUT BoardType) {Actions}
			When R
				Retract(GameBoard);
			-- Guess - Procedure (GameBoard : IN OUT BoardType) {Actions}
			When G
				Guess(GameBoard);
			-- Help - Procedure (GameBoard : IN OUT BoardType) {Actions}
			When H
				Guess(GameBoard);
	END Execute;

BEGIN
	LOOP
		-- Display Menu - Procedure (Selection : OUT Difficulty) {BlackBox}
		DisplayMenu(Selection);
		EXIT WHEN Selection = NULL;
			-- Setup Board (Use List/Record [BoardType] to track Windows) - Procedure (Selection : IN Difficulty; GameBoard : OUT BoardType) {Board}
				-- Define Window
				-- Set Border
				-- Define Windows for Boxes
				-- Set Colors
				-- Define Shots Window
				-- Define Guesses Window
				-- Define Options Window
		-- Game Loop
		WHILE NOT End_Of_Game LOOP
			-- Update Board - Procedure (GameBoard : IN BoardType) {Board}
			-- UpdateBoard(GameBoard);
			-- User Input - Procedure (Selection : OUT Option) {BlackBox}
			UserInput(Selection);
			-- Execute - Procedure (Selection : IN Option) {BlackBox}
<<<<<<< HEAD:blackbox.adb
				-- Update Board - Procedure (GameBaord : IN BoardType) {Board}
				-- Case Selection
					-- Move - Procedure (GameBoard : IN OUT BoardType) {Actions}
					-- Fire Laser - Procedure (GameBoard : IN OUT BoardType) {Actions}
					-- Retract - Procedure (GameBoard : IN OUT BoardType) {Actions}
					-- Guess - Procedure (GameBoard : IN OUT BoardType) {Actions}
					-- Help - Procedure (GameBoard : IN OUT BoardType) {Actions}
			-- Loop Until End Game Condition
	-- Exit When Selection = Null
=======
			Execute(Selection);
		-- Loop Until End Game Condition
		END LOOP;
	END LOOP;
>>>>>>> MorganShowman/master:blackbox.adb
END BlackBox;
