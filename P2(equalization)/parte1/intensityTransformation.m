%Author: Francisco Medel Molinero
%Function intensityTransformation: Increase image contrast by histogram
%stretching using LUT
%Input data: FirstImage: the image with which we are going to work
%Output data: FinalImage.tif: The file that contains the FinalImage
function FinalImage = intensityTransformation(FirstImage)

%Contrast adjust using the function imadjust
%FinalImage = imadjust(FirstImage,[0.3 0.7],[]);
 
%Contrast adjust using vectors
ceros = zeros(1,70);
unos = ones(1,100);
Lut = linspace(0,1);

%We combine the last three vectors to get the LUT
LUT = (uint8([ceros, Lut, unos]*256));

FinalImage= LUT(FirstImage + 1);
%Save the final image with imwrite
imwrite(FinalImage, 'FinalImage.tif');


figure()

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