! SMALLER ARRAY CALCULATIONS

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

a_d = a ! data transfer host -> device
call inc <<<1,n>>>(a_d,b) ! single thread block
a = a_d

if(all(a==4)) then
    write(*,*) 'Test Passed'
endif
deallocate(a,a_d)

end program incTest

#####

! F90
module simpleOps_m
contains
  subroutine inc(a,b)
  implicit none
  integer :: a(:)
  integer :: b
  integer :: i,n
  
  n = size(a)
  do i = 1,n
    a(i) = a(i) + b
  enddo
  end subroutine inc
end module simpleOps_m

! CUDA F90
module simpleOps_m
contains
  attributes(global) subroutine inc(a,b)
  implicit none
  integer :: a(:)
  integer, value :: b
  integer :: i
  
  i = threadIdx%x
  a(i) = a(i) + b
  
  end subroutine inc
end module simpleOps_m

! LARGER ARRAY 

! call <<<1,n>>>(a_d,b) -> limit 512/1024
! larger arrays -> change the first execution parameter (<<<1,n>>>)

program incTest
use cudafor
use simpleOps_m
implicit none

integer, parameter :: n = 1024*1024
integer, parameter :: tPB = 256
integer :: a(n), b
integer, device :: a_d(n)

a = 1
b = 3

a_d = a   ! multiple thread blocks: ceiling(real(n)/tPB)
call inc <<<ceiling(real(n)/tPB),tPB>>>(a_d,b)
a = a_d

if(all(a==4)) then
    write(*,*) 'Test Passed'
endif

end program incTest
