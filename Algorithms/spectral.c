// 
//  spectral.c
//  Clustering
//  
//  Created by Tom Coleman on 2007-11-01.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
// 

#include <stdio.h>
#include <assert.h>

#include <gsl/gsl_vector.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_eigen.h>

void
print_matrix (gsl_matrix* A, int n, int m)
{
	int i, j;
	for (i = 0; i < n; i++) {
		printf ("[");
		for (j = 0; j < m; j++) {
			printf (" %.2lf", gsl_matrix_get (A, i, j));
		}
		printf (" ]\n");
	}
}

void
print_vector (gsl_vector* V, int n)
{
	int i;
	printf ("[");
	for (i = 0; i < n; i++) {
		printf (" %.2lf", gsl_vector_get (V, i));
	}
	printf (" ]\n");
}

int main (int argc, char const *argv[])
{
	int n = atoi (argv[1]);
	
	gsl_matrix* A = gsl_matrix_alloc (n, n);
	
	int i, j;
	for (i = 0; i < n; i++) {
		for (j = 0; j < n; j++) {
			double val;
			assert (scanf ("%lf", &val) == 1);
			gsl_matrix_set (A, i, j, val);
		}
	}	
	
	//print_matrix (A, n, n);
	
	gsl_eigen_symmv_workspace* ws = gsl_eigen_symmv_alloc (n);
	
	gsl_vector* eval = gsl_vector_alloc (n);
	gsl_matrix* evec = gsl_matrix_alloc (n, n);
	
	int succ = gsl_eigen_symmv (A, eval, evec, ws);
	
	//printf ("succ is %d\n", succ);
	
	//printf ("eigenvalues: \n");
	//print_vector (eval, n);
	
	for (i = 0; i < n; i++) {
		printf ("%d\n", gsl_matrix_get (evec, i, 2) < 0);
	}
	
	gsl_eigen_symmv_free (ws);
	gsl_vector_free (eval);
	gsl_matrix_free (evec);
	gsl_matrix_free (A);
	
	return 0;
}