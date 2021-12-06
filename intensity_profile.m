%% EVALUATION OF SFR FOR DIGITAL CAMERA USING ISO 12233

clc;
clear all;
close all;

% This script allows you to plot the intensity profile of the test image.

%% Selection of test image
[filename, pathname, filterindex] = uigetfile( ...
    {'*.bmp;*.tif;*.tiff;*.jpg;*.jpeg', 'All Image Files (*.bmp, *.tif, *.tiff, *.jpg, *.jpeg)'},...
    'Pick a file');

% Reading test image
input_image = imread([pathname filename]);

% 
%% Test image analysis

% Display input image
figure('Name', 'Input image', 'NumberTitle', 'Off');
imshow(input_image);

% Conversion into grayscale
im_in_gray = uint8((0.2125*input_image(:,:,1)+0.7154*input_image(:,:,2)+0.0721*input_image(:,:,3)));
% ITU 709 coefficients for red, green and blue are mentioned in the
% literature.

% Calculation of image height in pixels
im_orig_rows = size(im_in_gray, 1);

% Cropping active test chart area
figure('Name', 'Select the active (white) area of test pattern', 'NumberTitle', 'Off');
test_im = imcrop(im_in_gray);
% We choose the active part of the chart for the white heigth, the central
% part of the area, for being able to calculate the spacial frequency
% coefficient multiplier.

% Calculation of active test pattern area in pixels
im_crop_rows = size(test_im, 1);

% Cropping the horizontal sweep signal
figure('Name', 'Select the horizontal sweep signal', 'NumberTitle', 'Off');
test_bar = imcrop(test_im);
close all;
% To select the sweep signal from 100 to 1000 lwph (spatial frequencies).

% Selection of row for intensity profile display
figure('Name', 'Select row for intensity profile display', 'NumberTitle', 'Off');
imshow(test_bar);
[xi, yi, P] = impixel(test_bar);
close all;

%% MTF (Modulation Tranfer Function) calculation

% We capture the test pattern with increasing spatial frequency and with
% costant contrast to get on the output it intensity profile.

% Selection of particular image matrix row
line_profile = test_bar(yi,:);
% To choose one particular line.

% Spatial frecuency multiplier
freq_ratio = im_orig_rows/im_crop_rows;

% Display intensity profile
figure('Name', 'Intensity profile', 'NumberTitle', 'Off');
plot(linspace(100*freq_ratio, 1000*freq_ratio, length(line_profile)), line_profile);
axis([100*freq_ratio 1000*freq_ratio 0 255]);
grid on;
xlabel('Spatial frequency [LW/PH]'); ylabel('Intensity [-]');
% We get a signal where we can define envelope, which is decreasing. Some
% peaks are caused by noise and sharperning techniques from the camera. It
% is difficult to define envelope, so we use the function sfrmat3.m. This
% intensity profile is only calculated for LUMA.

% In the intensity profile we can see that with increasing spatial
% frequency the contrast is decreasing. It is not MTF, it is just the
% response of the system in spatial domain.

% Spatial frecuency vector
sp_freq = linspace(100*freq_ratio,1000*freq_ratio,length(line_profile));
sp_freq_cy_pix = sp_freq/(im_orig_rows*2);

% Envelope
[B_max_rms,B_min_rms] = envelope(double(line_profile),100,'rms');
[B_max_peak,B_min_peak] = envelope(double(line_profile),100,'peak');
% Bmax and Bmin are the maximum and minimum values of intensity
% For each frequency we calculate the Bmax and Bmin using the function
% envelope. 100 is the length of the filter. It can be calculated based on
% RMS values(root mean square) or based on peak values.

% MTF
MTF_rms = (B_max_rms-B_min_rms)./(B_max_rms+B_min_rms);
MTF_rms = MTF_rms./max(MTF_rms); % normalization

MTF_peak = (B_max_peak-B_min_peak)./(B_max_peak+B_min_peak);
MTF_peak = MTF_peak./max(MTF_peak); % normalization

% Display intensity profile and MTF
figure()
subplot(2,2,1) % intensity profile (LW/PH)
plot(sp_freq,line_profile,'b-')
hold on
plot(sp_freq,B_max_rms,'r-',sp_freq,B_min_rms,'r-');
plot(sp_freq,B_max_peak,'r--',sp_freq,B_min_peak,'r--');
hold off
axis([min(sp_freq) max(sp_freq) 0 255]);
grid on;
xlabel('Spatial frequency [LW/PH]')
ylabel('Intensity')
title('Image pixel row intensity profile')
legend('Int profile','rms','peak')

subplot(2,2,2) % intensity profile (cy/pix)
plot(sp_freq_cy_pix,line_profile,'b-')
hold on
plot(sp_freq_cy_pix,B_max_rms,'r-',sp_freq_cy_pix,B_min_rms,'r-');
plot(sp_freq_cy_pix,B_max_peak,'r--',sp_freq_cy_pix,B_min_peak,'r--');
hold off
axis([min(sp_freq_cy_pix) max(sp_freq_cy_pix) 0 255]);
grid on;
xlabel('Spatial frequency [cy/pix]')
ylabel('Intensity')
title('Image pixel row intensity profile')
legend('Int profile','rms','peak')


