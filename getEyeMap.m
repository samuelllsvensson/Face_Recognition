% ---------- ILLUMINATION-BASED METHOD -----------
% Original
function image = getEyeMap(img)
    % Read image
    rgbImage = img;

    subplot(6,4,1)
    imshow(rgbImage)
    title('original image');
    iycbcr=rgb2ycbcr(rgbImage);
    iycbcr = im2double(iycbcr);

    % YCbCr
    subplot(6,4,2)
    imshow(iycbcr)
    title('YCBCR space');
    y=iycbcr(:,:,1);
    cb=iycbcr(:,:,2);
    cr=iycbcr(:,:,3);

    % Y
    subplot(6,4,5)
    imshow(y)
    title('Y');

    % Cb
    subplot(6,4,6)
    imshow(cb)
    title('CB');

    % Cr
    subplot(6,4,7)
    imshow(cr)
    title('CR');

    % Cr^2 
    subplot(6,4,8)
    cr2 = cr.^2;
    imshow(cr2)
    title('CR^2');

    % Cb^2 FOR EYEMAPC
    cb2=cb.^2;
    subplot(6,4,9)
    imshow(cb2)
    title('CB^2');

    % Cr~^2 FOR EYEMAPC
    cr2Inv=(1-cr).^2;
    subplot(6,4,10)
    imshow(cr2Inv)
    title('(1-CR)^2');

    % Cb/Cr FOR EYEMAPC
    cbcr=(cb./cr);
    cbcr=cbcr./max(max(cbcr));
    subplot(6,4,11)
    imshow(cbcr)
    title('CB/CR');

    % EYE MAP C
    g=1/3;
    % Cb^2
    l=g*cb2;
    % Cr^2
    m=g*cr2;
    % Cb/Cr
    n=g*cbcr;
    eyemapC=l+m+n;
    eyemapChist = histeq(eyemapC);
    subplot(6,4,12)
    imshow(eyemapChist)
    title('Eye Map C');


    % DILATE AND ERODE
    SE=strel('disk',10);
    o=imdilate(y,SE);
    p=imerode(y,SE) + 1;
    eyemapL=o./p;
    subplot(6,4,13)
    imshow(eyemapL)
    title('Eye Map L');

    % TOTAL EYEMAP 
    Eyemap = eyemapChist.*eyemapL; % BORDE VARA DENNA ENLIGT PAPER
    subplot(6,4,14)
    imshow(Eyemap)
    title('Eye Map C fused with Eye Map L')

    % DILATED AND THRESHHOLDED
    SE1=strel('disk', 10);
    q = imdilate(Eyemap, SE1);
    threshold = 0.75; % custom threshold value
    qMask = q > threshold;
    %BW = imbinarize(q, 'adaptive');
    subplot(6,4,15)
    imshow(qMask)
    title('Dilated and threshholded');


    % ---------- COLOR-BASED METHOD -----------

    % GRAY SPACE IMAGE
    igray=rgb2gray(rgbImage);
    subplot(6,4,16)
    imshow(igray)
    title('Gray space');
    % HISTOGRAM EQUALIZED INTENSITY IMAGE
    J=histeq(igray);
    subplot(6,4,17)
    imshow(J)
    title('Histogram equalized');
    threshold = 60; % custom threshold value
    grayThresh = igray > threshold;
    grayThreshInv = 1 - grayThresh;
    subplot(6,4,18)
    imshow(grayThreshInv)
    title('Threshholded');

    % ---------- EDGE-DENSITY-BASED METHOD -----------
    sobelIm = edge(igray,'sobel');
    subplot(6,4,19)
    imshow(sobelIm)
    title('Sobel edges');

    SE2=strel('disk',12);
    sobelImD1 = imdilate(sobelIm, SE2);
    sobelImD2 = imdilate(sobelImD1, SE2);
    sobelImE1=imerode(sobelImD2,SE2);
    sobelImE2=imerode(sobelImE1,SE2);
    sobelImE3=imerode(sobelImE2,SE2);

    subplot(6,4,20)
    imshow(sobelImE3)
    title('Dilated x2, Eroded x3');

    % ---------- RESULTS ----------
    subplot(6,4,21)
    imshow(qMask)
    title('Illumination-based');
    subplot(6,4,22)
    imshow(grayThreshInv)
    title('Color-based');
    subplot(6,4,23)
    imshow(sobelImE3)
    title('Edge-density-based');

    % Final 
    IC = qMask & grayThreshInv; 
    IE = qMask & sobelImE3;
    CE = grayThreshInv & sobelImE3;

    OrTotal = IC | IE | CE; 
    subplot(6,4,24)
    imshow(OrTotal)
    title('Total (All methods)');

    % ----------
    sgtitle('HYBRID METHOD FOR EYE DETECTION ')
    image = OrTotal;
end