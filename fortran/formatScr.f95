      program formatScr
      !Program for outputting formatted text from input file
      !Removes numbers and extra spaces, prints lines w/ max of
      !        60 characters w/o splitting words across lines
      !By Adrian Faircloth
        character, dimension(:), allocatable :: filestring
        character (LEN = 500) :: filename
        integer :: filesize
        character :: lastchar, currchar
        integer :: counter, spaceptr, numprinted
        logical :: spacefound
        
      interface
      !Defining variables for subroutines and functions
      subroutine read_file(filestring, filesize, filename)
        character, dimension(:), allocatable :: filestring
        character (LEN = 500) :: filename
        integer :: filesize
      end subroutine read_file

      logical function isNum(ch) result(out)
        character :: ch
        logical :: gtzero, ltnine
      end function isNum

      logical function isDoubleSpace(currch, lastch) result(out)
        character :: currch, lastch
      end function isDoubleSpace
      end interface
      !Getting user input for input file path  
        print *, "Enter input file path: "
        read *, filename
        call read_file(filestring, filesize, filename)
        lastchar = ''
        currchar = ''
        numprinted = 0
       !Printing lines from input file, skipping numbers and
       !        extra spaces
       !Counts printed characters to ensure lines are the proper
       !        length
        do i=1, size(filestring) 
       !Replacing newline characters with spaces    
           if (filestring(i) .eq. achar(10)) then
               filestring(i) = ' '
           end if
           currchar = filestring(i)
           if (isNum(currchar) .eqv. .true.) then
               !Skips character if it is a number
           else
               if (isDoubleSpace(currchar, lastchar) .eqv. .true.) then
                !Skips character if there is a double space in the text
               else
                !Finding next space in line to check if next word can
                !       fit in the current line
                   spacefound = .false.
                   counter = 1
                   do while (spacefound .eqv. .false.)
                          if (filestring(i+counter) .eq. achar(32)) then
                              spacefound = .true.
                              spaceptr = counter
                          else
                              counter = counter + 1
                          end if
                !If there is no space left in line, sets pointer to 0
                          if (i + counter .ge. size(filestring)) then
                              spaceptr = 0  
                              spacefound = .true.
                          end if
                   end do
            
                       write (*, fmt = "(a)", advance = "no") currchar
                       numprinted = numprinted+1
               end if
           end if
           !If the length of the line + the next word exceeds 60, then
           !    print a new line and reset counters
           if (numprinted+spaceptr .gt. 61) then
                print *, ""
                numprinted = 0
           end if
           lastchar = currchar
        end do
      end program formatScr

      !Subroutine for reading input file
      !Stores text from input file in an allocatable string
      subroutine read_file(string, filesize, filename)
        character, dimension(:), allocatable :: string
        character (LEN = 500) :: filename
        integer :: counter
        integer :: filesize
        character (LEN = 1) :: input
        
        inquire(file = trim(filename), size = filesize)
        open(unit=5,status="old",access="direct",form="unformatted",recl=1,file=trim(filename))
        allocate(string(filesize))
        counter = 1
        100 read (5, rec=counter,err = 200) input
                string(counter:counter) = input
                counter = counter + 1
                goto 100
        200 continue
        counter = counter - 1
        close(5)
        
      end subroutine read_file 
      
      !Function for checking if a character is a number
      logical function isNum(ch) result(out)
        character :: ch
        logical :: gtzero, ltnine
        out = .false.
        gtzero = iachar(ch) .ge. iachar('0')
        ltnine = iachar(ch) .le. iachar('9')
        if (gtzero .eqv. .true. .and. ltnine .eqv. .true.) then
            out = .true.
        end if
      end function isNum

      !Function for checking if string has a double space
      !Takes last and current characters as input, and if both are
      !        spaces, returns true
      logical function isDoubleSpace(lastch, currch) result(out)
        character :: lastch, currch
        out = .false.
        if (lastch .eq. ' ' .and. currch .eq. ' ') then
            out = .true.
        end if
      end function isDoubleSpace
