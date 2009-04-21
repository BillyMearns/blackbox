------------------------------------------------------------------------------
--                                                                          --
--                    MORGAN SHOWMAN RUNTIME COMPONENTS                     --
--                                                                          --
--                         L I N K E D _ L I S T S                          --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                             $ Revision: 3 $                              --
--                                                                          --
------------------------------------------------------------------------------

WITH Unchecked_Deallocation;
WITH Ada.Text_IO;
PACKAGE BODY Linked_Lists IS

	PROCEDURE Dispose IS NEW Unchecked_Deallocation(ListNode,NodePointer);

	PROCEDURE Initialize (Lst : IN OUT List) IS
		Ptr : NodePointer := Lst.Next;
		TrailPtr : NodePointer;
	BEGIN	-- Initialize
		IF Ptr = NULL THEN
			Lst.Next := NULL;
			Lst.Tail := NULL;
		ELSE
			WHILE Ptr /= NULL LOOP
				TrailPtr := Ptr;
				Ptr := Ptr.Next;
				Dispose(TrailPtr);
			END LOOP;
			Lst.Next := NULL;
			Lst.Tail := NULL;
		END IF;
	END Initialize;

	FUNCTION MakeNode (Element : ElementType) RETURN NodePointer IS
		Node : NodePointer := NEW ListNode;
	BEGIN	-- Make Node
		Node.Element := Element;
		RETURN Node;
	END MakeNode;

	FUNCTION IsEmpty (Lst : List) RETURN Boolean IS
	BEGIN	-- Is Empty?
		RETURN Lst.Next = NULL;
	END IsEmpty;

	FUNCTION GetElement (Node : NodePointer) RETURN ElementType IS
	BEGIN	-- Make Node
		RETURN Node.Element;
	END GetElement;

	PROCEDURE Go_To_Start (Lst : IN OUT List) IS
	BEGIN	-- Go To Start
		Lst.Next := Lst.Next;
	END Go_To_Start;

	PROCEDURE Get_Next (Lst : IN OUT List; Item : OUT ElementType) IS
	BEGIN	-- Get Next
		Item := GetElement (Lst.Next);
		Lst.Next := Lst.Next.Next;
	END Get_Next;

	FUNCTION At_End (Lst : List) RETURN Boolean IS
	BEGIN	-- At End
		RETURN Lst.Next = NULL;
	END At_End;

	PROCEDURE Insert (Lst : IN OUT List; Node : NodePointer) IS
		Ptr : NodePointer := Lst.Next;
		TrailPtr : NodePointer;
		Found : Boolean := False;
	BEGIN	-- Insert In Order
		IF IsEmpty(Lst) THEN
			InsertInFront(Lst,Node);
		ELSIF Node.Element < Ptr.Element THEN
			InsertInFront(Lst,Node);
		ELSE
			WHILE Ptr /= NULL AND NOT Found LOOP
				IF Node.Element < Ptr.Element THEN
					Found := True;
				ELSE
					TrailPtr := Ptr;
					Ptr := Ptr.Next;
				END IF;
			END LOOP;
			IF Ptr = NULL THEN
				Append(Lst,Node);
			ELSE
				InsertAfter(Lst,TrailPtr,Node);
			END IF;
		END IF;
	END Insert;

	PROCEDURE InsertInFront (Lst : IN OUT List; Node : NodePointer) IS
	BEGIN	-- Insert In Front
		Node.Next := Lst.Next;
		Lst.Next := Node;
	END InsertInFront;

	PROCEDURE InsertAfter (Lst : IN OUT List; LeftNode, RightNode : NodePointer) IS
	BEGIN	-- Insert After
		RightNode.Next := LeftNode.Next;
		LeftNode.Next := RightNode;
		IF RightNode.Next = NULL THEN
			Lst.Tail := LeftNode.Next;
		END IF;
	END InsertAfter;

	PROCEDURE Append (Lst : IN OUT List; Node : NodePointer) IS
		Ptr : NodePointer := Lst.Next;
	BEGIN	-- Append
		IF IsEmpty(Lst) THEN
			Lst.Next := Node;
			Lst.Tail := Lst.Next;
		ELSE
			WHILE Ptr.Next /= NULL LOOP
				Ptr := Ptr.Next;
			END LOOP;
			Ptr.Next := Node;
			Lst.Tail := Ptr.Next;
		END IF;
	END Append;

	PROCEDURE Delete (Lst : IN OUT List; Node : NodePointer) IS
		Ptr : NodePointer := Lst.Next;
		TrailPtr : NodePointer;
		Item : ElementType := GetElement(Node);
	BEGIN	-- Delete
		IF Lst.Next = Node AND Lst.Tail = Node THEN
			-- only node
			Dispose(Ptr);
			Lst.Next := NULL;
			Lst.Tail := NULL;
		ELSIF Ptr = Node THEN
			-- first node
			Lst.Next := Ptr.All.Next;
			Dispose(Ptr);
		ELSIF Lst.Tail = Node THEN
			-- is last
			WHILE Ptr.Next /= NULL AND THEN Ptr.Next /= Node LOOP
				Ptr := Ptr.Next;
			END LOOP;
			Lst.Tail := Ptr;
			Dispose(Ptr.Next);
		ELSE
			-- in middle
			WHILE Ptr.Next /= NULL AND THEN Ptr.Next.All.Element /= Item LOOP
				TrailPtr := Ptr;
				Ptr := Ptr.Next;
			END LOOP;
			TrailPtr.Next := Ptr.Next;
			Dispose(Ptr);
		END IF;
	END Delete;

END Linked_Lists;