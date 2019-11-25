
% ---------- ILLUMINATION-BASED METHOD -----------
% Original
%function image = getEyeMap(img)

% Read image
rgbImage = imread('db1_01.jpg');

subplot(6,4,1);
imshow(rgbImage);
title('original image');
iycbcr=rgb2ycbcr(rgbImage);
iycbcr = im2double(iycbcr);

% YCbCr
subplot(6,4,2);
imshow(iycbcr);
title('YCBCR space');
y=iycbcr(:,:,1);
cb=iycbcr(:,:,2);
cr=iycbcr(:,:,3);

% Y
subplot(6,4,5);
imshow(y);
title('Y');

% Cb
subplot(6,4,6);
imshow(cb);
title('CB');

% Cr
subplot(6,4,7);
imshow(cr);
title('CR');

% Cr^2 
subplot(6,4,8);
cr2 = cr.^2;
cr2hist = histeq(cr2);
imshow(cr2hist)
title('CR^2');

% Cb^2 FOR EYEMAPC
ccb=cb.^2;
cb2hist = histeq(ccb);
subplot(6,4,9);
imshow(cb2hist);
title('CB^2');

% Cr~^2 FOR EYEMAPC
ccr=(1-cr).^2;
ccrHist = histeq(ccr);
subplot(6,4,10);
imshow(ccrHist);
title('(1-CR)^2');

% Cb/Cr FOR EYEMAPC
cbcr=cb./cr;
cbcrNorm = cbcr./max(max(cbcr));
subplot(6,4,11);
imshow(cbcrNorm);
title('CB/CR');

% EYE MAP C
g=1./3;
% Cb^2
l=g*cb2hist;
% Cr~^2
m=g*ccrHist;
% Cb/Cr
n=g*cbcrNorm;
eyemapC=l+m+n;
J=histeq(eyemapC);
subplot(6,4,12);
imshow(J);
title('Eye Map C');


% Eye Map L
SE=strel('disk',8);
%yhist = histeq(y);
o=imdilate(y,SE);
p=imerode(y,SE);
eyemapL=o./(p+1);
%BWeyemapL = imbinarize(eyemapL, 'adaptive');
subplot(6,4,13);
imshow(eyemapL);
title('Eye Map L');

% TOTAL EYEMAP 
%Eyemap = imfuse(eyemapC, eyemapL, 'blend');
Eyemap = eyemapC.*eyemapL; % BORDE VARA DENNA ENLIGT PAPER
subplot(6,4,14);
imshow(Eyemap);
title('Eye Map C AND Eye Map L');

% DILATED AND THRESHHOLDED
SE1=strel('disk',12);
q = imdilate(Eyemap, SE1);
%threshold =240; % custom threshold value
%q_bw = q > threshold;
BW = imbinarize(q, 'global');
subplot(6,4,15);
imshow(BW);
title('Dilated and threshholded');


% ---------- COLOR-BASED METHOD -----------

% GRAY SPACE IMAGE
igray=rgb2gray(rgbImage);
subplot(6,4,16);
imshow(igray);
title('Gray space');
% HISTOGRAM EQUALIZED INTENSITY IMAGE
J=histeq(igray);
subplot(6,4,17);
imshow(J);
title('Histogram equalized');
threshold = 110; % custom threshold value
gray_thresh = igray > threshold;
subplot(6,4,18);
imshow(gray_thresh);
title('Threshholded');

% ---------- EDGE-DENSITY-BASED METHOD -----------
sobelIm = edge(igray,'sobel');
subplot(6,4,19);
imshow(sobelIm);
title('Sobel edges');

SE2=strel('disk',5,8);
sobelImD1 = imdilate(sobelIm, SE2);
sobelImD2 = imdilate(sobelImD1, SE2);
sobelImE1=imerode(sobelImD2,SE2);
sobelImE2=imerode(sobelImE1,SE2);
sobelImE3=imerode(sobelImE2,SE);

subplot(6,4,20);
imshow(sobelImE3);
title('Dilated x2, Eroded x3');

% ---------- RESULTS ----------
subplot(6,4,21);
imshow(BW);
title('Illumination-based');
subplot(6,4,22);
imshow(gray_thresh);
title('Color-based');
subplot(6,4,23);
imshow(sobelImE3);
title('Edge-density-based');

% APPLY RULES 





% Final 
IC = BW.*gray_thresh; 
IE = BW.*sobelImE3;
CE = gray_thresh.*sobelImE3;

OrTotal = IC | IE | CE; 
subplot(6,4,24);
imshow(OrTotal);
title('Total (All methods)');
% ----------
sgtitle('HYBRID METHOD FOR EYE DETECTION ')
truesize;

%end