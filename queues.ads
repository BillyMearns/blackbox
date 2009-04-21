------------------------------------------------------------------------------
--                                                                          --
--                    MORGAN SHOWMAN RUNTIME COMPONENTS                     --
--                                                                          --
--                        L I N K E D _ Q U E U E S                         --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                             $ Revision: 1 $                              --
--                                                                          --
------------------------------------------------------------------------------

WITH Linked_Lists;

GENERIC
	TYPE ElementType IS PRIVATE;
	WITH FUNCTION "<" (Left, Right : ElementType) RETURN Boolean;
PACKAGE Linked_Queues IS

	PACKAGE QueueList IS NEW Linked_Lists(ElementType,"<");
	USE QueueList;

	TYPE Queue IS NEW List;

	PROCEDURE MakeEmpty (Q : IN OUT Queue);
	FUNCTION IsEmpty (Q : Queue) RETURN Boolean;
	PROCEDURE Enque (Q : IN OUT Queue; Item : ElementType);
	PROCEDURE Deque (Q : IN OUT Queue; Item : OUT ElementType);
	FUNCTION  Front (Q : Queue) RETURN ElementType;

END Linked_Queues;