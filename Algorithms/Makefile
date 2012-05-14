LIBDIR=../Library

CFLAGS += -I/opt/local/include -I$(LIBDIR)
GSL_FLAGS = -L/opt/local/lib -lgsl -lgslcblas

STDINCS = $(LIBDIR)/constraints.o $(LIBDIR)/points.o

all: spectral.exe diagonal_metric.exe

spectral.exe: spectral.o
	$(CC) $(CFLAGS) $(GSL_FLAGS) -o spectral.exe spectral.o
	
diagonal_metric.exe: diagonal_metric.o $(STDINCS)
	$(CC) $(CFLAGS) $(GSL_FLAGS) -o $@ $^