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
		(if (and (char<= c #\9) (char>= c #\0))
		     (setq line (remove c line)))
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
(write linelist)
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
		(write-line line)
		 (setq tempword (subseq line 0 linespace))
		 (push tempword wordlist)
		 (setq line (string-trim tempword line))
		 (setq line (delete #\  line :count 1))
		 (setq linespace (search " " line))
		 
		)
	)
	
	 ;  (push line wordlist)
	   ))  
;;Reverse wordlist so list pops words in order
(setq wordlist (reverse wordlist))
;;Building formatted lines of text w/ line number and 60 characters max
(defvar templine)
(setq templine "")
(defvar tempword)
(write wordlist)
(setq tempword (pop wordlist))

(loop while (/= (length wordlist) 0)
	do(progn
	  (if (> (+ (length templine) (length tempword)) 60)
		(progn
		(push templine longlist)
		(setq templine "")))
	  (setq templine (concatenate 'string templine tempword))
	  (if (< (length templine) 60)
	  	(setq templine (concatenate 'string templine " ")))
	  (setq tempword (pop wordlist))))
 
(if (>= (+ (length templine) (length tempword)) 60)
	(progn
	(push templine longlist)
	(push tempword longlist))
	(progn
	(setq templine (concatenate 'string templine tempword))
	(push templine longlist)))
(setq longlist (reverse longlist))
;(loop for line in longlist
;	do(progn
;	(write-line line)))
