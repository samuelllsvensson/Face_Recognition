clear;
clc;

id = tnm034(imread('DB2/bl_05.jpg'));
%id = tnm034(imread('DBegen/db1_09.jpg'));

%Main function
function id = tnm034(img)
    numberOfFaces = 30;%450 for whole database
    numberOfPersons = 5;
    [trainWeights, avgFace, bestEigVecs] = trainFisherFaces(numberOfFaces, numberOfPersons);
    %[trainWeights, avgFace, bestEigVecs] = trainDb(numberOfFaces, numberOfPersons);

    originalImg = img;
    processedImg = imgProcess(originalImg); % Illumination and color normalization.
    detectedFace = faceDetect(processedImg); % Rotation, scale, normalization etc.
    id = faceRecognition(detectedFace, trainWeights, avgFace, bestEigVecs, numberOfFaces, numberOfPersons); % Match features with db
end