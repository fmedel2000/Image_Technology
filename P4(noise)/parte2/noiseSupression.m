%Author: Francisco Medel Molinero
%Function noiseSupression: this function perform an input image adding
%impulse and gaussian noise and then, the function will perform that noisy images
%with averaging and median filters 
function noiseSupression(im_in)
%% We add the different noises with imnoise function
%We create the image with salt & pepper(impulse) noise
im_salt_pepper=imnoise(im_in,'salt & pepper');

%We create the image with gaussian noise
im_gauss=imnoise(im_in, 'gaussian', 0, 0.01);

%% Displaying the input image, and noisy images
figure(1)
subplot(231); 
imshow(im_in);
title('Imput image');
subplot(232);
imshow(im_salt_pepper);
title('Impulse Noise');
subplot(233);
imshow(im_gauss);
title('Gaussian noise');
subplot(234);
imhist(im_in);
title('Reference image(histogram)');
subplot(235);
imhist(im_salt_pepper);
title('Impulse Noise(histogram)');
subplot(236);
imhist(im_gauss);
title('Gaussian noise(histogram)');

%% Average and median filtration
%We create the average kernel
psf_avg=fspecial('average',[3 3]);

%Median filtration using a kernel of 3*3 to the salt pepper image
im_salt_pepper_med=medfilt2(im_salt_pepper, [3 3]);

%Average filtration using an average kernel circular to the salt pepper
%image
im_salt_pepper_avg=imfilter(im_salt_pepper,psf_avg,'circular','same');

%Median filtration using a kernel of 3*3 to the gauss image
im_gauss_med=medfilt2(im_gauss,[3 3]);

%Average filtration using an average kernel circular to the gauss image
im_gauss_avg=imfilter(im_gauss, psf_avg, 'circular', 'same');

%% Display the filtration of the noisy images with average and median filters
%Salt_pepper
figure(2)
subplot(231);
imshow(im_salt_pepper);
title('Noisy image');

subplot(232);
imshow(im_salt_pepper_med);
title('Median');

subplot(233);
imshow(im_salt_pepper_avg);
title('Average');

subplot(234);
imhist(im_salt_pepper);
title('Noisy image(histogram)');

subplot(235);
imhist(im_salt_pepper_med);
title('Median(histogram)');

subplot(236);
imhist(im_salt_pepper_avg);
title('Average(histogram)');

%Gauss
figure(3)
subplot(231);
imshow(im_gauss);
title('Noisy image');

subplot(232);
imshow(im_gauss_med);
title('Median');

subplot(233);
imshow(im_gauss_avg);
title('Average');

subplot(234);
imhist(im_gauss);
title('Noisy image(histogram)');

subplot(235);
imhist(im_gauss_med);
title('Median(histogram)');

subplot(236);
imhist(im_gauss_avg);
title('Average(histogram)');

%% Conclusions 
%Average and median filters eliminate extraneous data in fundamentally 
%different ways. An average folds "noise" in with the signal so that if 
%enough points are selected, the noise is reduced by summing to its own 
%(nearly) zero average value. On the other hand, a median filter eliminates
%noise by ignoring it.
