%Author: Francisco Medel Molinero
% size in pixels (square image M*M)
size_pix = 256;

% Number of periods along a circle
num_cycles=30;

%File.tif
file_name='siemens_image.tif';

% visualization
L = siemens_pattern(size_pix, num_cycles, file_name);

figure
imshow(L);