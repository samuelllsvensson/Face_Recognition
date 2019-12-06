function mMap = getMouthMap(image)
    imgMod = rgb2ycbcr(image);
    imgMod = im2double(imgMod);

    cr = imgMod(:,:,3);
    cr2 = (cr.*cr);
    cb = imgMod(:,:,2);
    crcb = (cr./cb)./(max(max(cr./cb)));
    y = imgMod(:,:,1);
    [row,col] = size(imgMod);
    n = row*col;

    var1 = (sum(cr2(:)/n));
    var2 = (sum(crcb(:))/n);
    var3 = 0.95*(var1/var2);

    mMap = cr2.*((cr2-var3*crcb).*(cr2-var3*crcb));

    mMapMin = min(mMap(:));
    mMap=(mMap-mMapMin)/(max(mMap(:))-mMapMin);

    se = strel('disk', 15, 8);
    mMap = imdilate(mMap, se);

    mMap = (mMap > 0.95);
end