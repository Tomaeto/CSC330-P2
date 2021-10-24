with Ada.IO_Exceptions; 	use Ada.IO_Exceptions;
with Ada.Text_IO; 		use Ada.Text_IO;
with Ada.Strings.Unbounded;	use Ada.Strings.Unbounded;
with Text_IO.Unbounded_IO;	use Text_IO.Unbounded_IO;
   procedure formatScr is
	
	infile : Ada.Text_IO.File_Type;
	value : Character;
	lastval : Character;
	str_arr : array(1..5000000) of Character;
	filename : Unbounded_String := Null_Unbounded_String;
	pos : Integer;
  begin
	Put("Enter input file path: ");
	Text_IO.Unbounded_IO.Get_Line(filename);


    Ada.Text_IO.Open (File => infile, Mode => Ada.Text_IO.In_File, Name => To_String(filename));
 
    pos := 0;
    lastval := Character'Val(0);
    while not Ada.Text_IO.End_Of_File(infile) loop
        Ada.Text_IO.Get_Immediate (File => infile, Item => value);
	pos := pos + 1;
	str_arr(pos) := value;
	if value <= '9' and value >= '0' then
		str_arr(pos) := Character'Val(0);
		pos := pos - 1;
	elsif value = ' ' and lastval = ' ' then
		str_arr(pos) := Character'Val(0);
		pos := pos -1;
	elsif value = Character'Val(13) or value = Character'Val(10) then
		str_arr(pos) := ' ';
	end if;
	lastval := value;
        
    end loop;
	for i in 1..pos loop
	    Ada.Text_IO.Put(Item => str_arr(i));
	end loop;
	Ada.Text_IO.New_Line;
  end formatScr;
