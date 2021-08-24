program main
implicit none
double precision f,x1,x2,root,eps
integer flag
external f     ! outside function

x1 = -10.0
x2 =  10.0
eps = 1.0e-6

write (*,100)

! function passed as argument into subroutine
call bisection(f,x1,x2,eps,root,flag)

if(flag == 0) then 
  write(*,104)
  stop
end if

write(*,101) flag, eps
if(flag > 0) then
    write(*,102) Root
    else
    write(*,103) Root
end if

! test solution
write(*,105) f(Root)

! All write Formats 
100 format(' A single root of f(x) ',/, &
           ' Method - Bisectional')
101 format(' iterations  = ',i3,/,&
           ' tolerance   = ',1pe12.5)
102 format(' root        = ',1pe12.5)
103 format(' Singularity = ',1pe12.5)
104 format(' no roots for Bisectional method')
105 format(' f(root)     = ',1pe12.5)

end program main

subroutine bisection(f,x1,x2,eps,Root,flag)
implicit none
double precision f, x1, x2, eps, Root
double precision a, b, c
integer i, flag
integer, parameter:: iter=200

!* check the bisection condition
if(f(x1)*f(x2)>0.0) then
  flag = 0
  return
end if

!* initialize calculations
a=x1
b=x2

!* Iterative refining the solution 
do i=1,iter
  c=(b+a)/2.0
  if(f(a)*f(c).le.0.0) then
      b = c
    else
      a=c
  end if
! condition(s) to stop iterations)
  if(abs(b-a)<= eps) exit  
end do
Root=(b+a)/2.0

!* check if it is a root or singularity
if (abs(f(Root)) < 1.0) then
  flag=i
else
  flag = -i
end if
end subroutine bisection

! External function
function f(x)
implicit none
double precision :: f, x
  f = x + cos(x)
end function f
