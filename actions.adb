PACKAGE BODY Actions IS

END Actions;

--Lazer mover/Firerer
With Ada.Text_IO; Use Ada.Text_IO;
With Ada.Integer_Text_IO; Use Ada.Integer_Text_IO;
With Ada.Strings.Unbounded; Use Ada.Strings.Unbounded;
With Ada.Text_IO.Unbounded_IO; Use Ada.Text_IO.Unbounded_IO;
With Ada.Strings; Use Ada.Strings;
With Screen;
With Windows;

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
