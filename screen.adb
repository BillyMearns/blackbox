WITH Ada.Characters.Latin_1;
WITH Ada.Text_IO;
WITH Ada.Integer_Text_IO;
PACKAGE BODY Screen IS
--------------------------------------------------------------
--| Body of screen-handling package
--| Author: M. B. Feldman, The George Washington University
--| Last Modified: July 1998
--------------------------------------------------------------

  PROCEDURE Beep IS
  BEGIN
    Ada.Text_IO.Put (Item => Ada.Characters.Latin_1.BEL);
    Ada.Text_IO.Flush;
  END Beep;

  PROCEDURE ClearScreen IS
  BEGIN
    Ada.Text_IO.Put (Item => Ada.Characters.Latin_1.ESC);
    Ada.Text_IO.Put (Item => "[2J");
    Ada.Text_IO.Flush;
  END ClearScreen;

  PROCEDURE MoveCursor (Column : Width; Row : Depth) IS
  BEGIN
    Ada.Text_IO.Flush;
    Ada.Text_IO.Put (Item => Ada.Characters.Latin_1.ESC);
    Ada.Text_IO.Put ("[");
    Ada.Integer_Text_IO.Put (Item => Row, Width => 1);
    Ada.Text_IO.Put (Item => ';');
    Ada.Integer_Text_IO.Put (Item => Column, Width => 1);
    Ada.Text_IO.Put (Item => 'f');
  END MoveCursor;

END Screen;

