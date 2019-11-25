function [angle, dx, dy] = faceAlignment(img)
BW = im2bw(img);
s = regionprops(BW,'centroid');
centroids = cat(1,s.Centroid);

[m,n] = size(centroids);
angle = 0;

%Find angle between eyes
if(m > 1 && n > 1)
    eyeDist = centroids(m,1) - centroids(1,1);
    eyeLevel = centroids(m,2) - centroids(1,2);
    angle = radtodeg(atan(eyeLevel/eyeDist));
end

imgRot = imrotate(img, angle);
BW = im2bw(imgRot);
[col,row, ~] = size(BW);
s = regionprops(BW,'centroid');
centroids = cat(1,s.Centroid);

%Find center of triangle
eyeMouthLevel = centroids(2,2) - centroids(1,2);
centerTri = [centroids(2,1), centroids(2,2)-eyeMouthLevel/2];

dx = col/2 - centerTri(1,1);
dy = row/2 - centerTri(1,2);
end
