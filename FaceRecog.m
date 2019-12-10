clear;
clc;

id = tnm034(imread('DB1/db1_09.jpg'));

%Feature extraction function
%Return feature vector for this img
function features = featExtract(img)
    %Call all feature extractions here
    features = img;
end

%Main function
function id = tnm034(img)
    numberOfFaces = 30;
    numberOfPersons = 5;
    [trainWeights, avgFace, bestEigVecs] = trainFisherFaces(numberOfFaces, numberOfPersons);

    originalImg = img;
    processedImg = imgProcess(originalImg); % illumination, color etc.
    detectedFace = faceDetect(processedImg); %rotation, scale, normalization etc.

    %featExtract(img) find features
    id = faceRecognition(detectedFace, trainWeights, avgFace, bestEigVecs, numberOfFaces, numberOfPersons); %Match features with db
end