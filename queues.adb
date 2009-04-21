------------------------------------------------------------------------------
--                                                                          --
--                    MORGAN SHOWMAN RUNTIME COMPONENTS                     --
--                                                                          --
--                        L I N K E D _ Q U E U E S                         --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                             $ Revision: 1 $                              --
--                                                                          --
------------------------------------------------------------------------------

PACKAGE BODY Linked_Queues IS

	PROCEDURE MakeEmpty (Q : IN OUT Queue) IS
	BEGIN	-- Make Empty
		Initialize(Q);
	END MakeEmpty;

	FUNCTION IsEmpty (Q : Queue) RETURN Boolean IS
	BEGIN	-- Is Empty
		RETURN Q.Next = NULL;
	END IsEmpty;

	PROCEDURE Enque (Q : IN OUT Queue; Item : ElementType) IS
	BEGIN	-- Enque
		Append(Q,MakeNode(Item));
	END Enque;

	PROCEDURE Deque (Q : IN OUT Queue; Item : OUT ElementType) IS
	BEGIN	-- Deque
		IF NOT IsEmpty(Q) THEN
			Item := GetElement(Q.Next);
			Delete(Q,Q.Next);
		END IF;
	END Deque;

	FUNCTION Front (Q : Queue) RETURN ElementType IS
	BEGIN	-- Front
			RETURN GetElement(Q.Next);
	END Front;

END Linked_Queues;