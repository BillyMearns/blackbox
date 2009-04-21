PACKAGE BODY Actions IS

<<<<<<< HEAD:actions.adb
 --Retract - Procedure (GameBoard : IN OUT BoardType) {Actions}
 --Guess - Procedure (GameBoard : IN OUT BoardType) {Actions}
 --Help - Procedure (GameBoard : IN OUT BoardType) {Actions}

END Actions;
=======
END Actions;

--Lazer mover/Firerer
With Ada.Text_IO; Use Ada.Text_IO;
With Ada.Integer_Text_IO; Use Ada.Integer_Text_IO;
With Ada.Strings.Unbounded; Use Ada.Strings.Unbounded;
With Ada.Text_IO.Unbounded_IO; Use Ada.Text_IO.Unbounded_IO;
With Ada.Strings; Use Ada.Strings;
With Screen;
With Windows;
With Types;

	Procedure Lazzer is
--I need The dimensions per diff. 
--Difficulty Level Skip
--		DifficultyLevel : Integer;
		
		--Carrot Variables
--		 Rows				:	Screen.Height := 50;
  --     Columns			:	Screen.Width :=132 ;

		Type CarrotInfo is Record
			--Carrot
--			Rows				:	Screen.Height := 20;
   --      Columns			:	Screen.Width := 50;
			CarrotX : Integer := 1;
			CarrotY : Integer := 1;
			CarrotXY : Screen.Position := (1,1);
			--CarrotPosition
			LeftValue		: Integer := 5;
			RightValue 	: Integer := 132;
			TopValue		: Integer := 10;
			BottomValue 	: Integer := 50;
			--Booleans
			Left : Boolean := False;
			Right : Boolean := False;
			Top : Boolean := False;
			Bottom : Boolean := False;
		end Record;
		Carrot : CarrotInfo;

		
		Type CornerInfo is Record
			--Corner Booleans
