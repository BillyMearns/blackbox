PACKAGE Types IS

	TYPE Boxes IS
	RECORD
		Mirror : Boolean := False;
		Angle  : Boolean;
		Window : WindowType;
	END RECORD;

	TYPE CPosition IS
	RECORD
		Side  : 
		Index : Integer(1..10);
	END RECORD;

	TYPE BoardType IS
	RECORD
		Length			: Integer;
		Box				: ARRAY('A'..'J',1..10) OF Boxes;
		CarrotPosition	: CPosition;
		Shots			: Integer;
		Guesses			: Integer;
		Moves			: MoveQueue;
	END RECORD;
	
END Types; 
