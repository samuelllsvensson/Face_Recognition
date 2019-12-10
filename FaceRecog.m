clear;
clc;

id = tnm034(imread('DB2/bl_01.jpg'));

%Feature extraction function
%Return feature vector for this img
function features = featExtract(img)
    %Call all feature extractions here
    features = img;
end

%Main function
function id = tnm034(img)
    [trainWeights, avgFace, bestEigVecs] = trainDb();

    originalImg = img;
    processedImg = imgProcess(originalImg); % illumination, color etc.
    detectedFace = faceDetect(processedImg); %rotation, scale, normalization etc.

    %featExtract(img) find features
    id = faceRecognition(detectedFace, trainWeights, avgFace, bestEigVecs); %Match features with db
end