--				Corner	: C;
	
				TopLeftCorner : Boolean := False;
				TopRightCorner : Boolean := False;
				BottomLeftCorner : Boolean := False;
				BottomRightCorner : Boolean := False;
				AtCorner : Boolean := False;
				
				--Corner Check Values
				AtBottomLeft : Screen.Position := (Carrot.BottomValue,Carrot.LeftValue);
				AtBottomRight : Screen.Position := (Carrot.BottomValue,Carrot.RightValue);
				AtTopLeft : Screen.Position := (Carrot.TopValue,Carrot.LeftValue);
				AtTopRight : Screen.Position := (Carrot.TopValue,Carrot.RightValue);
				--A check could be if carrotXY := Corner(Edges.Left,Edges.top) then
				--								TopLeftCorner := True;
				--								Then make all others false.
		end record;
		Corner : CornerInfo;
		--Laser variables
		Type LaserInfo is Record
			X	: Integer;
			Y 	: Integer;
			LaserXY : Screen.Position;
			HitMirror : Boolean := False; --Made false again after it changes direction
			ShotFired : Boolean := False;
			ShotFinished : Boolean := False;
			GoingDown : Boolean := False;
			GoingUp : Boolean := False;
			GoingLeft : Boolean := False;
			GoingRight : Boolean := False;
			OutsideLeftSide : Integer := (Carrot.LeftValue -1); --the 1 is just for how ever many we decide to skip
			OutsideRightSide : Integer := (Carrot.RightValue +1);
			OutsideBottomSide : Integer := (Carrot.BottomValue +1);
			OutsideTopSide : Integer := (Carrot.TopValue -1);
		end Record;
		Laser : LaserInfo;
		
		Type MirrorsXPosition is Array (1..132) of Integer;
		Type MirrorsYPosition is Array (1..132) of Integer;
		Type MirrorsPosition is array (1..132) of Screen.Position;
		--SO it would be Mirrors(Index).MirrorPosition(Index) := (MirrorsX(Index), MirrorsY(Index));
		
		Type MirrorsAngleData is Array(1..132) of Boolean;
		Type Mirrorsdata is Record
			MirrorsX : MirrorsXPosition;
			MirrorsY : MirrorsYPosition;
			MirrorPosition : MirrorsPosition;
			MirrorAngle : MirrorsAngleData;
				--True means it's /   false means \
		end record;
		type MirrorNumber is array (1..132) of Mirrorsdata;		
		Mirrors : MirrorNumber;
		MirrorGotHit : Integer := 150;
		Input : Unbounded_String;
		
		Type UserChoice is Record
			LeftArrow : Boolean := False;
			RightArrow : Boolean := False;
			Space : Boolean := False;
		end record;
		Choice : UserChoice;
		
		Procedure MoveCarrot (ReadInput : Unbounded_String; Laser : In Out LaserInfo; Carrot : in out CarrotInfo; Corner : In out CornerInfo; Choice : in UserChoice) is
			Input : String := To_String (ReadInput);
		Begin 
			--TopLeftCorner/TopRightCorner/BottomLeftCorner/BottomRightCorner are defined in the gameboard make
			--Check to see if it is close to the corner
			--No specific corner checking --Will Fix.
			Carrot.CarrotXY := (Carrot.CarrotX,Carrot.CarrotY);		
			--Top Left Corners
			If Carrot.CarrotX = Carrot.LeftValue and Carrot.CarrotY = Carrot.TopValue+1 then
				Corner.AtCorner := True;
				Carrot.Left := True;
				Carrot.Top := True;
				Carrot.Bottom := False;
				Carrot.Right := False;
			elsIf Carrot.CarrotX = Carrot.LeftValue +1 and Carrot.CarrotY = Carrot.TopValue then
				Corner.AtCorner := True;
				Carrot.Left := True;
				Carrot.Top := True;
				Carrot.Bottom := False;
				Carrot.Right := False;
			--Top Right Corners
			elsif  Carrot.CarrotX = Carrot.RightValue and Carrot.CarrotY = Carrot.TopValue+1 then
				Corner.AtCorner := True;
				Carrot.Right := True;
				Carrot.Top := True;
				Carrot.Left := False;
				Carrot.Bottom := False;
			elsif  Carrot.CarrotX = Carrot.RightValue-1 and Carrot.CarrotY = Carrot.TopValue then
				Corner.AtCorner := True;
				Carrot.Right := True;
				Carrot.Top := True;
				Carrot.Left := False;
				Carrot.Bottom := False;
			--Bottom Right Corners
			elsif  Carrot.CarrotX = Carrot.RightValue and Carrot.CarrotY = Carrot.BottomValue-1 then
				Corner.AtCorner	:= True;
				Carrot.Right 		:=  True;
				Carrot.Bottom		:= True;
				Carrot.Left 		:= False;
				Carrot.Top 			:= False;
			elsif  Carrot.CarrotX = Carrot.RightValue -1 and Carrot.CarrotY = Carrot.BottomValue then
				Corner.AtCorner	:= True;
				Carrot.Right 		:=  True;
				Carrot.Bottom		:= True;
				Carrot.Left 		:= False;
				Carrot.Top 			:= False;
			--BottomLeft Corners
			elsif  Carrot.CarrotX = Carrot.LeftValue and then Carrot.CarrotY = Carrot.BottomValue-1 then--It's supposed to be - multiplier
				Corner.AtCorner := True;
				Carrot.Right :=  false;
				Carrot.Bottom := True;
				Carrot.Left := True;
				Carrot.Top := False;
			elsif Carrot.CarrotX = Carrot.LeftValue + 1 and then Carrot.CarrotY = Carrot.BottomValue then --It's supposed to be - multiplier
				Corner.AtCorner := True;
				Carrot.Right :=  false;
				Carrot.Bottom := True;
				Carrot.Left := True;
				Carrot.Top := False;
			else
				Corner.AtCorner := False;
			end if;				
			
			If Choice.LeftArrow = true then
				if Carrot.Top = true and Corner.AtCorner = false then
					Carrot.CarrotX := Carrot.CarrotX -1;
				elsif Carrot.Top = true and Corner.AtCorner = true then
					Carrot.Top := False;
					Carrot.Left := True;
					Carrot.CarrotX := Carrot.CarrotX -1;
					Carrot.CarrotY := Carrot.CarrotY +1;
				elsif Carrot.Left = true and Corner.AtCorner = false then
					Carrot.CarrotX := Carrot.CarrotY +1;
				elsif Carrot.Left = true and Corner.Atcorner = true then
					Carrot.Left := true;
					Carrot.Bottom := true;
					Carrot.CarrotX := Carrot.CarrotX -1;
					Carrot.CarrotY := Carrot.CarrotY +1;
				elsif Carrot.Bottom = true and Corner.AtCorner = false then
					Carrot.CarrotX := Carrot.CarrotX +1;
				elsif Carrot.Bottom = true and Corner.AtCorner = true then
					Carrot.Bottom := False;
					Carrot.Right := True;
					Carrot.CarrotX := Carrot.CarrotX +1;
					Carrot.CarrotY := Carrot.CarrotY -1;
				elsif Carrot.Right = true and Corner.AtCorner = false then
					Carrot.CarrotY := Carrot.CarrotY -1;
				elsif Carrot.Right = true and Corner.AtCorner = True then
					Carrot.Top := True;
					Carrot.Right := False;
					Carrot.CarrotX := Carrot.CarrotX -1;
					Carrot.CarrotY := Carrot.CarrotY -1;
				end if;
				
			elsif Choice.RightArrow = True then
				if Carrot.Top = true and Corner.AtCorner = false then
					Carrot.CarrotX := Carrot.CarrotX +1;
				elsif Carrot.Top = true and Corner.AtCorner = true then
					Carrot.Top := False;
					Carrot.Left := True;
					Carrot.CarrotX := Carrot.CarrotX +1;
					Carrot.CarrotY := Carrot.CarrotY +1;
				elsif Carrot.Left = true and Corner.AtCorner = false then
					Carrot.CarrotY := Carrot.CarrotY -1;
				elsif Carrot.Left = true and Corner.Atcorner = true then
					Carrot.Left := true;
					Carrot.Bottom := true;
					Carrot.CarrotX := Carrot.CarrotX -1;
					Carrot.CarrotY := Carrot.CarrotY +1;
				elsif Carrot.Bottom = true and Corner.AtCorner = false then
					Carrot.CarrotX := Carrot.CarrotX -1;
				elsif Carrot.Bottom = true and Corner.AtCorner = true then
					Carrot.Bottom := False;
					Carrot.Right := True;
					Carrot.CarrotX := Carrot.CarrotX +1;
					Carrot.CarrotY := Carrot.CarrotY -1;
				elsif Carrot.Right = true and Corner.AtCorner = false then
					Carrot.CarrotY := Carrot.CarrotY -1;
				elsif Carrot.Right = true and Corner.AtCorner = True then
					Carrot.Top := True;
					Carrot.Right := False;
					Carrot.CarrotX := Carrot.CarrotX +1;
					Carrot.CarrotY := Carrot.CarrotY -1;
				end if;
			end if;					
							

			If Carrot.CarrotX = Carrot.LeftValue then
				Carrot.Left := True;
				Carrot.Right := False;
				Carrot.CarrotXY := (Carrot.CarrotX, Carrot.CarrotY);
				Screen.MoveCursor (Carrot.CarrotXY);
				Put (">");
			elsif Carrot.CarrotX = Carrot.RightValue then
				Carrot.Right := True;
				Carrot.Left := False;
				Carrot.CarrotXY := (Carrot.CarrotX, Carrot.CarrotY);
				Screen.MoveCursor (Carrot.CarrotXY);
				Put ("<");
			elsif Carrot.CarrotY = Carrot.TopValue then
				Carrot.Top := True;
				Carrot.Bottom := False;
				Carrot.CarrotXY := (Carrot.CarrotX, Carrot.CarrotY);
				Screen.MoveCursor (Carrot.CarrotXY);
				Put ("\/");
			elsif Carrot.CarrotY = Carrot.BottomValue then
				Carrot.Bottom := True;
				Carrot.Top := False;
				Carrot.CarrotXY := (Carrot.CarrotX, Carrot.CarrotY);
				Screen.MoveCursor (Carrot.CarrotXY);
				Put ("^");
			end if;
			
		End MoveCarrot;
		
		
		

		Procedure InitialLaserDirection (Laser : in out LaserInfo; Carrot : in out CarrotInfo)is
		
		begin --InitialLaserDirection
				if Carrot.Top = true then
					Laser.GoingDown := True;
					Laser.GoingUp := False;
					Laser.GoingLeft := False;
					Laser.GoingRight := False;
					Laser.Y := Laser.Y -2;
					Laser.X := Laser.X;
					Laser.LaserXY := (Laser.X, Laser.Y);
					Screen.MoveCursor (Laser.LaserXY);
					Put ("|");
				elsif Carrot.Bottom = true then
					Laser.GoingUp := True;
					Laser.GoingDown := False;
					Laser.GoingLeft := False;
					Laser.GoingRight := False;
					Laser.Y := Laser.Y +2;
					Laser.X := Laser.X;
					Laser.LaserXY := (Laser.X, Laser.Y);
					Screen.MoveCursor (Laser.LaserXY);
					Put ("|");
				elsif Carrot.Left = true then
					Laser.GoingRight := True;
					Laser.GoingUp := False;
					Laser.GoingDown := False;
					Laser.GoingLeft:= False;
					Laser.Y := Laser.Y;
					Laser.X := Laser.X +2;
					Laser.LaserXY := (Laser.X, Laser.Y);
					Screen.MoveCursor (Laser.LaserXY);
					Put ("-");
				elsif Carrot.Right = True then
					Laser.GoingLeft := True;
					Laser.GoingUp := False;
					Laser.GoingDown := False;
					Laser.GoingRight := False;
					Laser.Y := Laser.Y;
					Laser.X := Laser.X -2;
					Laser.LaserXY := (Laser.X, Laser.Y);
					Screen.MoveCursor (Laser.LaserXY);
					Put ("-");
				end if;
		end InitialLaserDirection;
		
		
		
		Procedure ChangeLaserDirection (Laser : in out LaserInfo; Mirrors : in MirrorNumber; MirrorGotHit : in Integer) is
		GotHit: Integer := MirrorGotHit;
		Begin --ChangeLaserDirection
			If Laser.HitMirror = true then
				If Mirrors(MirrorGotHit).MirrorAngle(MirrorGotHit) = true then
					if Laser.GoingDown = true then
						Laser.GoingDown := false;
						Laser.GoingLeft := true;
					elsif Laser.GoingUp = true then
							Laser.GoingUp := false;
							Laser.GoingRight := True;
					elsif Laser.GoingRight = True then
							Laser.GoingRight := False;
							Laser.GoingUp := True;
					elsif Laser.GoingLeft = True then
							Laser.GoingLeft := False;
							Laser.GoingDown := true;
					end if;
				elsif Mirrors(MirrorGotHit).MirrorAngle(MirrorGotHit) = False then
					if Laser.GoingDown = true then
						Laser.GoingDown := false;
						Laser.GoingRight := true;
					elsif Laser.GoingUp = true then
							Laser.GoingUp := false;
							Laser.GoingLeft := True;
					elsif Laser.GoingRight = True then
							Laser.GoingRight := False;
							Laser.GoingDown := True;
					elsif Laser.GoingLeft = True then
							Laser.GoingLeft := False;
							Laser.GoingUp := true;
					end if;								
				end if;
			end if;
		end ChangeLaserDirection;
		
		Procedure MoveLaser (Laser : in out LaserInfo; Mirrors : in out MirrorNumber; MirrorGotHit : in out integer) is --(Laser : In Out LserData; GameInfo : In out GmeInfo) is
		
		Begin --MoveLaser
			If Laser.X /= Laser.OutsideLeftSide and Laser.X /= Laser.OutsideRightSide and Laser.Y /= Laser.OutsideTopSide and Laser.Y /= Laser.OutsideBottomSide then
				--The Outside Left/Right/Top/Bottom are going to be defined in another package.
				For Index in 1..Mirrors'Last loop
					If Laser.X = Mirrors(Index).MirrorsX(Index) and Laser.Y = Mirrors(Index).MirrorsY(Index) then
						MirrorGotHit := Index;
						ChangeLaserDirection(Laser, Mirrors, MirrorGotHit);
					end if;
				end Loop;
					
				If Laser.GoingUp = true then
					Laser.Y := Laser.Y+1;
				elsif Laser.GoingDown = True then
					Laser.Y := Laser.Y-1;
				elsif Laser.GoingDown = True then
					Laser.X := Laser.X+1;
				elsif Laser.GoingLeft = True then
					Laser.X := Laser.X-1;
				end if;
			else
				Laser.ShotFinished := True;
				If Laser.X <= Laser.OutsideLeftSide then
					Laser.LaserXY := (Laser.X, Laser.Y);
					Screen.MoveCursor (Laser.LaserXY);
					Put ("-");
				elsif Laser.X >= Laser.OutsideRightSide then
					Laser.LaserXY := (Laser.X, Laser.Y);
					Screen.MoveCursor (Laser.LaserXY);				
					Put ("-");
				elsif Laser.Y >= Laser.OutsideTopSide then
					Laser.LaserXY := (Laser.X, Laser.Y);
					Screen.MoveCursor (Laser.LaserXY);				
					Put ("|");
				elsif Laser.Y <= Laser.OutsideBottomSide then
					Laser.LaserXY := (Laser.X, Laser.Y);
					Screen.MoveCursor (Laser.LaserXY);
					Put ("|");
				end if;
			end if;
		End MoveLaser;

	Begin --Lazzer
