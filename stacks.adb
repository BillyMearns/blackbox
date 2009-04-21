------------------------------------------------------------------------------
--                                                                          --
--                    MORGAN SHOWMAN RUNTIME COMPONENTS                     --
--                                                                          --
--                        L I N K E D _ S T A C K S                         --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                             $ Revision: 2 $                              --
--                                                                          --
------------------------------------------------------------------------------

PACKAGE BODY Linked_Stacks IS

	PROCEDURE MakeEmpty (S : IN OUT Stack) IS
	BEGIN	-- Make Empty
		Initialize(S);
	END MakeEmpty;

	FUNCTION  IsEmpty (S : Stack) RETURN Boolean IS
	BEGIN	-- Is Empty
		RETURN S.Next = NULL;
	END IsEmpty;

	PROCEDURE Push (S : IN OUT Stack; Item : ElementType) IS
	BEGIN	-- Push
		InsertInFront(S,MakeNode(Item));
	END Push;

	PROCEDURE Pop (S : IN OUT Stack; Item : OUT ElementType) IS
	BEGIN	-- Pop
		IF NOT IsEmpty(S) THEN
			Item := GetElement(S.Next);
			Delete(S,S.Next);
		END IF;
	END Pop;

	FUNCTION Top (S : Stack) RETURN ElementType IS
	BEGIN	-- Top
		RETURN GetElement(S.Next);
	END Top;

END Linked_Stacks;