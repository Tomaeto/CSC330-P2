with Ada.IO_Exceptions; 	use Ada.IO_Exceptions;
with Ada.Text_IO; 		use Ada.Text_IO;
with Ada.Strings;		use Ada.Strings;
with Ada.Strings.Unbounded;	use Ada.Strings.Unbounded;
with Text_IO.Unbounded_IO;	use Text_IO.Unbounded_IO;
with Ada.Containers.Vectors;	use Ada.Containers;
   procedure formatScr is
	
	infile : Ada.Text_IO.File_Type;
	value : Character;
	lastval : Character;
	str_arr : array(1..5000000) of Character;
	word : Unbounded_String;
	line : Unbounded_String := Null_Unbounded_String;
	filename : Unbounded_String := Null_Unbounded_String;
	package Line_Vectors is new Vectors(Natural, Unbounded_String);
	words : Line_Vectors.Vector;
	lines : Line_Vectors.Vector;
	pos : Integer;
	arr_pos : Integer;
	numwords : Integer;
	mostnum : Integer;
	mostLine : Unbounded_String;
	leastnum : Integer;
	leastLine : Unbounded_String;
  begin
	--Getting user input for input file
	Put("Enter input file path: ");
	Text_IO.Unbounded_IO.Get_Line(filename);


    Ada.Text_IO.Open (File => infile, Mode => Ada.Text_IO.In_File, Name => To_String(filename));

    pos := 0;
    lastval := Character'Val(0);
    --Putting chars from input file into array
    --Any numbers or extra spaces are removed
    while not Ada.Text_IO.End_Of_File(infile) loop
        Ada.Text_IO.Get_Immediate (File => infile, Item => value);
	pos := pos + 1;
	str_arr(pos) := value;
	--Replaces any numbers or double spaces w/ empty char
	if value <= '9' and value >= '0' then
		str_arr(pos) := Character'Val(0);
		pos := pos - 1;
	elsif value = ' ' and lastval = ' ' then
		str_arr(pos) := Character'Val(0);
		pos := pos -1;
	--Replaces newline character w/ space
	elsif value = Character'Val(13) or value = Character'Val(10) then
		str_arr(pos) := ' ';
	end if;
	lastval := value;
    end loop;

    --Getting all words from array and putting them into vector
    --Finds spaces and gets all characters b/w spaces to get words
    arr_pos := 1;
    for i in 1..pos loop
	word := Null_Unbounded_String;
	if str_arr(i) = ' ' then
	    for j in arr_pos..i loop
		Append(word, str_arr(j));
	    end loop;
	arr_pos := i;	
	Trim(word, Both);
	words.Append(word);
	end if;
    --Getting last word and putting it into vector	
    end loop;
	for j in arr_pos..pos loop
		Append(word, str_arr(j));
	end loop;
    Trim(word, Both);
    words.Append(word);

    --Building formatted lines w/ max of 60 chars and words
    --	not split across lines
    --Also finding lines w/ most and least number of words
    word := words.First_Element;
    mostnum := 0;
    leastnum := 0;
    numwords := 0;
    while words.length /= 0 loop
	--Adding word to line if word fits, adding space if it fits
	--Deleting word from vector once it is added to line
	if Length(line) + Length(word) <= 60 then
	    Append(line, word);
	    numwords := numwords + 1;
	    words.Delete_First;
	    if words.length >= 1 then
	    word := words.First_Element;
	    end if;
	    if Length(line) < 60 then
	    	Append(line, " ");
	    end if;
	else
	--If next word cannot fit in line, adding line to vector of lines and checking
	--	if current line has either most or least number of words, storing if
	--	true, and resetting line to null
		lines.Append(line);
		if numwords > mostnum then
		    mostLine := line;
		    mostnum := numwords;
                elsif numwords < leastnum or leastnum = 0 then
			leastLine := line;
			leastnum := numwords;
		end if;
		numwords := 0;
		line := Null_Unbounded_String;	
	end if;
    end loop;
	--Adding remaining line to vector and checkign if it has either
	--	most or least number of words
	lines.Append(line);
	if numwords > mostnum then
		mostLine := line;
		mostnum := numwords;
	elsif numwords < leastnum or leastnum = 0 then
		leastLine := line;
		leastnum := numwords;
	end if;
	--Testing if lines were built correctly
	for i in 1..lines.length loop
		Put_Line(lines.First_Element);
		lines.Delete_First;
	end loop;
	Put_Line(" ");
	Put_Line(mostLine);
	Put_Line(leastLine);
  end formatScr;
