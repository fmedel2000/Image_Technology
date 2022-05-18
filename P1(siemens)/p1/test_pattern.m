%Author: Francisco Medel Molinero
%Function test_pattern: square test pattern with sinosoidal intensity
%profile
%Input data: size_pix(size in pixels(square image)), spatial frequencies (cycles per pixel, x_freq and y_freq), file_name
%Output data: file.tif with the square image
function test = test_pattern(size_pix, x_freq, y_freq,file_name)
%M*N vectors with size of pixels of the image(vectors)
M = 0:size_pix-1;
%Square image so N=M
N = M;
%Creation of the matrix with meshgrid
[m n]=meshgrid(M,N);

%We use 8 bit intensity representation
test=cos(2*pi*x_freq*m+2*pi*y_freq*n);
test=(test+1)/2;
test=uint8(round(test*255));

%We save the test in a file with the file name given in the arguments of
%the function.
imwrite(test, file_name);
end