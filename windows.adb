WITH Ada.Text_IO;
WITH Screen;
PACKAGE BODY Windows IS
------------------------------------------------------------------
--| Body of simple Windows package
--| Author: Michael B. Feldman, The George Washington University 
--| Last Modified: October 1995                                     
------------------------------------------------------------------

  FUNCTION Open (UpperLeft: Screen.Position;
                 Height   : Screen.Height;
                 Width    : Screen.Width) RETURN Window IS
    Result: Window;
  BEGIN
    Result.Current:= UpperLeft;
    Result.First  := UpperLeft;
    Result.Last   := (Row    => UpperLeft.Row + Height - 1, 
                      Column => UpperLeft.Column + Width - 1);
    RETURN Result; 
  END Open;

  PROCEDURE EraseToEndOfLine (W : IN OUT Window) IS
  BEGIN
    Screen.MoveCursor (W.Current);
    FOR Count IN W.Current.Column .. W.Last.Column LOOP
      Ada.Text_IO.Put (' ');
    END LOOP;
    Screen.MoveCursor (W.Current);
  END EraseToEndOfLine;

  PROCEDURE Put (W  : IN OUT Window;
                 Ch : IN CHARACTER) IS
  BEGIN

    -- If at end of current line, move to next line 
    IF W.Current.Column > W.Last.Column THEN
      IF W.Current.Row = W.Last.Row THEN
        W.Current.Row := W.First.Row;
      ELSE
        W.Current.Row := W.Current.Row + 1;
      END IF;
      W.Current.Column := W.First.Column;
    END IF;

    -- If at First char, erase line
    IF W.Current.Column = W.First.Column THEN
      EraseToEndOfLine (W);
    END IF;

    Screen.MoveCursor (To => W.Current);

     -- here is where we actually write the character!
     Ada.Text_IO.Put (Ch);
     W.Current.Column := W.Current.Column + 1;
 
  END Put;

  PROCEDURE Put (W : IN OUT Window;
                 S : IN String) IS
  BEGIN
    FOR Count IN S'Range LOOP
      Put (W, S (Count));
    END LOOP;
  END Put;

  PROCEDURE New_Line (W : IN OUT Window) IS
  BEGIN
    IF W.Current.Column = 1 THEN
      EraseToEndOfLine (W);
    END IF;
    IF W.Current.Row = W.Last.Row THEN
      W.Current.Row := W.First.Row;
    ELSE
      W.Current.Row := W.Current.Row + 1;
    END IF;
    W.Current.Column := W.First.Column;
  END New_Line;

  PROCEDURE Title (W     : IN OUT Window;
                   Name  : IN String;
                   Under : IN Character) IS
  BEGIN
    -- Put name on top line
    W.Current := W.First;
    Put (W, Name);
    New_Line (W);
    -- Underline name if desired, and reduce the writable area
    -- of the window by one line
    IF Under = ' ' THEN   -- no underlining
      W.First.Row := W.First.Row + 1;      
    ELSE                  -- go across the row, underlining
      FOR Count IN W.First.Column..W.Last.Column LOOP 
        Put (W, Under);
      END LOOP;
      New_Line (W);
      W.First.Row := W.First.Row + 2; -- reduce writable area
    END IF;
  END Title;
 
  PROCEDURE Borders (W                    : IN OUT Window;
                     Corner, Down, Across : IN Character) IS
  BEGIN
    -- Put top line of border
    Screen.MoveCursor (W.First);
    Ada.Text_IO.Put (Corner);
    FOR Count IN W.First.Column + 1 .. W.Last.Column - 1 LOOP
      Ada.Text_IO.Put (Across);
    END LOOP;
    Ada.Text_IO.Put (Corner);

    -- Put the two side lines
    FOR Count IN W.First.Row + 1 .. W.Last.Row - 1 LOOP
      Screen.MoveCursor ((Row => Count, Column => W.First.Column));
      Ada.Text_IO.Put (Down);
      Screen.MoveCursor ((Row => Count, Column => W.Last.Column));
      Ada.Text_IO.Put (Down);
    END LOOP;

    -- Put the bottom line of the border
    Screen.MoveCursor ((Row => W.Last.Row, Column => W.First.Column));
    Ada.Text_IO.Put (corner);
    FOR Count IN W.First.Column + 1 .. W.Last.Column - 1 LOOP
      Ada.Text_IO.Put (Across);
    END LOOP;
    Ada.Text_IO.Put (Corner);

    -- Make the Window smaller by one character on each side
    W.First  := (Row => W.First.Row  + 1, Column => W.First.Column  + 1);
    W.Last   := (Row => W.Last.Row - 1,   Column => W.Last.Column - 1);
    W.Current    := W.First;
  END Borders;

  PROCEDURE MoveCursor (W : IN OUT Window;
                        P : IN Screen.Position) IS
    -- Relative to writable Window boundaries, of course
  BEGIN
    W.Current.Row    := W.First.Row + P.Row;
    W.Current.Column := W.First.Column + P.Column;
  END MoveCursor;

END Windows;
