program max_int

integer, parameter :: i32 = selected_int_kind(32)
integer(kind = i32) :: my_int

!The largest integer of this kind
print*, huge(my_int)

!my_int = 10000000000  # too large
my_int = 1000000000  # ok
      ! [2147483648,2147483647] i32

print*, my_int

end program
