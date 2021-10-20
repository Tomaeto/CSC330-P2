#!/usr/bin/sbcl --script

;;Function for getting lines from input file
(defun get-file (filename)
	(with-open-file (stream filename)
		(loop for line = (read-line stream nil)
			while line 
			collect line
		)
	)
)

			
(defvar filename)
(defvar longlist)
;;creating string list to hold partly-formatted lines
(defvar linelist)
(setq linelist '("  "))
;;getting input file, filling longlist with lines of file
(write-string "Enter input file path: ")
(finish-output)
(setq filename (read-line))
(clear-input)
(setq longlist (get-file filename))

(defvar lastchar)
(setq lastchar #\z)
(defvar charindex)
;;scanning through each input line, removing numbers and extra spaces
(loop for line in longlist 
	do(progn
	(setq charindex 0)
	   (loop for c across line
		do(progn
		;;removing each number found in line
		;;decrements charindex since line has 1 less character
		(if (and (char<= c #\9) (char>= c #\0))
		     (progn
			(setq line (remove c line))
			(decf charindex)))
		;;removing extra spaces, uses charindex to track c and find extra space
		;;decrements charindex since line has 1 less character
		(if (and (char= lastchar #\ ) (char= c #\ ))
		     (progn
		     (setq line (delete #\  line :start (- charindex 2) :count 1))
		     (decf charindex)))
		
		(setq lastchar c)
		(incf charindex)
		  )	
	   )	
		;;adding formatted line to linelist
		(push line linelist)	
	  )
)
;;removing empty string from linelist
(setq linelist (reverse linelist))
(setq linelist (cdr linelist))
;;emptying longlist, will be used to hold fully formatted lines
(loop while (string/= (car longlist) 'NIL)
	do (setq longlist (cdr longlist))
)
;;Creating list of all words in input file
;;Used to build formatted lines of output
(defvar wordlist)
(setq wordlist '())
(defvar linespace)
(defvar tempword)
(loop for line in linelist
	do(progn
	   ;;If there is a space in the line, chars from start to space make a word
	   ;;After getting word and adding it to wordlist, deletes word and space from line
	   ;;Once there are no spaces in line, line contains single word, so it is added to wordlist
	   (setq linespace (search " " line)) 
	   (loop while (not (null linespace))
		do (progn
		 (setq tempword (subseq line 0 linespace))
		 (push tempword wordlist)
		 (setq line (string-left-trim tempword line))
		 (setq line (delete #\  line :count 1))
		 (setq linespace (search " " line))))
	   (push line wordlist)))  
;;Reverse wordlist so list pops words in order
(setq wordlist (reverse wordlist))
;;Building formatted lines of text w/ line number and 60 characters max
;;Uses word counters to find lines w/ most and least number of words
(defvar templine)
(setq templine "")
(defvar tempword)
(setq tempword (pop wordlist))
(defvar numwords)
(setq numwords 0)
(defvar mostwords)
(setq mostwords 0)
(defvar leastwords)
(setq leastwords 0)
(defvar longest-line)
(setq longest-line " ")
(defvar shortest-line)
(setq shortest-line " ")
(loop while (/= (length wordlist) 0)
	do(progn
	  ;;If the length of the line w/ the next word would break 60,
	  ;;	push line to longlist, reset word counter and set
	  ;;	templine to empty so it can hold the next line
	  (if (> (+ (length templine) (length tempword)) 60)
		(progn
		(push templine longlist)
		;;If current line has more words than last found
		;;	longest line, then store new longest line
		;;If there is a tie, stores line w/ least chars
		(if (> numwords mostwords)
			(progn
			(setq longest-line templine)
			(setq mostwords numwords)))
		(if (and (= numwords mostwords) (> (length longest-line) (length templine)))
			(setq longest-line templine))
		;;If current line has fewer words than last found
		;;	shortest line, then store new shortest line
		;;If there is a tie, stores line w/ least chars
		(if (or (= leastwords 0) (< numwords leastwords))
			(progn
			(setq shortest-line templine)
			(setq leastwords numwords)))
		(if (and (= numwords leastwords) (> (length shortest-line) (length templine)))
			(setq shortest-line templine))
				
		(setq numwords 0)
		(setq templine "")))
	  ;;If length will not break 60, add next word to line
	  ;;	and increment word counter
	  (setq templine (concatenate 'string templine tempword))
	  (incf numwords)
	  ;;Adds space only if line is less than 60 characters
	  (if (< (length templine) 60)
	  	(setq templine (concatenate 'string templine " ")))
	  (setq tempword (pop wordlist))))

;;After popping final word from wordlist, adds word to line if it
;;	fits and pushes line
;;If word does not fit, pushes current line then pushes final word
(if (>= (+ (length templine) (length tempword)) 60)
	;;If word does not fit in line, checks if current line is
	;;	longest or shortest and pushes line
	(progn
	(push templine longlist)
	(if (> numwords mostwords)
		(progn
		(setq longest-line templine)
		(setq mostwords numwords)))
	(if (and (= numwords mostwords) (> (length longest-line) (length templine)))
		(setq longest-line templine))
	(if (or (= leastwords 0) (< numwords leastwords))
		(progn
		(setq shortest-line templine)
		(setq leastwords numwords)))
	(if (and (= numwords leastwords) (> (length shortest-line) (length templine)))
		(setq shortest-line templine))
	(setq templine tempword)
	;;Final line has 1 word, checks if that is shortest line
	;;	if it is a tie, stores line w/ fewer characters
		(if (< 1 leastwords)
			(setq shortest-line templine))
		(if (= 1 leastwords)
			(progn
			(if (> (length shortest-line) (length templine))
				(setq shortest-line templine))))
	(push templine longlist))
	;;If word does fit in line, adds word to line, checks if line is
	;;	longest or shortest and pushes line
	(progn
	(setq templine (concatenate 'string templine tempword))
	(push templine longlist)
	(if (> numwords mostwords)
		(setq longest-line templine))
	(if (< numwords leastwords)
		(setq shortest-line templine))))
;;Reversing longlist so lines are in order
(setq longlist (reverse longlist))
;;Printing lines w/ line number
;;Line number right-justified to col 8,
;;	line output begins on col 11.
(defvar linenum)
(defvar num-str)
(defvar longest-numstr)
(setq longest-numstr "LONG   ")
(defvar shortest-numstr)
(setq shortest-numstr "SHORT  ")
(setq linenum 1)
(loop for line in longlist
	do(progn
	(setq num-str (write-to-string linenum))
	;;Adding spaces to the front of num-str until the end reaches column 8
	;;Simulates right-justification of line number
	(loop while (< (length num-str) 8)
		do(setq num-str (concatenate 'string " " num-str)))
	;;When the current line is the longest or shortest line, line number
	;;	is added to corresponding string, left-justified to col 8
	(if (string= line longest-line)
		(setq longest-numstr (concatenate 'string longest-numstr (write-to-string linenum))))
	(if (string= line shortest-line)
		(setq shortest-numstr (concatenate 'string shortest-numstr (write-to-string linenum))))
	;;Adding spaces to num-str to start line ouput on col 11
	(setq num-str (concatenate 'string num-str "  "))
	(write-line (concatenate 'string num-str line))
	(incf linenum)))
;;Printing empty line
(write-line " ")
;;Adding spaces to end of strings for longest and shortest line numbers
;;	so that line output begins on col 21
(loop while (/= (length longest-numstr) 20)
	do(setq longest-numstr (concatenate 'string longest-numstr " ")))
(loop while (/= (length shortest-numstr) 20)
	do(setq shortest-numstr (concatenate 'string shortest-numstr " ")))
;;Printing longest and shortest lines w/ line number
(write-line (concatenate 'string longest-numstr longest-line))
(write-line (concatenate 'string shortest-numstr shortest-line))
