clear;
clc;

id = tnm034(imread('DBegen/db1_11.jpg'));

%Main function
function id = tnm034(img)
    % Saved mat files of 450 images - 100 best eigen vecstors are chosen
    avgFace = load('avgFace.mat').avgFace; 
    bestEigVecs = load('bestEigVecs.mat').bestEigVecs; 
    trainWeights = load('trainWeights.mat').trainWeights; 

    numberOfFaces = 450; % 450 for whole database
    numberOfPersons = 5; % Not used for Eigen
    
    % Train with fisher faces
    %[trainWeights, avgFace, bestEigVecs] = trainFisherFaces(numberOfFaces, numberOfPersons);
    
    % Train with eigen faces
    %[trainWeights, avgFace, bestEigVecs] = trainDb(numberOfFaces, numberOfPersons);
    
    % Save mat files
    %save('trainWeights.mat', 'trainWeights')
    %save('avgFace.mat', 'avgFace')
    %save('bestEigVecs.mat', 'bestEigVecs')

    originalImg = img;
    processedImg = imgProcess(originalImg); % Illumination and color normalization.
    detectedFace = faceDetect(processedImg); % Rotation, scale, normalization etc.

    id = faceRecognition(detectedFace, trainWeights, avgFace, bestEigVecs, numberOfFaces, numberOfPersons) % Match features with db
end