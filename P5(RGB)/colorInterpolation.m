%Author: Francisco Medel Molinero
%Function colorInterpolation: this function is used to perform CFA color image  
function colorInterpolation(im_in)
%% Saving imput image
imwrite(im_in, 'im_in.tif');

%% Double variable for the image and saving image characteristics
im_in_double=double(im_in);

[num_rows, num_columns, num_chan]= size(im_in_double);

%% Creation and configturation of color filter masks
%RED SAMPLING MASK CONFIGURATION
R_samp=zeros(num_rows, num_columns, num_chan);
R_samp(1:2:end, 2:2:end,1) = 1;

%GREEN SAMPLING MASK CONFIGURATION(IT'S MORE COMPLEX BECAUSE WE HAVE DIFFERENT SAMPLING SEQUENCE FOR EVEN ROWS)
G_samp=zeros(num_rows, num_columns, num_chan);
G_samp(1:2:end, 1:2:end,2) = 1;
G_samp(2:2:end, 2:2:end,2) = 1;

%BLUE SAMPLING MASK CONFIGURATION
B_samp=zeros(num_rows, num_columns, num_chan);
B_samp(2:2:end, 1:2:end,3) = 1;

%%  Simulation of CFA color sampling(cosist on multiplying input double image with the mask we have created before for the diferent colors(RED, GREEN AND BLUE))
%RED IMAGE
R_im_samp = im_in_double;
R_im_samp = R_im_samp.*R_samp;
%We put R_im(:,:,2) and R_im(:,:,3)=0 because in red image we only want red
%colour, so we put green and blue values to 0
R_im= im_in_double;R_im(:,:,2) = 0; R_im(:,:,3) = 0;

%GREEN IMAGE
G_im_samp = im_in_double;
G_im_samp = G_im_samp.*G_samp;
%We put G_im(:,:,1) and G_im(:,:,3)=0 because in green image we only want
%green colour, so we put red and blue values to 0
G_im= im_in_double;G_im(:,:,1) = 0; G_im(:,:,3) = 0;

%BLUE IMAGE
B_im_samp = im_in_double;
B_im_samp = B_im_samp.*B_samp;
%We put B_im(:,:,1) and B_im(:,:,2)=0 because in blue image we only want
%blue colour, so we put red and green values to 0
B_im= im_in_double;B_im(:,:,1) = 0; B_im(:,:,2) = 0;

%% Calculation of simulated RAW image
im_out_raw_double = R_im_samp(:,:,1)+ G_im_samp(:,:,2)+B_im_samp(:,:,3);

% We have to convert raw image to uint8 to save raw image
im_out_raw=uint8(im_out_raw_double);

%% Saving simulated RAW data(RAW image has 8 bits per pixel and Colour image has 24 bits per pixel because color image has three matrix and in each pixel of the matrix it has 8 bits, so there are 24 bits for each pixel on colour image)
imwrite(im_out_raw,'im_raw.tif');

%% Simulating CFA demosaicing

% Reading RAW image file
im_in_raw=imread('im_raw.tif');

%Converting into double
im_in_raw_double=double(im_in_raw);

%Color image matrix configuration(multiplying raw image with color sampling masks)
%RED
RGB_im(:,:,1)= im_in_raw_double.*R_samp(:,:,1);

%GREEN
RGB_im(:,:,2)= im_in_raw_double.*G_samp(:,:,2);

%BLUE
RGB_im(:,:,3)= im_in_raw_double.*B_samp(:,:,3);

%For convolution

%RED
RGB_im_conv(:,:,1)=im_in_raw_double.*R_samp(:,:,1);

%GREEN
RGB_im_conv(:,:,2)=im_in_raw_double.*G_samp(:,:,2);

%BLUE
RGB_im_conv(:,:,3)=im_in_raw_double.*B_samp(:,:,3);

%% Interpolating colors using bilinear interpolation
%RRR
%G3, G13, G23, G5, G15, G25 (left and right)
RGB_im(1:2:end,3:2:end,1)= (RGB_im(1:2:end,2:2:end-1,1)+RGB_im(1:2:end,4:2:end,1))/2;
%G7, G9, G17, G19 (up and down)
RGB_im(2:2:end-1,2:2:end,1)= (RGB_im(1:2:end-2,2:2:end,1)+RGB_im(3:2:end,2:2:end,1))/2;
%B8, B10, B18, B20 (top left corner + top right corner + bottom left corner + bottom right corner)
RGB_im(2:2:end-2,3:2:end,1)= (RGB_im(1:2:end-2,2:2:end-2,1)+RGB_im(1:2:end-2,4:2:end,1)+RGB_im(3:2:end,2:2:end-2,1)+RGB_im(3:2:end,4:2:end,1))/4;

%% Interpolating colors using convolution
%RED
%Convolution kernel with different coeficients for the convolution
kern_R= [1/4 1/2 1/4; 1/2 1 1/2;1/4 1/2 1/4];

%Matrix convolution using the kernel we created before, and we put 'conv'
%to indicate to the function that we want to make a convolution
RGB_im_conv(:,:,1)=imfilter(RGB_im_conv(:,:,1), kern_R, 'conv');

%Blue
%G11, G13, G15(up + down)
RGB_im(3:2:end,1:2:end,3)=(RGB_im(2:2:end-2,1:2:end,3)+RGB_im(4:2:end,1:2:end,3))/2;
%G7, G9, G17,G19(left + right)
RGB_im(2:2:end,2:2:end-2,3)=(RGB_im(2:2:end,1:2:end-2,3)+RGB_im(2:2:end,3:2:end,3))/2;
%R12, R14, R22, R24(top left corner + top right corner + bottom left corner + bottom right corner)
RGB_im(3:2:end,2:2:end-2,3)=(RGB_im(2:2:end-2,1:2:end-2,3)+RGB_im(2:2:end-2,3:2:end,3)+RGB_im(4:2:end,1:2:end-2,3)+RGB_im(4:2:end,3:2:end,3))/4;

%% Interpolating colors using convolution
%BLUE
%Convolution kernel with different coeficients for the convolution
kern_B= [1/4 1/2 1/4;1/2 1 1/2;1/4 1/2 1/4];

%Matrix convolution using the kernel we created before, and we put 'conv'
%to indicate to the function that we want to make a convolution
RGB_im_conv(:,:,3)=imfilter(RGB_im_conv(:,:,3), kern_B, 'conv');

%Green
%R12, R14, R22, R24(top + left + right + bottom)
RGB_im(3:2:end,2:2:end-2,2)=(RGB_im(2:2:end-2,2:2:end-2,2)+RGB_im(3:2:end,1:2:end-2,2)+RGB_im(3:2:end,3:2:end,2)+RGB_im(4:2:end,2:2:end-2,2))/4;
%B8, B10, B18, B20(top + left + right + bottom)
RGB_im(2:2:end-2,3:2:end,2)=(RGB_im(1:2:end-2,3:2:end,2)+RGB_im(2:2:end-2,2:2:end-2,2)+RGB_im(2:2:end-2,4:2:end,2)+RGB_im(3:2:end,3:2:end,2))/4;

%Interpolating colors using convolution
%GREEN
%Convolution kernel with different coeficients for the convolution
kern_G=[0 1/4 0;1/4 1 1/4;0 1/4 0];

%Matrix convolution using the kernel we created before, and we put 'conv'
%to indicate to the function that we want to make a convolution
RGB_im_conv(:,:,2)=imfilter(RGB_im_conv(:,:,2), kern_G, 'conv');

%% Converting interpolated image into uint8 to save the image
RGB_im=uint8(RGB_im);
RGB_im_conv=uint8(RGB_im_conv);

%% Saving interpolated image
imwrite(RGB_im, 'im_out.tif');

%% Simulating CFA demosaicing using demosaic
%I use demosaic function to convert the Bayer pattern encoded image, to the
%truecolor image, RGB, using gradient-corrected linear interpolation.
%In the second parameter of the function we use 'grbg'(green, red, blue,
%green(2 by 2 sensor alignment))
demosaic_im = demosaic(im_in_raw, 'grbg');

%Saving interpolated image
imwrite(demosaic_im, 'im_demosaic.tif');

%% Displaying results

% Simulation of CFA color descomposition
figure
subplot(331);
imshow(im_in(:,:,1));
title('R channel');

subplot(332);
imshow(im_in(:,:,2));
title('G channel');

subplot(333);
imshow(im_in(:,:,3));
title('B channel');

subplot(334);
imshow(R_samp(:,:,1));
title('R mask');

subplot(335);
imshow(G_samp(:,:,2));
title('G mask');

subplot(336);
imshow(B_samp(:,:,3));
title('B mask');


subplot(337);
imshow(uint8(R_im_samp(:,:,1)));
title('R data');

subplot(338);
imshow(uint8(G_im_samp(:,:,2)));
title('G data');

subplot(339);
imshow(uint8(B_im_samp(:,:,3)));
title('B data');

% Input image, Raw data an interpolated image
figure
subplot(131);
imshow(im_in);
title('Input image');

subplot(132);
imshow(im_in_raw);
title('RAW');

subplot(133);
imshow(RGB_im);
title('Output');

figure
imshow(im_in);
title('Input image');

figure
imshow(im_in_raw);
title('RAW');

figure
imshow(RGB_im_conv);
title('Output Conv');

figure
imshow(demosaic_im);
title('Demosaic');

%% Calculating PSNR(PEAK SIGNAL TO NOISE RADIO) and SSIM()
%PSNR is used to compare interpolated image and input image
% We limit the limit where the PSNR is calculated, to do this, 8 pixels
% around the edges are getting rid 
PSNR_REF_BL = psnr(RGB_im(8,end-8,:), im_in(8,end-8,:))
PSNR_REF_CONV = psnr(RGB_im_conv(8,end-8,:), im_in(8,end-8,:))
PSNR_REF_DEMOSAIC = psnr(demosaic_im(8,end-8,:), im_in(8,end-8,:))

SSIM_REF_BL = ssim(RGB_im(8,end-8,:), im_in(8,end-8,:))
SSIM_REF_CONV = ssim(RGB_im_conv(8,end-8,:), im_in(8,end-8,:))
SSIM_REF_DEMOSAIC = ssim(demosaic_im(8,end-8,:), im_in(8,end-8,:))

%% Conclusions
% %kodim22
% PSNR_REF_BL and PSNR_REF_CONV have the same value(35.0487) but the value for PSNR_REF_DEMOSAIC is 42.9020(a difference of 7.8533 decibels)
% SSIM_REF_BL and SSIM_REF_CONV have the same value(0.9634) but the value for SSIM_REF_DEMOSAIC is 0.9950(ssim indicates the quality of the image, so demosaic is better than bilinear interpolation)
% %kodim23
% PSNR_REF_BL and PSNR_REF_CONV have the same value(46.8814) but the value for PSNR_REF_DEMOSAIC is  49.8917(a difference of 3,0103 decibels)
% SSIM_REF_BL and SSIM_REF_CONV have the same value(0.9958) but the value for SSIM_REF_DEMOSAIC is 0.9968(ssim indicates the quality of the image, so demosaic is better than bilinear interpolation)
% So demosaic it's better than Bilinear interpolation, if we compare the images, we will see that demosaic image is sharper and the artifacts aren't prominent.  