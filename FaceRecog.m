clear;
clc;

baseVectors = zeros(85800, 16);

for i=1:16
  originalImg = imread(sprintf('DB1/db1_%02d.jpg', i));
  id = im2double(tnm034(originalImg));
  baseVectors(:, i) = id(:);
end

testImg = imread('DB2/ex_03.jpg');
testId = im2double(tnm034(testImg));
imshow(testId);
testBaseVector = testId(:);

baseVectors(:, 8) = [];

avgFace = (1.0/15.0)*sum(baseVectors, 2);
faceVariations = baseVectors - avgFace;
testFaceVariation = testBaseVector - avgFace;

%imshow(reshape(faceVariations(:, 2), [330, 260]));

C = faceVariations' * faceVariations;

[eigVec, ~] = eig(C);

bestEigVecs = faceVariations * eigVec;

%imshow(reshape(bestEigVecs(:, 15), [330, 260]));

weights = bestEigVecs' * faceVariations; % Transposed?
testWeight = bestEigVecs' * testFaceVariation;

smallestDistance = 10000000000;
smallestI = -1;

for i=1:15
    distance = norm(weights(:, i)-testWeight);
    if (distance<smallestDistance)
        smallestDistance = distance;
        smallestI = i;
    end
end

figure; hold on;
imshow(reshape(baseVectors(:, smallestI), [330, 260]));


%apa = avgFace + bestEigVecs * weights;

%imshow(reshape(apa, [330, 260]), []);

%figure; hold on;
%imshow(reshape(avgFace, [330, 260]), []);

%Image processing function
function image = imgProcess(img)
    %Call all image processing functions
    image = lightCompensationAlt(img); % Try with lightCompensationAlt also
    
    image = img;
end

%Return final face image
function face = faceDetect(img)

    % Get face mask
    faceMask = getFaceMask(img);
    
    % Get eye and mouth map
    imgEye = getEyeMap(faceMask);
    [imgMouth, mouthX, mouthY] = getMouthMap(faceMask);  
    figure;
    
    % Get eye-mouth triangle
    imgEye = getCandidates(imgEye, mouthX, mouthY);
    face = imgEye|imgMouth;
    
    % Align face
    [angle, dx, dy, leftEye, rightEye, mouth] = faceAlignment(face);
    
    % Size of cropped image
    xSize = (rightEye(1)-leftEye(1))+200;
    ySize = (mouth(2)-rightEye(2))+100;
    
    % Normalize mask
    normMask = imrotate(face, angle);
    normMask = imtranslate(normMask,[dx,dy]);
    targetSize = [floor(xSize) floor(ySize)];
    r = centerCropWindow2d(size(normMask),targetSize);
    normMask = imcrop(normMask,r);
    
    % Normalize face
    normFace = imrotate(img, angle);
    normFace = imtranslate(normFace,[dx,dy]);
    normFace = rgb2gray(normFace);
    normFace = imcrop(normFace,r);
    normFace = imresize(normFace, [330 260]);
        
%     % Get normalized face eye and mouth
%     props = regionprops(normMask,'centroid');
%     centroids = cat(1,props.Centroid);
%     normLeftEye = centroids(1,:);
%     normRightEye = centroids(3,:);
%     normMouth = centroids(2,:);
%     
%     % Create markers
%     pos = [normLeftEye; normRightEye; normMouth];
%     color = {'red','red','red'};
%     markedFace = insertMarker(normFace,pos,'x','color',color,'size',12);
%    
%     % Plot normalized face
%     figure;
%     subplot(1,5,1)
%     imshow(img);
%     title('Original');
%     
%     subplot(1,5,2)
%     imshow(eyeMouthImg);
%     title('Before candidates');
%     
%     subplot(1,5,3)
%     imshow(face);
%     title('After candidates');
%     
%     subplot(1,5,4)
%     imshow(normMask);
%     title('After Alignment');
%     
%     subplot(1,5,5)
%     imshow(markedFace);
%     title('Normalized face');

    face = normFace;
    imshow(face);
end

%Feature extraction function
%Return feature vector for this img
function features = featExtract(img)
    %Call all feature extractions here
    features = img;
end

function id = faceRecog(img)
    %Match face with db and return id
    %return 0 if no match was found
    id = img;
end

%Main function
function id = tnm034(img)
    img = imgProcess(img); % illumination, color etc.
    img = faceDetect(img); %rotation, scale, normalization etc.
    
    id = img;

    %featExtract(img) find features
    %id = faceRecog(img); %Match features with db
end