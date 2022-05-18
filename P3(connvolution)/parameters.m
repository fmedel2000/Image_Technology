%Francisco Medel Molinero
%image
im_in=imread('cameraman.tif');

%Test1
conv_kernel=ones(3);

%Test2
% conv_kernel=[1 0 1
%     1 0 1
%     1 0 1];

%Test3
% conv_kernel=[0 1 0
%     0 1 0
%     0 1 0];

conv_kernel=conv_kernel./sum(conv_kernel(:));
im_out = im_conv(im_in,conv_kernel);
