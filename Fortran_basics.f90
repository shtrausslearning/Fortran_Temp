! Derived Types ; better used in modules for global view
type person
    character(len=20):: first, last
    integer::           birthyear
    character(len=1)::  gender
end type

type employee
    type(person)::      person
    integer::           hire_date
    character(len=20):: department
end type

! Define 
type(person) :: jack
type(employee) :: jill

! Set Values
jack = person( "Jack", "Smith", 1984, "M" )
jill = employee( person( "Jill", "Smith", 1984, "F" ), 2003, "sales" )

print *, jack%first, jack%last
print *, jill%person%first, jill%person%last, jill%department

! Returning Array Arguments
INCLUDE
    function matrix_multiply( A, B )
        real:: A(:,:), B(:,:)
        real:: matrix_multiply( ubound(A,1), ubound(B,2) )
        
        matrix_multiply = matmul( A, B )
    end function matrix_multiply
    
! Select Option : similar to IF condition met
    select case( hour )
        case( 1:8 )
            activity = 'sleep'
        case( 9:11, 13, 14 )
            activity = 'class'
        case( 12, 17 )
            activity = 'meal'
        case default
            activity = 'copious free time'
    end select
