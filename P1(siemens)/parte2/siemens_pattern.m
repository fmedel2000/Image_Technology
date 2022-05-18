%Author: Francisco Medel Molinero
%Function siemensStar: creates a siemensStar with a circle in the middle of
%the picture.
%Input data: size_pix(size in pixels(square image)), num_cycles(number of
%sine circles along the circle), file_name
%Output data: file.tif with the siemensStar
function siemensStar = siemens_pattern(size_pix, num_cycles, file_name)
%Meshgrid with X, Y coordinates(matrix creation), mesgrid is (x,x) because 
%we have a square image
x= linspace(-1, 1, size_pix);
[X, Y]=meshgrid(x,x);

%cart2pol to convert cartesian into polar coordinates, where Theta is used
%to create the star and rho is used to create the circle in the middle of
%the image
[THETA, RHO]=cart2pol(X,Y);
siemensStar=sin(num_cycles*THETA);
siemensStar=(siemensStar+1)/2;
siemensStar=uint8(round(siemensStar*255));

%Circle in the middle(we can modify circle size)
siemensStar(RHO<0.1)=0;
%siemensStar(RHO<0.2)=0;Big middle circle
%siemensStar(RHO<0.001)=0;Very little middle circle

%We save our siemensStar with file_name as name using imwrite
imwrite(siemensStar, file_name);
end