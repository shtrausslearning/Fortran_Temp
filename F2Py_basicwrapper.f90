!@ source https://numpy.org/devdocs/f2py/python-usage.html#call-back-arguments
! Accessing Fortran Content from Python via wrapper

! Fortran 77 
C FILE: FTYPE.F
      SUBROUTINE FOO(N)
      INTEGER N
Cf2py integer optional,intent(in) :: n = 13
      REAL A,X
      COMMON /DATA/ A,X(3)
      PRINT*, "IN FOO: N=",N," A=",A," X=[",X(1),X(2),X(3),"]"
      END
C END OF FTYPE.F

! (2) Make Wrapper : f2py -c ftype.f -m ftype.

! In Python 
import ftype  ! Import created file
print(ftype.__doc__)
!@output:
! This module 'ftype' is auto-generated with f2py (version:2).
!Functions:
!  foo(n=13)
!COMMON blocks:
!  /data/ a,x(3)

! Fortran type objects in python
type(ftype.foo), type(ftype.data)
!out: (<class 'fortran'>, <class 'fortran'>) 
ftype.foo()
!out: IN FOO: N= 13 A=  0. X=[  0.  0.  0.]

! Set Vals
ftype.data.a = 3
ftype.data.x = [1,2,3]

ftype.foo()
!@out: IN FOO: N= 13 A=  3. X=[  1.  2.  3.]
ftype.data.x[1] = 45  
ftype.foo(24)
!@out: IN FOO: N= 24 A=  3. X=[  1.  45.  3.]
ftype.data.x
!@out: array([  1.,  45.,   3.], dtype=float32)
