originalImg = imread('DB1/db1_02.jpg');
tnm034(originalImg);

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
    imgMouth = getMouthMap(faceMask);
    eyeMouthImg = imgEye|imgMouth;
    
    % Get eye-mouth triangle
    face = getCandidates(eyeMouthImg);
    
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
    
    % Get normalized face eye and mouth
    props = regionprops(normMask,'centroid');
    centroids = cat(1,props.Centroid);
    normLeftEye = centroids(1,:);
    normRightEye = centroids(3,:);
    normMouth = centroids(2,:);
    
    % Create markers
    pos = [normLeftEye; normRightEye; normMouth];
    color = {'red','red','red'};
    markedFace = insertMarker(normFace,pos,'x','color',color,'size',12);
   
    % Plot normalized face
    figure;
    subplot(1,5,1)
    imshow(img);
    title('Original');
    
    subplot(1,5,2)
    imshow(eyeMouthImg);
    title('Before candidates');
    
    subplot(1,5,3)
    imshow(face);
    title('After candidates');
    
    subplot(1,5,4)
    imshow(normMask);
    title('After Alignment');
    
    subplot(1,5,5)
    imshow(markedFace);
    title('Normalized face');
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

    %featExtract(img) find features
    id = faceRecog(img); %Match features with db
end