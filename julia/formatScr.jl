#!/usr/bin/julia


   print("Enter input file path: ")
   filename = readline()
   
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
	fileline = replace(fileline,"  " => " ")
	println(fileline)
   end
   
end

