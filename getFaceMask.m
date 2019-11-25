
function image = getFaceMask(rgbImg)
    height = size(rgbImg,1);
    width = size(rgbImg,2);

    %Initialize a binary image
    binaryImg = zeros(height,width);

    %Change color space
    img_ycbcr = rgb2ycbcr(rgbImg);
    Cb = img_ycbcr(:,:,2);
    Cr = img_ycbcr(:,:,3);
    %imshow(Cb)
    HSV = rgb2hsv(rgbImg);
    H = HSV(:,:,1);
    S = HSV(:,:,2);
    
    % --- Remove HSV for better segmentation --- & (H >= 330 & H <= 360)|(H >= 0 & H <= 80) & S >= 0.23 & S <= 0.68)
    % Find pixels with chroma values in skin range
    [r,c] = find(Cb>=77 & Cb<=200 & Cr>=134 & Cr<=173);
    numind = size(r,1);

    %Set value to pixels with skin color
    for i=1:numind
        binaryImg(r(i),c(i)) = 1;
    end
    %subplot(1,3,1);
    %imshow(rgbImg);

    % Open and close to create mask
    SE1 = strel('disk', 14, 4);

    openImg = imopen(binaryImg, SE1);
    mask = imclose(openImg, SE1);

    %subplot(1,3,2);
    %imshow(mask);
    
    rgbFaceMask = rgbImg.*uint8(mask);
    %subplot(1,3,3);
    %imshow(finalImg);
    %truesize;
    image = mask;
end


