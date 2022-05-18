%% Francisco Medel Molinero

%% Image reading(we convert the image into double values)
im_in=double(imread('cameraman.tif'));

%% Definition of how many DCT coefficients number we need for the transmission(if we increase the number of coefficients the quality of the reconstructed image will be better, and the error image will be lower)
num_coefficients=1;
%num_coefficients=4;
%num_coefficients=32;

%% Execution of the function
masking(im_in, num_coefficients);
