GENERIC
	TYPE WindowType IS PRIVATE;
	TYPE MoveStack  IS PRIVATE;
<<<<<<< HEAD:types.ads
=======
	TYPE GuessList  IS PRIVATE;
>>>>>>> 56d4b3dced4fcfd8e9b2cbb5fa620e97afb204e7:types.ads
PACKAGE Types IS

	TYPE BoardType IS

		TYPE Boxes IS
		RECORD	-- Boxes
			Mirror : Boolean := False;
			Angle  : Boolean;
			Window : WindowType;
		END RECORD;

		TYPE CPosition IS
			TYPE SideEnum IS (Top,Right,Bottom,Left);
		RECORD	-- CPosition
			Side  : SideEnum;
			Index : Integer(1..10);
		END RECORD;

		TYPE LPosition IS
		RECORD
			InPosition	: CPosition;
			OutPosition : CPosition;
		END RECORD;

	RECORD	-- Board Type
		Length			: Integer;
		Box				: ARRAY('A'..'J',1..10) OF Boxes;
		CarrotPosition	: CPosition;
		Shots			: Integer;
		Guesses			: GuessList;
		Moves			: MoveStack;
		LaserPosition	: LPosition;
	END RECORD;

	TYPE BoxPosition IS
	RECORD	-- Box Position
		X : Character('A'..'J');
		Y : Integer  ( 1 .. 10);
	END RECORD;

	-- Type Move Element is used
	-- as the ElementType of the MoveStack
	TYPE MoveElement IS
		TYPE MoveEnum IS (Move,Shot,Guess);
		
		FUNCTION "<" (Left,Right : MoveElement) RETURN Boolean IS
		BEGIN	-- Move Element "<"
			RETURN Left.Length < Right.Length;
		END "<";
		
	RECORD -- Move Element
		MoveType			: MoveEnum;
		CarrotPosition		: CPosition;
		GuessPosition		: BoxPosition;
		LaserPosition		: LPosition;
	END RECORD;

	TYPE GuessElement IS
	RECORD
		GuessPosition : BoxPosition;
		GuessAngle : Boolean;
		IsCorrect : Boolean;
	END RECORD;

	TYPE Difficulty IS (Easy,Intermediate,Hard,Insane);
	TYPE Option		IS (Up,Right,Left,Space,Guess,Help);
	TYPE HelpOption  IS (About_Game,Controls,Difficulties,Quit);

END Types;