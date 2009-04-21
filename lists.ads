------------------------------------------------------------------------------
--                                                                          --
--                    MORGAN SHOWMAN RUNTIME COMPONENTS                     --
--                                                                          --
--                         L I N K E D _ L I S T S                          --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                             $ Revision: 3 $                              --
--                                                                          --
------------------------------------------------------------------------------

GENERIC
	TYPE ElementType IS PRIVATE;
	WITH FUNCTION "<" (Left, Right : ElementType) RETURN Boolean;
PACKAGE Linked_Lists IS

	TYPE ListNode;
		TYPE NodePointer IS ACCESS ListNode;
	TYPE ListNode IS RECORD
		Element : ElementType;
		Next : NodePointer := NULL;
	END RECORD;

	TYPE List IS RECORD
		Next : NodePointer := NULL;
		Tail : NodePointer := NULL;
		Length : Integer;
	END RECORD;

	PROCEDURE Initialize	(Lst : IN OUT List);
	FUNCTION  MakeNode		(Element : ElementType) RETURN NodePointer;
	FUNCTION  IsEmpty		(Lst : List) RETURN Boolean;

	FUNCTION  GetElement	(Node : NodePointer) RETURN ElementType;

	PROCEDURE Go_To_Start	(Lst : IN OUT List);
	PROCEDURE Get_Next		(Lst : IN OUT List; Item : OUT ElementType);
	FUNCTION  At_End		(Lst : List) RETURN Boolean;

	PROCEDURE Insert		(Lst : IN OUT List; Node : NodePointer);
	PROCEDURE InsertInFront	(Lst : IN OUT List; Node : NodePointer);
	PROCEDURE InsertAfter	(Lst : IN OUT List; LeftNode, RightNode : NodePointer);
	PROCEDURE Append		(Lst : IN OUT List; Node : NodePointer);

	PROCEDURE Delete		(Lst : IN OUT List; Node : NodePointer);

END Linked_Lists;