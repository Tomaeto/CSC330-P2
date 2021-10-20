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
;;TODO: Make functions for checking for longest and shortest lines
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
		(if (= numwords mostwords)
			(progn
			(if (> (length longest-line) (length templine))
				(setq longest-line templine))))
		;;If current line has fewer words than last found
		;;	shortest line, then store new shortest line
		;;If there is a tie, stores line w/ least chars
		(if (or (= leastwords 0) (< numwords leastwords))
			(progn
			(setq shortest-line templine)
			(setq leastwords numwords)))
		(if (= numwords leastwords)
			(progn
			(if (> (length shortest-line) (length templine))
				(setq shortest-line templine))))
				
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
	(progn
	(push templine longlist)
	(if (> numwords mostwords)
		(progn
		(setq longest-line templine)
		(setq mostwords numwords)))
	(if (= numwords mostwords)
		(progn
		(if (> (length longest-line) (length templine))
			(setq longest-line templine))))
	(if (or (= leastwords 0) (< numwords leastwords))
		(progn
		(setq shortest-line templine)
		(setq leastwords numwords)))
	(if (= numwords leastwords)
		(progn
		(if (> (length shortest-line) (length templine))
			(setq shortest-line templine))))
	(setq templine tempword)
		(if (< 1 leastwords)
			(setq shortest-line templine))
		(if (= 1 leastwords)
			(progn
			(if (> (length shortest-line) (length templine))
				(setq shortest-line templine))))
	(push templine longlist))

	(progn
	(setq templine (concatenate 'string templine tempword))
	(push templine longlist)
	(if (> numwords mostwords)
		(setq longest-line templine))
	(if (< numwords leastwords)
		(setq shortest-line templine))))
;;Reversing longlist so lines are in order
(setq longlist (reverse longlist))
