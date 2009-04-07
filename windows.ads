WITH Screen;
PACKAGE Windows IS
------------------------------------------------------------------
--| Manager for simple, nonoverlapping screen windows
--| Author: Michael B. Feldman, The George Washington University 
--| Last Modified: October 1995                                     
------------------------------------------------------------------

  TYPE Window IS PRIVATE;

  FUNCTION Open (UpperLeft: Screen.Position;
                 Height   : Screen.Height;
                 Width    : Screen.Width) RETURN Window;
  -- Pre:  UpperLeft, Height, and Width are defined
  -- Post: returns a Window with the given upper-left corner,
  --   height, and width

  PROCEDURE Title (W     : IN OUT Window;
                   Name  : IN String;
                   Under : IN Character);
  -- Pre:  W, Name, and Under are defined
  -- Post: Name is displayed at the top of the window W, underlined
  -- with the character Under. 

  PROCEDURE Borders (W                    : IN OUT Window;
                     Corner, Down, Across : IN Character);
  -- Pre:  All parameters are defined
  -- Post: Draw border around current writable area in window with 
  -- characters specified.  Call this BEFORE Title.  

  PROCEDURE MoveCursor (W : IN OUT Window;
                        P : IN Screen.Position);
  -- Pre:  W and P are defined, and P lies within the area of W
  -- Post: Cursor is moved to the specified position.
  --   Coordinates are relative to the
  --   upper left corner of W, which is (1, 1) 

  PROCEDURE Put (W  : IN OUT Window;
                 Ch : IN Character);
  -- Pre:  W and Ch are defined.
  -- Post: Ch is displayed in the window at 
  --   the next available position.
  --   If end of column, go to the next row.
  --   If end of window, go to the top of the window. 

  PROCEDURE Put (W : IN OUT Window;
                 S : IN String);
  -- Pre:  W and S are defined
  -- Post: S is displayed in the window, "line-wrapped" if necessary

  PROCEDURE New_Line (W : IN OUT Window);
  -- Pre:  W is defined
  -- Post: Cursor moves to beginning of next line of W;
  --   line is not blanked until next character is written  

PRIVATE
  TYPE Window IS RECORD
    First  : Screen.Position; -- coordinates of upper left
    Last   : Screen.Position; -- coordinates of lower right
    Current: Screen.Position; -- current cursor position
  END RECORD;

END Windows;
