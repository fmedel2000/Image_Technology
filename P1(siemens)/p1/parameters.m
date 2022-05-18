%Author: Francisco Medel Molinero
% size in pixels (square image)
size_pix = 256;

% spatial frequencies (cycles per pixel)
x_freq = 0.02;
y_freq = 0.03;

file_name='test_pattern_image.tif';

% visualization
L = test_pattern(size_pix, x_freq, y_freq, file_name);

figure
imshow(L);