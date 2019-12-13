function image = getEyeMap(img, originalImg)
    % Read image
    rgbImage = img;
    
    % ---------- ILLUMINATION-BASED METHOD -----------
    iycbcr=rgb2ycbcr(rgbImage);
    iycbcr = im2double(iycbcr);

    % YCbCr
    y=iycbcr(:,:,1);
    cb = iycbcr(:,:,2);
    cr = iycbcr(:,:,3);
    
    % Cr^2 
    cr2 = cr.^2;
  
    % Cb^2 FOR EYEMAPC
    cb2=cb.^2;
    
    % Cr~^2 FOR EYEMAPC
    cr2Inv=(1-cr).^2;
  
    % Cb/Cr FOR EYEMAPC
    cbcr=(cb./cr);
    cbcr=cbcr./max(max(cbcr));

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
    
    % DILATE AND ERODE
    SE=strel('disk',10);
    o=imdilate(y,SE);
    p=imerode(y,SE) + 1;
    eyemapL=o./p;

    % TOTAL EYEMAP 
    Eyemap = eyemapChist.*eyemapL;
  
    % DILATED AND THRESHHOLDED
    SE1=strel('disk', 9);
    q = imdilate(Eyemap, SE1);
    threshold = 0.75;
    qMask = q > threshold;
    
    % Apply rules
    qMask = ruleRefinements(qMask);
    
    % ---------- COLOR-BASED METHOD -----------
    % GRAY SPACE IMAGE
    igray=rgb2gray(originalImg);
 
    % HISTOGRAM EQUALIZED INTENSITY IMAGE
    J=histeq(igray);

    threshold = 0; 
    grayThresh = J < threshold;
    
    % Apply rules
    grayThresh = ruleRefinements(grayThresh);

    % ---------- EDGE-DENSITY-BASED METHOD -----------
    sobelIm = edge(igray,'sobel');

    SE2=strel('disk', 4); % 4 is better but 5 is needed for 450 images
    sobelImD1 = imdilate(sobelIm, SE2);
    sobelImD2 = imdilate(sobelImD1, SE2);
    sobelImE1=imerode(sobelImD2,SE2);
    sobelImE2=imerode(sobelImE1,SE2);
    sobelImE3=imerode(sobelImE2,SE2);
    
    % Apply rules
    sobelImE3 = ruleRefinements(sobelImE3);

    % Final 
    IC = qMask & grayThresh; 
    IE = qMask & sobelImE3;
    CE = grayThresh & sobelImE3;

    OrTotal = IC | IE | CE; 

    image = OrTotal;
end