--	Screen.Graphicson;
	Screen.ClearScreen;
	For index in 1..132 loop
		Mirrors(Index).MirrorsX(Index) := 1;
		Mirrors(Index).MirrorsY(Index) := 1;
	end loop;
--		Ada.Text_IO.Unbounded_IO.Get_Line (Input);
		If Input = ASCII.ESC& "[D" then
			Choice.LeftArrow := True;
			Choice.RightArrow := False;
			Choice.Space := False;
			MoveCarrot (Input, Laser, Carrot,Corner,Choice);
		elsif Input = ASCII.ESC& "[C" then
			Choice.LeftArrow := False;
			Choice.RightArrow := True;
			Choice.Space := False;
			MoveCarrot (Input, Laser, Carrot,Corner,Choice);
		elsif Input = " " then
			Choice.LeftArrow := False;
			Choice.RightArrow := False;
			Choice.Space := True;
			InitialLaserDirection(Laser, Carrot);
			Laser.ShotFired	:= True;
			Laser.ShotFinished := False;
			Loop
			Exit when Laser.ShotFinished = true;
				MoveLaser(Laser, Mirrors, MirrorGotHit);
			end loop;
		end if;
--	end loop;
	End Lazzer;
	
	
	
	
-- Billy
	procedure Retract(Gameboard: in out Boardtype; 
								guess_count, shot_counter: in out Integer) is  -- needs continue work on
	--	retract_amt: Integer:= 0;
		
		begin -- retract
		If GameBoard.Moves.Next /= null then 
			If GameBoard.Moves.Length < 5 then -- number of retracts left ?
				If GameBoard.Moves.Next.MoveType = GameBoard.Moves.Next.Guess then
					guess_count:= guess_count - 1;
					Delete(Gameboard.Guesses, Gameboard.Guesses.Next);
					-- 
					-- not sure if need to do something with Gameboard.Guesses.Length
					-- 
				Elsif GameBoard.Moves.Next.MoveType = GameBoard.Moves.Next.Move then
				   -- ******************
				   -- need spencer for this
					-- ******************
				Elsif GameBoard.Moves.Next.MoveType = GameBoard.Moves.Next.Shot then 
					Shot_counter = shot_counter + 1
				Else
					Null; -- nothing was done yet
				end if;
			Else
				Null;  -- they used all their undos
			end if;
		Else
			Null; -- they havnt guessed yet, do not change retract
		end if;
	end retract;
	
	procedure Guess is -- just formatted alignment
		min: Integer:= 5;
		max: Integer:= 35;
		begin -- Guess
