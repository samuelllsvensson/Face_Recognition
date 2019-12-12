clear;
clc;

count = 0;

for i = 1:16
    id = tnm034(imread(sprintf('DBtest/bl_%02d.jpg', i)));
end

%Main function
function id = tnm034(img)
    numberOfFaces = 96;
    numberOfPersons = 16;
    %[trainWeights, avgFace, bestEigVecs] = trainFisherFaces(numberOfFaces, numberOfPersons);
    %save('trainWheights.mat', 'trainWeights');
    %save('avgFace.mat', 'avgFace');
    %save('bestEigVecs.mat', 'bestEigVecs');
    trainWeights = load('trainWheights.mat').trainWeights;
    avgFace = load('avgFace.mat').avgFace;
    bestEigVecs = load('bestEigVecs.mat').bestEigVecs;

    originalImg = img;
    processedImg = imgProcess(originalImg); % Illumination and color normalization.
    detectedFace = faceDetect(processedImg); % Rotation, scale, normalization etc.
    
    id = faceRecognition(detectedFace, trainWeights, avgFace, bestEigVecs, numberOfFaces, numberOfPersons) % Match features with db
end