!  The problem is that when intent(out) is used with a derived type, any 
!  component not assigned in a procedure could become undefined on exit. 
!  For example, even though a%y was defined on entry to this routine, 
!  it could become undefined on exit because it was never assigned within the routine.
        
        program intent_gotcha
             
        ! Define custom type 
         type mytype
           integer :: x  
           real :: y
         end type mytype

        ! define variables
         type (mytype) :: a
         
         ! assign components
         a%x = 1
!         a%y = 2.0 
         call assign(a)
  ! a%y COULD BE UNDEFINED HERE
         print *, a

         contains

         subroutine assign(this)
         type (mytype), intent (out) :: this
  ! THIS IS THE WRONG WAY
         this%x = 2
         end subroutine assign
         
!         subroutine assign(this)
!         type (mytype), intent (out) :: this
!  ! THIS IS THE RIGHT WAY
!         this%x = 2 
!         this%y = 2
!         end subroutine assign

         end program intent_gotcha
         
