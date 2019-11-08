
%PreProcessing the images in db
%Only for us
function image = preProcess(img)
    %imageProcessing(img)
    %faceDetection(img)
    %featureExtraction(img)
    image = img;
end

%Image processing function
function image = imgProcess(img)
    %Call all image processing functions
    image = img;
end

%Return final face image
function face = faceDetect(img)
    %Call all face detection functions
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
    %imgProcess(img) illumination, color etc.
    %faceDetect(img) rotation, scale, normalization etc.
    %featExtract(img) find features
    id = faceRecog(img) %Match features with db
end