#!/usr/bin/julia

#Program for printing formatted text from input text file
#Removes numbers and extra spaces from input lines, output lines have max of
#	60 chars w/o cutting words up across lines.
#Also outputs lines w/ greatest and least number of words.
#By Adrian Faircloth
#10-21-21

   #Getting user input for input text file path and initializing array for
   #	holding lines from file
   print("Enter input file path: ")
   filename = readline()
   longlist = String[]

#Getting lines from file, formatting lines, and pushing lines to array
open(filename) do file
   while ! eof(file)
	fileline = readline(file)
	#Deleting numbers and extra spaces from line
	#Replaces all numbers w/ 1, then removes all 1's from line,
	#	and replaces any double spaces w/ single space
	for i in 1:lastindex(fileline)
		thischar = fileline[i]
		if (isnumeric(thischar))
			fileline = replace(fileline,thischar => "1")
		end
	end
	fileline = replace(fileline,"1" => "")
	#Replaces any double spaces w/ single space until there are no more extra spaces
	while (findfirst("  ", fileline) != nothing)
		fileline = replace(fileline,"  " => " ")
	end
	push!(longlist, fileline)
   end
end
   #Building lines w/ max length of 60 and finding longest and shortest lines
   linelist = String[]
   global formLine = ""
   global index = 1
   global shortestLine = ""
   global longestLine = ""
   global numwords = 0
   global longNumwords = 0
   global shortNumwords = 0
   #Loops through each line in longlist until every word is removed and put into a formatted line
   while(index <= size(longlist, 1))
	currline = longlist[index]
	#Loops through line from longlist until every word is put into formatted line
	#	and then removed form currline
	while(length(currline) != 0)
		spaceloc = findfirst(isequal(' '), currline)
		#Gets first word in line by finding space and getting substring from start to space
		if (spaceloc != nothing)
			word = currline[1:spaceloc]
		#If there is no space, currline contains one word
		else
			word = currline
		end
		#If the word w/o the trailing space fits exactly, adds trimmed word to line
		tempword = rstrip(word, [' '])
		swap = 0
		if (length(string(formLine, tempword)) == 60 && word[end] == ' ')
			word = tempword
			swap = 1
		end
		#Adding word to formatted line if it fits
		if (length(string(formLine, word)) <= 60)	
			global formLine = string(formLine, word)	
			global numwords = numwords + 1
			#Adding space to formline if last word added had no space
			#	and line can fit another word
			if (formLine[end] != ' ' && length(formLine) < 60)
				global formLine = string(formLine, " ")
			end
			#Removing last word added to formLine from currline
			#If trailing spaced was trimmed to fit word, removing
			#	that trimmed space from currline
			currline = replace(currline, word => "", count = 1)
			if (swap == 1)
				currline = replace(currline, " " => "", count = 1)
			end
		else
			#If word cannot fit in line, push line and check if line is either longest
			#	or shortest line in terms of number of words in line
			#If either check is a tie, line w/ fewer characters is stored
			#Finally, resets both word counter and formatted line to hold next line
			push!(linelist, formLine)
			if (numwords > longNumwords)
				global longestLine = formLine
				global longNumwords = numwords
			elseif (numwords == longNumwords && length(formLine) < length(longestLine))
				global longestLine = formLine
				global longNumwords = numwords
			
			elseif (shortNumwords == 0 || numwords < shortNumwords)
				global shortestLine = formLine
				global shortNumwords = numwords
			elseif (numwords == shortNumwords && length(formLine) < length(shortestLine))
				global shortestLine = formLine
				global shortNumwords = numwords
			end
			numwords = 0
			global formLine = ""
		
		end
	end
	global index = index + 1
   end
   #Pushing final line that did not max out in words and checking if it is either
   # longest or shortest line
   push!(linelist, formLine)
   if (shortNumwords > numwords)
	shortestLine = formLine
   elseif (shortNumwords == numwords && length(formLine) < length(shortestLine))
	shortestLine = formLine
   elseif (longNumwords < numwords)
	longestLine = formLine
   elseif (longNumwords == numwords && length(formLine) < length(longestLine))
	longestLine = formLine
   end

   #Printing lines w/ line numbers right-justified to col 8
   global longNum = 0
   global shortNum = 0
   for i in 1:size(linelist, 1)
	linestr = ""
        #Checking if current line is either longest or shortest line,
	#	storing line number for either if true
	if (linelist[i] == longestLine)
		global longNum = i
	elseif (linelist[i] == shortestLine)
		global shortNum = i
	end
	#Right-justifying line number to col 8 and adding two spaces after
	linestr = "$i"
	while (length(linestr) < 8)
		linestr = string(" ", linestr)
	end
	linestr = string(linestr, "  ")
	#Printing line number and formatted line
	print(linestr)
	println(linelist[i])
   end
   
   #Printing longest and shortest lines w/ line number left-justified to col 8
   #Output of line starts on col 21
   println(" ")
   global longstr = "LONG   $longNum"
   while (length(longstr) != 20)
	global longstr = string(longstr, " ")
   end
   global shortstr = "SHORT  $shortNum"
   while (length(shortstr) != 20)
	global shortstr = string(shortstr, " ")
   end
   print(longstr)
   println(longestLine)
   print(shortstr)
   println(shortestLine)