subplot(2,2,3) % MTF (LW/PH)
plot(sp_freq,MTF_rms,'r-')
hold on
plot(sp_freq,MTF_peak,'r--')
hold off
axis([min(sp_freq) max(sp_freq) 0 1]);
grid on;
xlabel('Spatial frequency [LW/PH]')
ylabel('MTF')
title('MTF')
legend('rms','peak')

subplot(2,2,4) % MTF (cy/pix)
plot(sp_freq_cy_pix,MTF_rms,'r-')
hold on
plot(sp_freq_cy_pix,MTF_peak,'r--')
hold off
axis([min(sp_freq_cy_pix) max(sp_freq_cy_pix) 0 1]);
grid on;
xlabel('Spatial frequency [cy/pix]')
ylabel('MTF')
title('MTF')
legend('rms','peak')

% LW/PH: line widths per picture height
% cy/pix: cycles per pixel

% The steeper the slope is on the MTF, the less the details on the output image are.
% On the MTF we are interested in evaluating the cut of frequency, because in
% special signal for direct evaluation it defines the place where we are
% not able to distinguish the black and white lines (there are midgray
% signals).

% The MTF in the center of the test pattern is different from the MTF of
% the corners (usually it is worse on the corners).

% In the figure we get two MTF. The lower one is based on RMS values, and
% the other is for peak values. The actual MTF must be between them. The
% relationship between the frequencies for LW/PH and cy/pix are ... (ver
% cómo se transforma, lo explica en min 1:09:43).

%% SFR (Spatial Frequency Response) calculation

% ESF: Edge Spread Function. The Fourier transform of the ESF is the MTF
% The images used for the edge spread function are not linear due to the angle they are at.

% For the SFR evaluation procedure:
% 1st: We must select the ROI with slanted edge.
% 2nd: We linearize the intensities using inverse OECF because the system
% is not fully linear.
% 3rd: We calculate the LSF function using difference FIR filter (the
% coefficients are -1/2, 0, 1/2).
% 4th: We calculate centroid for each LSF and linear regression.
% 5th: We determine how many pixels we need to shift the particular row to
% have it aligned.
% 6th: We perform the LSF shift using linear regresion.
% 7th: We perform avereaging of shifted LSFs at 1/4 pixel precision.
% 8th: We calculate the DFT of average LSF.
% 9th: We take the amplitude of DFT to get the actual SFR.

addpath('./sfrmat3_post/');

figure()
imshow(input_image)
title('Select edge ROI')
uiwait(msgbox('Select edge ROI')); drawnow;
test_data = imcrop(input_image);
[status, dat, e, fitme, esf, nbin, del2] = sfrmat3(1, 1, [0.2125 0.7154 0.0721], test_data);
% ROI: Region of interest.
% We convert R, G, B into LUMA using the rating coefficients from ITU 709.

figure()
subplot(1,2,1)
plot(dat(:,1),dat(:,2),'r-',dat(:,1),dat(:,3),'g-',dat(:,1),dat(:,4),'b-',dat(:,1),dat(:,5),'k-');
xlabel('Spatial frequency (cy/pix)')
ylabel('MTF')
title('SFR')
legend('Red','Green','Blue','Luma');
grid on;

subplot(1,2,2)
plot(sp_freq_cy_pix,MTF_rms,'r-');
hold on
plot(sp_freq_cy_pix,MTF_peak,'r--');
plot(dat(:,1),dat(:,5)./max(dat(:,5)),'k-');
hold off
axis([0 1 0 1]);
xlabel('Spatial frequency (cy/pix)')
ylabel('MTF')
title('Comparison bewteen MTF and SFR')
legend('MTF (rms)','MTF (peak)','SFR (norm)');
grid on; 

% The SFR is between the MTF for RMS values and the MTF for peak values.

figure()
subplot(1,3,1)
imshow(test_data)
title('ROI')
subplot(1,3,2)
plot(dat(:,1),dat(:,2),'r-',dat(:,1),dat(:,3),'g-',dat(:,1),dat(:,4),'b-',dat(:,1),dat(:,5),'k-');
xlabel('Spatial frequency (cy/pix)')
ylabel('MTF')
title('SFR')
legend('Red','Green','Blue','Luma');
grid on;

subplot(1,3,3)
plot(esf(:,1),'r-')
hold on; plot(esf(:,2),'g-'); plot(esf(:,3),'b-'); plot(esf(:,4),'k-');
hold off;
xlabel('pix')
ylabel('ESF')
title('ESF')
legend('Red','Green','Blue','luma');
grid on; 

%% Saving data
%save('Variables_test3.mat','B_max_peak','B_max_rms', 'B_min_peak', 'B_min_rms', 'dat', 'esf', 'MTF_peak', 'MTF_rms');

%% Comments

% Tenemos que explicar por qué el MTF para horizontal y vertical no es
% igual. 

% Tenemos que plotear el ESF (creo que es el IDFT) (min 1:13:50)
