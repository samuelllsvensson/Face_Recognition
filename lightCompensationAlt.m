% Light compensation with reference white
function image = lightCompensationAlt(img)
    imgSize = size(img);
    lightPixelsAmount = 0.01;
    k = uint64(lightPixelsAmount * imgSize(1)*imgSize(2)); % Number of pixels to select

    imgYCGCR = rgb2ycbcr(img);
    Y = imgYCGCR(:, :, 1);

    topLumaPixels = find(Y(:)>223); % >223 is top 5% of luma

    image = img;

    if size(topLumaPixels, 1) > 100 % Only proceed if enough light pixels
        r = img(:, :, 1);
        g = img(:, :, 2);
        b = img(:, :, 3);
        rVec = r(:);
        gVec = g(:);
        bVec = b(:);

        maxKR = rVec(topLumaPixels);
        maxKG = gVec(topLumaPixels);
        maxKB = bVec(topLumaPixels);

        maxR = mean(maxKR);
        maxG = mean(maxKG);
        maxB = mean(maxKB);

        img2 = double(img);

        img2(:, :, 1) = img2(:, :, 1)./maxR.*255;
        img2(:, :, 2) = img2(:, :, 2)./maxG.*255;
        img2(:, :, 3) = img2(:, :, 3)./maxB.*255;

        image = uint8(img2);
    end
end