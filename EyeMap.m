
subplot(4,4,1)

imshow(rgbImage)
title('original image');
iycbcr=rgb2ycbcr(rgbImage);
iycbcr = im2double(iycbcr);

subplot(4,4,2)
imshow(iycbcr)
title('YCBCR space');
y=iycbcr(:,:,1);
cb=iycbcr(:,:,2);
cr=iycbcr(:,:,3);

% Cb^2
ccb=cb.^2;
subplot(4,4,3)
imshow(ccb)
title('CB^2');
ccr=(1-cr).^2;

% Cr~^2
subplot(4,4,4)
imshow(ccr)
title('(1-CR)^2');

% GRAY SPACE IMAGE AND Cb/Cr
cbcr=ccb./cr;
subplot(4,4,5)
imshow(cbcr)
title('CB/CR');
igray=rgb2gray(rgbImage);
subplot(4,4,6)
imshow(igray)
title('Gray space');

% EYE MAP C
g=1./3;
l=g*ccb;
m=g*ccr;
n=g*cbcr;
eyemapC=l+m+n;
subplot(4,4,7)
imshow(eyemapC)
title('EyeMapC');

% INTENSITY IMAGE
J=histeq(eyemapC);
subplot(4,4,8)
imshow(J)
title('Equalized/intensity image');

% DILATE AND ERODE
SE=strel('disk',10,4);
o=imdilate(igray,SE);
p=imerode(igray,SE) + 1;
eyemaplum=o./p;
subplot(4,4,9)
imshow(eyemaplum)
title('EyeMapL');

