%Author: Francisco Medel Molinero
%Function im_conv: 2D discrete convolution with diferent methods and
%kernels
function im_out = im_conv(im_in,conv_kernel)
%2D convolution using conv2
% im_out=conv2(im_in, conv_kernel);

%2D convolution using imfilter
% im_out=imfilter(im_in, conv_kernel);

%2D convolution using for loops

%Input matrix and kernel sizes
[in_rows, in_columns]= size(im_in);
[kernel_rows, kernel_columns]= size(conv_kernel);

%Size of output matrix
out_rows=in_rows - (kernel_rows-1);
out_columns=in_columns - (kernel_columns-1);

%Output matrix
im_out=zeros(out_rows,out_columns);

%Numerical format
im_in= double(im_in);
conv_kernel=double(conv_kernel);

%Calculation using for loops
for i=1:out_rows
    for j=1:out_columns
        in_pom=im_in(i:i+kernel_rows-1, j:j+kernel_columns-1);
        im_out(i,j)=sum(sum(in_pom.*conv_kernel));
    end
end

%Numerical format(Imput image)
im_in=uint8(round(im_in));

%Numerical format(Output image)
im_out=uint8(round(im_out));

%Printing the results(we can see the difference between Input and Output images)
figure
subplot(1,2,1);
imshow(im_in);
title('Imput Image');

subplot(1,2,2);
imshow(im_out);
title('Output Image');

%Saving the final image
imwrite(im_out,'Test1.tif')

% TEST 2(USING FSPECIAL)
H = fspecial('motion',20,45); MotionBlur = imfilter(im_in,H,'replicate');
L = fspecial('disk',10); blurred = imfilter(im_in,L,'replicate');

figure
subplot(1,3,1);
imshow(im_in);
title('Imput Image');

subplot(1,3,2);
imshow(MotionBlur);
title('MotionBlur');

subplot(1,3,3);
imshow(blurred);
title('blurred');

imwrite(MotionBlur,'MotionBlur.tif')
imwrite(blurred,'blurred.tif')
