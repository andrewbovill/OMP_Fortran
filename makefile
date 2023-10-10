#
# This is a simple makefile for building OMP_Fortran
#
#Compilation with pgfortran
RunF         = nvfortran -mp
F03Flag      = -mp 
#
# The 'all' rule.
#
#
all: omp_test.exe
#
# Generic rule for building general executable program (*.exe) from a standard
# f03 source (*.f03) file.
#
%.exe: %.f03 
	$(RunF) -o omp_test.exe omp_test.f03 
clean:
	rm -rf *.o *.exe *.mod
