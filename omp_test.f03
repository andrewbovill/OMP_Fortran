      program main
      implicit none
      integer, parameter :: n = 10000000
      real(8) :: data(n)
      real(8) :: result_slow, result_parallel
      integer :: i
      real(8) :: time0,time1

!
!     Test Program to test openmp capabilities
!
!     A. J. Bovill 2023
!

!
!     Initialize data array
!

      do i = 1, n
      data(i) = 1.0
      end do

!     
!     Calculate sum using the slow subroutine
!     

      call cpu_time(time0)
      result_slow = sum_slow(data, n)
      call cpu_time(time1)
      print *, "Slow result:", result_slow
      print *, "CPU time (slow):", time1 - time0

      ! Calculate sum using the parallelized subroutine
      call cpu_time(time0)
      result_parallel = sum_parallel(data, n)
      call cpu_time(time1)
      print *, "Parallel result:", result_parallel
      print *, "CPU time (parallel):", time1 - time0

contains

!
!     Non-Parallelized function to calculate the sum using OpenMP
!

      real(8) function sum_slow(data, n)
      real(8), intent(in) :: data(:)
      integer, intent(in) :: n
      integer :: i

      sum_slow = 0.0
      do i = 1, n
        sum_slow = sum_slow + data(i)
      end do
      end function sum_slow

!
!     Parallelized function to calculate the sum using OpenMP
!
      real(8) function sum_parallel(data, n)
      real(8), intent(in) :: data(:)
      integer, intent(in) :: n
      integer :: i
      real(8) :: partial_sum

      partial_sum = 0.0

!
!     Andrew --instructions to use OpenMp
!     '!$omp: Starts the OpenMp directive, only work with -mp flag
!     'parallel' creates a team of threads to execute the subsequent loop in parallel     
!     'do' Specifices the thread will be excuted in parallel
!     'private(i): This declares that the 'i' value will be private in each
!     thread. i.e. they will not hurt other threads
!     'reduction(+:partial_sum)': The '+' means a summation oepration
!     OpenMp handles the parallel accumulatio of values into 'partial_sum' 
!     across all threads

      !$omp parallel do private(i) reduction(+:partial_sum)
      do i = 1, n
        partial_sum = partial_sum + data(i)
      end do
      !$omp end parallel do

      sum_parallel = partial_sum
      end function sum_parallel

    end program main

