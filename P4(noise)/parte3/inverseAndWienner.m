%Author: Francisco Medel Molinero
%Function inverseAndWienner: this function degrade an input image and then 
%an additive noise is added to the degrade image, once we get the noisy image,
%the noisy image is reconstructured with inverse filtration and Wienner
%fitration
function inverseAndWienner(im_in)
%% Degrade image creation
%We create the distorsion using LSI model, PSF is a filter to approximate
%, once convolved with an image, the linear motion of a camera. 
%20 specifies the length of the motion and 45 specifies the angle of motion
%in degrees in a counter-clockwise direction. 
PSF=fspecial('motion',20,45);

%Calculation of blurry image using the imput image and the PSF distorsion
im_deg=imfilter(im_in, PSF, 'circular', 'same');

%% Additive noise
sigma=0.0005;%If we reduce sigma, the images will have less noise

%randn returns an size(im_deg)-by-size
%(im_deg) matrix of normally distributed random numbers.
im_noise=sigma*randn(size(im_deg));

%Noisy image
im_deg_noise=im_deg+im_noise;

%% Display imput image, blurry image and noise image
figure(1)
subplot(221);
imshow(im_in, []);
title('Input image');
subplot(222);
imshow(im_deg, []);
title('Blurry image');
subplot(223);
imshow(im_noise, []);
title('Noise image');
subplot(224);
imshow(im_deg_noise, []);
title('Blurry and noise image');

%% Reconstruction using inverse filtration
%The noisy image can be reconstructured with function deconvwnr putting
%into the arguments the same filter that we used to create the degrade
%image
im_rec_inv=deconvwnr(im_deg_noise,PSF);

%% Reconstruction using Wienner filtration
%Noise power spectrum
Sn=abs(fft2(im_noise)).^2;%fft2 is used to create 2D fourier transformation
%Mean power of noise
nA= mean(Sn(:));
%Image power spectrum
Sf=abs(fft2(im_in)).^2;
%Mean power of image
fA= mean(Sf(:));
%Noise to signal ratio
R=nA/fA;

%Wienner filtration
im_rec_wie=deconvwnr(im_deg_noise, PSF, R);

R=Sn./Sf;
im_rec_wie2=deconvwnr(im_deg_noise, PSF, R);

%% Showing image reconstruction with inverse filtration and Wienner filtration
figure(2)
subplot(221);
imshow(im_deg_noise, []);
title('Blurry and noisy image');
subplot(222);
imshow(im_rec_inv, []);
title('Inverse filtration');
subplot(223);
imshow(im_rec_wie, []);
title('Wienner filtration 1');
subplot(224);
imshow(im_rec_wie2, []);
title('Wienner filtration 2');

imwrite(im_rec_inv,'Inverse filtration.tif')
imwrite(im_rec_wie,'Wienner filtration 1.tif')
imwrite(im_rec_wie2,'Wienner filtration 2.tif')
%% Conclusions
% inverse filtering is very sensitive to additive noise. 
% The Wiener filtering executes an optimal tradeoff between inverse filtering and noise smoothing.
% It removes the additive noise and inverts the blurring simultaneously.
% The Wiener filtering is optimal in terms of the mean square error.
