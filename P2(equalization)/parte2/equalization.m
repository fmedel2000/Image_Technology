%Author: Francisco Medel Molinero
%Function equalization: Increase image contrast by histogram equalization
%using LUT
%Input data: FirstImage: the image with which we are going to work
%Output data: FinalImage.tif: The file that contains the FinalImage
function FinalImage = equalization(FirstImage)

%We can use function histeq to return the grayscale transformation
% FinalImage = histeq(FirstImage);
% imshowpair(FirstImage,FinalImage,'montage') axis off
% figure imhist(FirstImage,64)

%Histogram normalized(PDF): We divide the histogram of the image with the total elements in the image
pdf = imhist(FirstImage)./numel(FirstImage);

%We calculate the CDF (cumulative distribution function)
cdf=cumsum(pdf);

%LUT calculation
LUT=uint8(round(255*cdf));

%another way of transform images using imagesc function
%imagesc(FirstImage);

%Final image calculation with LUT
FinalImage=LUT(FirstImage+1);

%Save the final image with imwrite
imwrite(FinalImage, 'FinalImage.tif');

figure

subplot(2,3,1);
imshow(FirstImage);
title('Imput Image');

subplot(2,3,3);
imshow(FinalImage);
title('Output Image');

subplot(2,3,4);
imhist(FirstImage);
title('Imput Image Histogram');

subplot(2,3,5);
plot(LUT,'r');
title('LUT');
xlim([0 240]);
ylim([0 260]);


subplot(2,3,6);
imhist(FinalImage);
title('Output Image');
grid on;