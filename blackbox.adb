WITH Board, Actions, Screen, Windows;
WITH Ada.Text_IO;

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

	-- Display Menu - Procedure (Selection : OUT Difficulty) {BlackBoard}
	-- User Input - Procedure (Selection : OUT Option) {BlackBox}-- User Input
	-- Execute - Procedure (Selection : IN Option) {BlackBox}

BEGIN
	-- Display Menu - Procedure (Selection : OUT Difficulty) {BlackBoard}
	-- If Selection /= NULL
		-- Setup Board (Use List/Record [BoardType] to track Windows) - Procedure (Selection : IN Difficulty; GameBoard : OUT BoardType) {Board}
			-- Define Window
			-- Set Border
			-- Define Windows for Boxes
			-- Set Colors
			-- Define Shots Window
			-- Define Guesses Window
			-- Define Options Window
		-- Game Loop
			-- User Input - Procedure (Selection : OUT Option) {BlackBox}
				-- Loop While Action /= True
					-- Get Input
			-- Execute - Procedure (Selection : IN Option) {BlackBox}
				-- Update Board - Procedure (GameBaord : IN BoardType) {Board}
				-- Case Selection
					-- Move - Procedure (GameBoard : IN OUT BoardType) {Actions}
					-- Fire Laser - Procedure (GameBoard : IN OUT BoardType) {Actions}
					-- Retract - Procedure (GameBoard : IN OUT BoardType) {Actions}
					-- Guess - Procedure (GameBoard : IN OUT BoardType) {Actions}
					-- Help - Procedure (GameBoard : IN OUT BoardType) {Actions}
			-- Loop Until End Game Condition
	-- Exit When Selection = Null
END BlackBox;
