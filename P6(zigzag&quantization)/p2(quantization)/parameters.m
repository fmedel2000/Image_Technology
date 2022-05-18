%% Francisco Medel Molinero
%% Image reading(we convert the image into double values)
im_in=double(imread('cameraman.tif'));

%% Quality coefficient(0..100), where 0 is bad and 100 is excellent
quality=5;

%% Execution of the function
quantization(im_in, quality);
