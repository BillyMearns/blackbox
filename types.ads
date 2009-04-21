GENERIC
	TYPE WindowType IS PRIVATE;
	TYPE MoveStack  IS PRIVATE;
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

	RECORD	-- Board Type
		Length			: Integer;
		Box				: ARRAY('A'..'J',1..10) OF Boxes;
		CarrotPosition	: CPosition;
		Shots			: Integer;
		Guesses			: Integer;
		Moves			: MoveStack;
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
	END RECORD;

	TYPE Difficulty IS (Easy,Intermediate,Hard,Insane);
	TYPE Option		IS (Up,Right,Left,Space,Guess,Help);

END Types;