-- guess_array is array(min..max) of Integer
			If Menu_selection = 1 then
				Max:= 10;
				If guesses < 5 then
					guess_count:= guess_count + 1;
				Elsif guesses = 5 and retract_amt = 0 then
					Correct_all();
				Elsif guesses > 10 then
					Game_Over();
				Elsif guesses < 10 and guesses > 5 and retract_amt = 0 then
					Correct_all();
				Else
					Game_Over();
				end if;
			ElsIf Menu_selection = 2 then
				Min:= 10;
				Max:= 15;
				If guesses < 10 then
					guess_count goes up one
				Elsif guesses =  10 and retract_amt = 0 then
					Correct_all();
				Elsif guesses > 15 then
					Game_over();
				Elsif guesses < 15 and guesses > 10 and retract_amt = 0 then
					Correct_all();
				Else
					Game_Over();
				end if;
			ElsIf Menu_selection = 3 then
				Min:= 15 ;
				Max:= 20;
				If guesses < 15 then
					guess_count goes up one
				Elsif guesses = 15 and retract_amt = 0 then
					Correct_all();
				Elsif guesses  > 20 then
					Game_over();
				Elsif guesses < 20 and guesses > 15 and retract_amt = 0 then
					Correct_all();
				Else
					Game_Over();
				end if;
			Elsif Menu_selection = 4 then
				Min:= 30;
				Max:= 35;
				If guesses < 30 then
					guess_count goes up one
				Elsif guesses = 30 and retract_amt = 0 then
					Correct_all();
				Elsif guesses > 35 then 
					Game_Over();
				Elsif guesses < 35 and guesses > 30 and retract_amt = 0 then
					Correct_all();
				Else
					Game_Over();
				end if;
			end if;
			
			Get aGuess(location and angle (45 or 315))
			If aGuess is correct position of mirror
				If angle is 45 then
					Put ‘/’ in position of mirror
				Else
					Put ‘\’ in position of mirror
					Put aguess in list at right side of board
					Put aguess location in green font
			Else 
				Put aguess in list at right side of board
				Put aguess location in red font						
				Correct_all();
				Index:= 1;
				Loop
					Exit when guess_array(index) /= correct position ;
					If Guess_array(index) = correct position then
						Index:= index + 1;
						If index > max then
							Win();
						End if;
					End if;
				End loop;
				If retract_amt = 0 then
					Game_Over();
				End if;
			end if;
	end guess;

	procedure Win() is      -- needs button_press cmd
		begin -- Win
		Put("You Won!!! You are awesome!");
		New_Line;
		Put("Press any key to return to the main menu");
		-- ********
		-- Bring player back to main menu after a keypress
		-- ********
		If button_press = true then
			Menu();
		else
			null;
		end if;
	end Win;

	procedure Game_Over() is       -- needs button_press cmd and displaying of mirrors
		begin --Game_Over
			Put("Sorry but you were not able to finish the game in the allotted settings...");
			New_Line;
		-- *********
		--	Display positions of correct mirror locations	
		-- *********
			New_Line;
			Put("Press any key to return to the main menu");
		-- *********
		-- Bring player back to main menu after a keypress
		-- *********
		If button_press = true then
			Menu();
		else
			null;
		end if;
	end game_over;
	
	procedure Help() is		-- need enumerations, help w/ if game is running, just aligned
		choice: help_option;
		pick: Boolean:= False;
		begin -- Help
			while pick /= true loop
				Display help_options (enumeration)
				Ask for choice 
				If choice = About Game
					About_Game();
					Go back to help menu
				Elsif choice is Controls
					Controls()
					Go back to help menu
				Elsif choice is Difficulties
					Difficulties()
					Go back to help menu
				Else – goto main menu or back to game
					If the game has been started then
						Execute();
						-- need from someone
						pick: = True;
					Else
						Menu();
						pick: = True;
					end if;
			End loop;
	end help;

	procedure About_Game() is         -- need keypress
		begin -- About_Game
		Put("The object of the game is to recreate the arrangement of mirrors in the box.");
		New_Line;
		Put("You must deduce the placement of the mirrors by firing lasers into the sides of the box,");
		New_Line;
		Put("and observing where they exit. When a laser hits one of the two types of mirrors,");
		New_Line;
		Put("it is reflected at a 90 degree angle.");
		New_Line(2);
		Put("Morgan Showman, Spencer Johnson, Tony Grieb, and William Mearns created the black box");
		New_Line;
		Put("game for our project in CS 1350.");
		New_Line(2);
		Put("Press any key to return to the main menu");
		-- *********
		-- Bring player back to main menu after a keypress
		-- *********
		If button_press = true then
			Menu();
		else
			null;
		end if;
	end about_game;

	procedure Difficulties() is      -- need keypress
		begin -- Difficulties
		Put("There are 4 different difficulties in this game: Easy, Intermediate, Hard, and Insane.");
		New_Line;
		Put("There are 5, 10, 15, and 30 mirrors and 25, 30, 45, and 90 shots corresponding to each");
		New_Line;
		Put("level of difficulty. Also, the size of the box will increase according to the difficulty:");
		New_Line;
		Put("5x5 for easy, 6x6 for both intermediate and hard, and 10x10 for insane.");		
		New_Line(2);
		Put("Press any key to return to the main menu");
		-- *********
		-- Bring player back to main menu after a keypress
		-- *********
		If button_press = true then
			Menu();
		else
			null;
		end if;
	end difficulties;
	
	procedure Controls() is       -- need keypress
		begin -- Controls
		Put("These are the only buttons which will not be ignored");
		New_Line(2);
		Put("right arrow : move cursor clockwise");
		New_Line;
		Put("left arrow : move cursor counter-clockwise");
		New_line;
		Put("up arrow : move cursor retract move");
		New_Line;
		Put("space : fire laser");
		New_Line;
		Put("g : make a guess");
		New_Line;
		Put("h : help");
		New_Line(2);
		Put("Press any key to return to the main menu");
		-- *********
		-- Bring player back to main menu after a keypress
		-- *********
		If button_press = true then
			Menu();
		else
			null;
		end if;
	end controls;


	

>>>>>>> MorganShowman/master:actions.adb

