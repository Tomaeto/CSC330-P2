      program formatScr
      
        character, dimension(:), allocatable :: filestring
        character (LEN = 500) :: filename
        integer :: filesize
        character :: lastchar, currchar
        integer :: spaceptr, numextras, numlines, counter
        logical :: spacefound
        
      interface
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
        
        print *, "Enter input file path: "
        read *, filename
        call read_file(filestring, filesize, filename)
        lastchar = ''
        currchar = ''
        numextras = 0
        numlines = 1
        do i=1, size(filestring)     
           if (filestring(i) .eq. achar(10)) then
               filestring(i) = ' '
           end if
           currchar = filestring(i)
           if (isNum(currchar) .eqv. .true.) then
               numextras = numextras + 1
           else
               if (isDoubleSpace(currchar, lastchar) .eqv. .true.) then
                   numextras = numextras + 1
               else
                   spacefound = .false.
                   counter = 1
                   do while (spacefound .eqv. .false.)
                          if (filestring(i+counter) .eq. achar(32)) then
                              spaceptr = counter
                              spacefound = .true.
                          else
                              counter = counter + 1
                          end if
                          if (i + counter .ge. size(filestring)) then
                              spaceptr = 0
                              spacefound = .true.
                          end if
                   end do
            
                       write (*, fmt = "(a)", advance = "no") currchar
               end if
           end if
           if ((i/numlines) + spaceptr .gt. (61 + numextras)) then
                print *, ""
                numextras = 1
                numlines = numlines + 1
           end if
           lastchar = currchar
        end do
      end program formatScr

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

      logical function isDoubleSpace(lastch, currch) result(out)
        character :: lastch, currch
        out = .false.
        if (lastch .eq. ' ' .and. currch .eq. ' ') then
            out = .true.
        end if
      end function isDoubleSpace
