------------------------------------------------------------------------------
--                                                                          --
--                    MORGAN SHOWMAN RUNTIME COMPONENTS                     --
--                                                                          --
--                        L I N K E D _ S T A C K S                         --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                             $ Revision: 2 $                              --
--                                                                          --
------------------------------------------------------------------------------

WITH Linked_Lists;

GENERIC
	TYPE ElementType IS PRIVATE;
	WITH FUNCTION "<" (Left, Right : ElementType) RETURN Boolean;
PACKAGE Linked_Stacks IS

	PACKAGE StackList IS NEW Linked_Lists(ElementType,"<");
	USE StackList;

	TYPE Stack IS NEW List;

	PROCEDURE MakeEmpty (S : IN OUT Stack);
	FUNCTION  IsEmpty (S : Stack) RETURN Boolean;
	PROCEDURE Push (S : IN OUT Stack; Item : ElementType);
	PROCEDURE Pop (S : IN OUT Stack; Item : OUT ElementType);
	FUNCTION  Top (S : Stack) RETURN ElementType;

END Linked_Stacks;