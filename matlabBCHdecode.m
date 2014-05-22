function decoded_data = matlabBCHdecode(data_to_decode)
load trt
bchPol = [1 0 0 0 1 1 1 1 1 0 1 0 1 1 1 1];
decoded_data = decode(data_to_decode,31,16,'cyclic/fmt', bchPol, trt);