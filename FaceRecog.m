originalImg = imread('DB1/db1_10.jpg');
tnm034(originalImg);
%Image processing function
function image = imgProcess(img)
    %Call all image processing functions
    image = lightCompensationAlt(img); % Try with lightCompensationAlt also
    
    image = img;
end

%Return final face image
function face = faceDetect(img)
    %Call all face detection functions
    img = getFaceMask(img);
    img = getEyeMap(img);
    face = img;
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
    figure;
    hold on;
    imshow(img)
    %featExtract(img) find features
    id = faceRecog(img); %Match features with db
end


