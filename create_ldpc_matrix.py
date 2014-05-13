#!/usr/bin/python
# Script to create LDPC parity check matrix from base code CSV
# Author: Vanush Vaswani
import numpy as np
import scipy
import scipy.io

def create_ldpc_matrix():
	base_code = open('base_code.dat', "r")
	ldpc_h = np.zeros((1152, 2304))
	# For each row
	row_idx = 0
	col_idx = 0

	print ("Creating LDPC parity-check matrix ...")
	for row in base_code:
		elements = row.split(',')
		for col_value in elements:
			ldpc_h[row_idx : row_idx + 96, col_idx : col_idx + 96 ] = \
			get_submatrix(col_value)
			col_idx = col_idx + 96
		row_idx = row_idx + 96
		col_idx = 0

	print ("Saving to ldpc_h.mat .. ")
	scipy.io.savemat('ldpc_h.mat', {'ldpc_h': ldpc_h})

def get_submatrix(element):
	element = int(element)
	if element == -1:
		return np.zeros((96, 96))
	elif element == 0:
		return np.eye(96)
	elif element > 0:
		return np.roll(np.eye(96), element, axis=1)

# Load file from matrix
if __name__ == "__main__":

	base_code = open('base_code.dat', "r")
	print ("Loading file ...")
	base_mat = np.loadtxt(base_code, delimiter=',')
	print ("Shape of base code: {0}".format(base_mat.shape))
	create_ldpc_matrix()
