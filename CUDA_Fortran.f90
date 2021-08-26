module simpleOps_m
contains
  subroutine inc(a,b)
  implicit none
  ! glob vars upon import
  integer :: a(:)
  integer :: b
  integer :: i,n
  
  n = size(a)
  do i = 1,n
    a(i) = a(i) + b
  enddo
  end subroutine inc
end module simpleOps_m

! F90
program incTest
use simpleOps_m
implicit none

integer :: b, n = 256
integer, allocatable :: a(:)

allocate(a(n))

a = 1  ! array
b = 3

call inc(a,b)

if(all(a==4)) then
    write(*,*) 'Test Passed'
endif
deallocate(a)

end program incTest

! CUDA F90
program incTest
use cudafor
use simpleOps_m
implicit none

integer :: b,n = 256
integer, allocatable :: a(:)
integer, allocatable, device :: a_d(:)

allocate(a(n),a_d(n))
a = 1
b = 3

a_d = a
call inc <<<1,n>>>(a_d,b)
a = a_d

if(all(a==4)) then
    write(*,*) 'Test Passed'
endif
deallocate(a,a_d)

end program incTest
