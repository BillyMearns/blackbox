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
With Lists;

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
	procedure Retract(Gameboard: in out Boardtype; retract_amt: out GameBoard.Moves.Length;
								guess_count: Gameboard.guesses.length; shot_counter: in out Integer;
								the_guesses: in out GuessElement; MoveRecord: in out MoveElement) is 
								
			gues:GameBoard.Moves.Next.MoveType:= guess;
			sht:GameBoard.Moves.Next.MoveType:= shot;
			mov:GameBoard.Moves.Next.MoveType:= move;
			spot: moverecord.cposition;
			lase: moverecord.lposition;
		begin -- retract
		retract_amt:= 0;
		If GameBoard.Moves.Next /= null then 
			If retract_amt <= 5 then -- number of retracts left ?
				If MoveRecord.MoveType = gues then
					guess_count:= guess_count - 1; -- removes a guess from count thus adding a guess
					Stack.Pop(moveRecord, the_guesses);
				Elsif MoveRecord.MoveType = mov then
					Stack.Pop(moveRecord, spot); 
					Gameboard.carrotposition:= spot;
				Elsif MoveRecord.MoveType = sht then 
					Stack.Pop(moveRecord, lase);
					Gameboard.laserposition:= lase;
					Shot_counter = shot_counter + 1;
				Else
					Null; -- nothing was done yet
				end if;
			Else
				Null;  -- they used all their undos
			end if;
			retract_amt:= retract_amt + 1;
		Else
			Null; -- they havnt guessed yet, do not change retract
		end if;
	end retract;
	
	procedure Guess (GameBoard: in out BoardType; Selection: Difficulty; 
						retract_amt: GameBoard.Moves.Length; guess_count: in out Gameboard.guesses.length;
						the_guesses: in out GuessElement; MoveRecord: in out MoveElement)  is

		begin -- Guess
			If selection = easy then
				If guess_count < 5 then -- number of guesses 
					guess_count:= guess_count + 1;
				Elsif guess_count = 5 and retract_amt = 0 then -- if out of guesses and retracts
					Correct_all(gameboard, guess_count);
				Else -- out of guesses
					End_of_Game:= True;;
				end if;
			ElsIf selection = intermediate then
				If guess_count < 10 then
					guess_count:= guess_count + 1;
				Elsif guess_count =  10 and retract_amt = 0 then
					Correct_all(gameboard, guess_count);
				Else
					End_of_Game:= True;;
				end if;
			ElsIf selection = hard then
				If guess_count < 15 then
					guess_count:= guess_count + 1;
				Elsif guess_count = 15 and retract_amt = 0 then
					Correct_all(gameboard, guess_count);
				Else
					End_of_Game:= True;;
				end if;
			Elsif selection = insane then
				If guess_count < 30 then
					guess_count := guess_count + 1;
				Elsif guesses = 30 and retract_amt = 0 then
					Correct_all(gameboard, guess_count);
				Else
					End_of_Game:= True;;
				end if;
			end if;
			
			Get(Guess_pos); -- location of guess(a..j,1.10)
			Get(Guess_ang); -- which mirror True(45) or false(135)	
			If  gameboard.box(guess_pos).Mirror = true and
						 gameboard.box(guess_pos).Angle = guess_ang then
				-- if the guess is correct
				the_guesses.guessposition:= guess_pos;
				the_guesses.guessangle:= guess_ang;
				the_guesses.iscorrect:= true;
				Screen.Set_Color(32);
				Put(Guess_pos, Width => 4);
				If guess_ang = true then
					Put("  45");
				else
					Put(" 135");
				end if;
				Screen.Set_Color(37);
				New_Line;
			Else 
				the_guesses.guessposition:= guess_pos;
				the_guesses.guessangle:= guess_ang;
				the_guesses.iscorrect:= false;
					Screen.Set_Color(31);
				Put(Guess_pos, Width => 4);
				If guess_ang = true then
					Put("  45");
				else
					Put(" 135");
				end if;
				Screen.Set_Color(37);
				New_Line;
			end if;
			MoveRecord.guess:= Stack.Append(gameboard.guesses, the_guesses);
			MoveRecord:= gameboard.guesses.tail;
			Stack.Push(Guess_move, MoveRecord);	
			-- ??
	end guess;
	
	procedure Correct_all(gameboard: boardtype; GuessRecord: GuessElement;
						guess_count: Gameboard.guesses.length) is	
		index: Integer:= 1;
		current: GuessRecord;
		correct: Gameboard.guesses.next.IsCorrect;
		begin -- correct_all
			Loop
				If  gameboard.box(current.pos).Mirror = true and
						 gameboard.box(current.pos).Angle = guess_ang then
					correct:= true;
				else
					correct:= false;
				end if;
				Exit when correct = false;
				If correct = true  then
					Index:= index + 1;
					If index > guess_count then
						Win;
					End if;
				End if;
			End loop;
			If retract_amt = 0 and correct = false then
				End_of_Game:= True;;
			End if
	end correct_all;	


	procedure Win is     
		button_press: Unbounded_string;
		begin -- Win
		Put("You Won!!! You're awesome!");
		New_Line;
		Put("Press any key to return to the main menu");
		Get(button_press);
		Menu();
	end Win;
	
	procedure Help is	
		choice: help_option;
		pick: Boolean:= False;
		key: Boolean:= False;
		origin_spot: Gameboard.carrotposition;
		keypress: Character;
		begin -- Help
			while pick /= true loop
				Put("1 About the Game");
				New_Line;
				Put("2 Controls");
				New_Line;
				Put("3 The difficulties");
				New_Line;
				Put("4 Go Back");
				Get(keypress);
				while key = false loop
					If keypress = 1 then
						choice:= About_Game;
						key:= true;
					elsif keypress = 2 then
						choice:= Controls;
						key:= true;
					elsif keypress = 3 then
						choice:= Difficulties;
						key:= true;
					elsif keypress = 4 then
						choice:= Quit;
						key:= true;
					else
						Null; -- not a valid key pressed
					end if;
				If choice = About_Game then
					About_Game;
					Go back to help menu
				Elsif choice is Controls
					Controls
					Go back to help menu
				Elsif choice is Difficulties
					Difficulties
					Go back to help menu
				Else -- goto main menu or back to game
					origin_spot.side:= right;
					origin_spot.index:= 1;
					If GameBoard.CarrotPosition /= origin or GameBoard.guesses.length /= 0 or
								Gameboard.shots /= 25 or Gameboard.shots /= 30 or 
								Gameboard.shots /= 45 or gameboard.shots /= 90 then
							-- the game has started
						pick:= True;
					Else
						Menu();
						pick:= True;
					end if;
			End loop;
	end help;

	procedure About_Game is       
		button_press: Unbounded_string;
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
		Put("Enter any key to return to the main menu");
		Get(button_press);
		Help;
	end about_game;

	procedure Difficulties is     
		button_press: unbounded_string;
		begin -- Difficulties
		Put("There are 4 different difficulties in this game: Easy, Intermediate, Hard, and Insane.");
		New_Line;
		Put("There are 5, 10, 15, and 30 mirrors and 25, 30, 45, and 90 shots corresponding to each");
		New_Line;
		Put("level of difficulty. Also, the size of the box will increase according to the difficulty:");
		New_Line;
		Put("5x5 for easy, 6x6 for both intermediate and hard, and 10x10 for insane.");		
		New_Line(2);
		Put("Enter any key to return to the main menu");
		Get(button_press);
		Help;
	end difficulties;
	
	procedure Controls is      
		button_press: Unbounded_String;
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
		Put("After g is entered, two inputs are needed: the first is the position in the box");
		New_Line;
		Put("wanted to guess at(A..J,1..10); the second is the type of mirror(True=45 or False=135).");
		New_Line;
		Put("h : help");
		New_Line(2);
		Put("Enter any key to return to the main menu");
		Get(button_press);
		Help;
	end controls;


	

>>>>>>> MorganShowman/master:actions.adb

