
function image = getFaceMask(rgbImg)
    height = size(rgbImg,1);
    width = size(rgbImg,2);

    %Initialize the output images
    binaryImg = zeros(height,width);

    %Apply illumination compensation
    %imgGray = illumgray(out) or Johans

    %Convert the image from RGB to YCbCr
    img_ycbcr = rgb2ycbcr(rgbImg);
    Cb = img_ycbcr(:,:,2);
    Cr = img_ycbcr(:,:,3);

    %Detect Skin
    [r,c,v] = find(Cb>=77 & Cb<=127 & Cr>=133 & Cr<=173);
    numind = size(r,1);

    %Mark Skin Pixels
    for i=1:numind
        binaryImg(r(i),c(i)) = 1;
    end
    subplot(1,3,1);
    imshow(rgbImg);

    % Open and close to create mask
    SE1 = strel('disk', 12, 4);

    openImg = imopen(binaryImg, SE1);
    mask = imclose(openImg, SE1);

    subplot(1,3,2);
    imshow(mask);
    finalImg = rgbImg.*uint8(mask);
    subplot(1,3,3);
    imshow(finalImg);
    truesize;
    image = mask;
end


