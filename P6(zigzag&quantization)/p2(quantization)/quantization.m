%Author: Francisco Medel Molinero
%Function quantization: quantization of an input image using quantization
%matrix
%Input values: imput image & quality
function quantization(im_in, quality)
%% Image processing
%Substraction of mid gray intensity - suppresion of DC
im_in= im_in-128;

%% 2D DCT and selection of DCT coefficients
% Common luma quantization matrix
Y_quant_mat_default = [
16 11 10 16 24 40 51 61;
12 12 14 19 26 58 60 55;
14 13 16 24 40 57 69 56;
14 17 22 29 51 87 80 62;
18 22 37 56 68 109 103 77;
24 35 55 64 81 104 113 92;
49 64 78 87 103 121 120 101;
72 92 95 98 112 100 103 99;
];

%Coefficient for quantization matrix modification, in case of quality value is
%less or equal to 0, the quality has the value of 0 and in case of quality
%value is more than 100, the quality has the value of 100
if quality <=0
    quality =1;
end;
if quality > 100
    quality = 100;
end;

%Qualities 1..50 are converted to scaling percentage 5000/Q.
%Qualities 50..100 are converted to scaling percentage 200 - 2*Q.
%At Q=100 the scaling is 0, which will cause jpeg_add_quant_table to
%maje all the table entries 1(hence, minimum quantization loss).
if (quality < 50)
    alfa = 5000 / quality;
else 
    alfa = 200 - quality*2;
end;

%We divide the input image(luma) in 8*8 blocks with function blockproc and
%we apply 2D DCT 
fun = @(block_struct) dct2(block_struct.data);
im_DCT= blockproc(im_in, [8 8], fun);

%Quantization matrix modification based on image quality
Y_quant_mat = round((Y_quant_mat_default.*alfa)./100);
Y_quant_mat(Y_quant_mat<1)=1;
Y_quant_mat(Y_quant_mat>255)=255;

% 2D DCT luma coefficients quantization
fun = @(block_struct) round(block_struct.data./Y_quant_mat);
Y_DCT_quant_round= blockproc(im_DCT, [8 8], fun);

%% Reconstruction of image from quantized coefficients
fun = @(block_struct) block_struct.data.*Y_quant_mat;
Y_DCT_quant= blockproc(Y_DCT_quant_round, [8 8], fun);

%We get the output image using inverse DCT for each 8*8 blocks of pixels
%from the reconstructed image
fun = @(block_struct) idct2(block_struct.data);
im_out= blockproc(Y_DCT_quant, [8 8], fun);

%% Postprocessing - conversion of numerical format
%Conversion of numerical format into uint8(we added 128 because we had 
% subtracted it to get the DC suppressed)
im_in=uint8(round(im_in+128));
im_out=uint8(round(im_out+128));

%% Calculation of error signal and distorsion metrics

%Error image and it's display
im_err = double(im_in)-double(im_out);
figure
imshow(im_err, []); title('Error image')
colorbar;

%Calculation of RMSE and PNSR
RMSE=sqrt(mean(im_err(:).^2))
PNSR=20*log10(255/RMSE)

%% Saving results
imwrite(im_out,'im_out(quality = 5).tif');
save('RMSE&PNSR(quality = 5).mat','RMSE','PNSR');

%% Displaying the results
figure
imshow(im_in); title('Input Image')
figure
imshow(im_out); title('Reconstructed Image')

%% Comparing results
% I have performed tests with the same image but varying the quality and 
% the result has been that the higher quality factor, the better the quality 
% of the reconstructed image, obtaining a lower error (RMSE) and a higher 
% PNSR. This is due to the fact that the higher quality, the better we can 
% configure the quant_matrix allowing to obtain better results.
% quality=3:
% RMSE=18.7015
% PNSR=22.6933

% quality=55:
% RMSE=6.2982
% PNSR=32.1465

% quality=100:
% RMSE=0.2879
% PNSR=58.9452