// 
//  points.c
//  Clustering
//  
//  Created by Tom Coleman on 2007-11-08.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
// 

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <math.h>

#include <gsl/gsl_vector.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_blas.h>

#include "points.h"

point*
read_points (FILE* in, int dim, int n_ps)
{
	point* ps = calloc (n_ps, sizeof (point));
	assert (ps != NULL);
	
	for (int i = 0; i < n_ps; i++)
	{
		ps[i] = gsl_vector_alloc (dim);
		assert (ps[i] != NULL);
		
		for (int j = 0; j < dim; j++)
		{
			if (j != 0) fgetc (in); // grab the ,
			
			double d;
			assert (fscanf (in, "%lf", &d) == 1);
			gsl_vector_set (ps[i], j, d);
		}
	}
	
	return ps;
}

void
print_point (FILE* out, point p, int dim)
{
	for (int i = 0; i < dim; i++)
	{
		fprintf (out, "%0.2f, ", gsl_vector_get (p, i));
	}
	fprintf (out, "\n");
}

double
distance (point x, point y)
{
	gsl_vector* z = gsl_vector_alloc (x->size);
	assert (z != NULL);
	gsl_blas_dcopy (x, z);
	gsl_blas_daxpy (-1, y, z);
	return gsl_blas_dnrm2 (z);
}

double
distance_A (point x, point y, gsl_matrix* A)
{
	
	// z = x - y
	gsl_vector* z = gsl_vector_alloc (x->size);
	assert (z != NULL);
	gsl_blas_dcopy (x, z);
	gsl_blas_daxpy (-1, y, z);
	
	// w = A z
	gsl_vector* w = gsl_vector_alloc (x->size);
	assert (w != NULL);
	gsl_blas_dcopy (z, w);
	
	// A's diagonal
	gsl_vector_view diag = gsl_matrix_diagonal (A);
	gsl_vector_mul (w, &diag.vector);
	
	double dist;
	gsl_blas_ddot (z, w, &dist);
	return sqrt (dist);
}