function imgRot = eyeAlignment(img)
BW = im2bw(img);
s = regionprops(BW,'centroid');
centroids = cat(1,s.Centroid);

[m,n] = size(centroids)
angle = 0;

if(m > 1 && n > 1)
    eyeDist = centroids(2,1) - centroids(1,1);
    eyeLevel = centroids(2,2) - centroids(1,2);
    angle = radtodeg(atan(eyeLevel/eyeDist));
end

imgRot = imrotate(img, angle);
end
