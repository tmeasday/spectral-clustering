// 
//  diagonal_metric.c
//  Clustering
//  
//  Created by Tom Coleman on 2007-11-08.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
// 

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include <gsl/gsl_matrix.h>
#include <gsl/gsl_blas.h>

#include "constraints.h"
#include "points.h"

#define EPSILON 0.01

// some common macros
// the diff between points in a constraint in some projection
#define constr_diff_p(ps,set,num,dir) \
		 (gsl_vector_get (ps[set[num].x], dir) \
		- gsl_vector_get (ps[set[num].y], dir))
// the distance between points in a constraint according to A
#define constr_dist_A(ps,set,num,A) distance_A (ps[set[num].x], ps[set[num].y], A)

int main (int argc, char const *argv[])
{
	int dim = atoi (argv[1]);
	int n_ps = atoi (argv[2]);
	int n_S = atoi (argv[3]);
	int n_D = atoi (argv[4]);
	
	point* ps = read_points (stdin, dim, n_ps);
	constraint* S = read_constraints (stdin, n_S);
	constraint* D = read_constraints (stdin, n_D);
	
	gsl_matrix* A = gsl_matrix_alloc (dim, dim);
	gsl_matrix_set_identity (A);

	while (1) {
		gsl_vector* g = gsl_vector_alloc (dim);
		gsl_matrix* H = gsl_matrix_alloc (dim, dim);
		gsl_matrix_set_zero (H);
	
		// work out the sum of the D distance relative to A
		double beta = 0;
		for (int k = 0; k < n_D; k++) {
			beta += constr_dist_A (ps, D, k, A);
		}
	
		// initialize g's to be just the second term (useful for H)
		for (int i = 0; i < dim; i++) {
			double d = 0;
		
			double u = 0;
			for (int k = 0; k < n_D; k++) {
				double term = pow (constr_diff_p (ps, D, k, i), 2);
				u += term / constr_dist_A (ps, D, k, A);
			}
			d -= u / (2 * beta);
			gsl_vector_set (g, i, d);
		}
	
		for (int i = 0; i < dim; i++) {
			for (int j = i; j < dim; j++) {
				double num = 0;
			
				// first term
				for (int k = 0; k < n_D; k++) {
					double term = pow (constr_diff_p (ps, D, k, i), 2);
					term *= pow (constr_diff_p (ps, D, k, j), 2);
					term /= 4 * pow (constr_dist_A (ps, D, k, A), 3);
					num += term;
				}
				num /= beta;
			
				// second term 
				num += gsl_vector_get (g, i) * gsl_vector_get (g, j);
			
				gsl_matrix_set (H, i, j, num);
			}
		}

		// now finish working out g's
		for (int i = 0; i < dim; i++) {
			for (int k = 0; k < n_S; k++) {
				double d = pow (constr_diff_p (ps, S, k, i), 2);
				gsl_vector_set (g, i, gsl_vector_get (g, i) + d);
			}
		}
	

		print_point (stdout, g, dim);
	
		printf ("H:\n");
		for (int i = 0; i < dim; i++) {
			for (int j = 0; j < dim; j++) {
				printf ("%.2lf, ", gsl_matrix_get (H, i, j));
			}
			printf ("\n");
		}

		// this is WRONG (FIXME) -- uses 0 below the diagonal
		// g = H-1 g
		gsl_blas_dtrsv (CblasUpper, CblasNoTrans, CblasNonUnit, H, g);

		printf ("p: ");
		print_point (stdout, g, dim);

		// g now tells us what to subtract off the diagonal of A.
		// We just need to scale it to assure that A remains positive semi-def

		double alpha = 1;
		for (int i = 0; i < dim; i++) {
			double a_i = gsl_matrix_get (A, i, i);
			double p_i = gsl_vector_get (g, i);
		
			if (a_i < alpha * p_i) {
				alpha = a_i / p_i;
			}
		}

		printf ("alpha = %.4lf\n", alpha);


		printf ("norm: %lf\n", gsl_blas_dnrm2 (g) * alpha);
		if (gsl_blas_dnrm2 (g) * alpha < EPSILON) {
			printf ("reached stopping conditions\n");
			break;
		}
		
		// probably could do this via gsl functions, but hey..
		for (int i = 0; i < dim; i++) {
			double a_i = gsl_matrix_get (A, i, i);
			double p_i = gsl_vector_get (g, i);
			gsl_matrix_set (A, i, i, a_i - p_i * alpha);
		}

		printf ("A:\n");
		for (int i = 0; i < dim; i++) {
			for (int j = 0; j < dim; j++) {
				printf ("%.2lf, ", gsl_matrix_get (A, i, j));
			}
			printf ("\n");
		}

	}

	// this prints out the points again, scaled by A
	for (int i = 0; i < n_ps; i++) {
		point y = (point) gsl_vector_alloc (dim);		
		gsl_blas_dgemv (CblasNoTrans, 1, A, ps[i], 0, y);
		print_point (stdout, y, dim);
	}

	// this prints out all the distances
	// for (int i = 0; i < n_ps; i++)
	// {
	// 	for (int j = 0; j < n_ps; j++)
	// 	{
	// 		printf ("%d,%d:", i, j);
	// 		printf ("%.2f\t", distance_A (ps[i], ps[j], A));
	// 	}
	// 	printf ("\n");
	// }
	
	
	return 0;
}