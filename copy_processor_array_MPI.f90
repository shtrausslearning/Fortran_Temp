! @source : https://livebook.manning.com/book/modern-fortran/chapter-1/v-9/121

program array_copy_mpi
use mpi
implicit none

integer :: ierr, nproc, procsize, request
integer, dimension(mpi_status_size) :: stat

integer, dimension(5) :: array
integer, parameter :: sender = 0, receiver = 1

call mpi_init(ierr)  ! Initialise MPI
call mpi_comm_rank(mpi_comm_world, nproc, ierr) ! Whist processor number
call mpi_comm_size(mpi_comm_world, procsize, ierr) ! How many total processes

! # shutdown if not @2cpu
if (procsize /= 2) then
  call mpi_finalize(ierr)
  stop 'Error: This program must be run on 2 parallel processes'
end if

! Initialise arrays on sending & receiving
if (nproc == sender) then
  array = [1, 2, 3, 4, 5]
else
  array = 0
end if

write(*,'(a,i1,a,5(4x,i2))')'array on proc ', nproc,&
  ' before copy:', array

call mpi_barrier(mpi_comm_world, ierr)

if (nproc == sender) then
  call mpi_isend(array, size(array), mpi_int, receiver, 1,&
                 mpi_comm_world, request, ierr)
else if (nproc == receiver) then
  call mpi_irecv(array, size(array), mpi_int, sender, 1,&
                 mpi_comm_world, request, ierr)
  call mpi_wait(request, stat, ierr)

write(*,'(a,i1,a,5(4x,i2))')'array on proc ', nproc,&
  ' after copy: ', array

call mpi_finalize(ierr)

end program array_copy_mpi

! @output
! array on proc 0 before copy:     1     2     3     4     5
! array on proc 1 before copy:     0     0     0     0     0
! array on proc 0 after copy:      1     2     3     4     5
! array on proc 1 after copy:      1     2     3     4     5
