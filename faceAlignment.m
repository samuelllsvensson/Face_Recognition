function [angle, dx, dy, leftEye, rightEye, mouth] = faceAlignment(BW)
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

%imgRot = imrotate(img, angle);
 
BW = imrotate(BW, angle);
[col,row, ~] = size(BW);
s = regionprops(BW,'centroid');
centroids = cat(1,s.Centroid);

%Find center of triangle
eyeMouthLevel = centroids(2,2) - centroids(1,2);
centerTri = [centroids(1,1)+floor(centroids(3,1)-centroids(1,1))/2, centroids(2,2)-eyeMouthLevel/2];

dx = row/2 - centerTri(1,1);
dy = col/2 - centerTri(1,2);
leftEye = centroids(1,:);
mouth = centroids(2,:);
rightEye = centroids(3,:);
end
