%Author: Francisco Medel Molinero
%Function masking: Implementation and demonstration DCT coefficients 
%masking in order of zig‐zag scan
%Input values: imput image & num of coefficients for masking
function masking(im_in, num_coefficients)
%% 2D DCT and selection of DCT coefficients
%We divide the input image(luma) in 8*8 blocks with function blockproc and
%we apply 2D DCT 
fun = @(block_struct) dct2(block_struct.data);
im_DCT= blockproc(im_in, [8 8], fun);

%Definition of zig-zag readout
Y_zig_zag = [
1 2 6 7 15 16 28 29;
3 5 8 14 17 27 30 43;
4 9 13 18 26 31 42 44;
10 12 19 25 32 41 45 54;
11 20 24 33 40 46 53 55;
21 23 34 39 47 52 56 61;
22 35 38 48 51 57 60 62;
36 37 49 50 58 59 63 64;
];

%Calculation of 2D DCT mask(total number of coefficients form transmission - num_coefficients)
%Firstly we configure the mask with 0 values(8*8) and then we put 1
%depending on how many coefficients we have
DCT_mask = zeros(8);DCT_mask(Y_zig_zag<=num_coefficients)=1;

%LUT to read DCT coefficients matrix into a vector
Y_zig_zag=Y_zig_zag(:);
[x Y_zig_zag]= sort(Y_zig_zag);

%We multiply 2D DCT coefficients with the DCT mask to get reconstructed image in
%blocks of 8*8 pixels
fun = @(block_struct) block_struct.data.*DCT_mask;
im_DCT_reconstructed= blockproc(im_DCT, [8 8], fun);

%% Reconstruction of image from limited number of coefficients

%We get the output image using inverse DCT for each 8*8 blocks of pixels
%from the reconstructed image
fun = @(block_struct) idct2(block_struct.data);
im_out= blockproc(im_DCT_reconstructed, [8 8], fun);

%% Postprocessing - conversion of numerical format
%Conversion of numerical format into uint8
im_in=uint8(round(im_in));
im_out=uint8(round(im_out));

%% Error signal and distorsion metrics
%We calculate the error(reconstructed image-input image) and we show it
im_err = double(im_in)-double(im_out);
figure
imshow(im_err, []); title('Error image')
colorbar;

%Calculation of RMSE and PNSR
RMSE=sqrt(mean(im_err(:).^2))
PNSR=20*log10(255/RMSE)

%% Saving results
imwrite(im_out,'im_out(1 coefficients).tif');
save('RMSE&PNSR(1 coefficients).mat','RMSE','PNSR');

%% Displaying the results
figure
imshow(im_in); title('Input Image')
figure
imshow(im_out); title('Reconstructed Image')

%% Comparing results
% I have performed tests with the same image but varying the number of 
% coefficients (1,4 and 32) and the result has been that the higher the 
% number of coefficients,the better the quality of the reconstructed image, 
% obtaining a lower error (RMSE) and a higher PNSR.This is due to the 
% fact that the higher the number of coefficients, the better we can 
% configure the DCT_mask allowing to obtain better results.
% 1 coefficient:
% RMSE=27.0778
% PNSR=19.4785

% 4 coefficients:
% RMSE=19.6018
% PNSR=22.2849

% 32 coefficients:
% RMSE=6.5789
% PNSR=31.7677
