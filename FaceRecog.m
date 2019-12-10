clear;
clc;

id = tnm034(imread('DB2/bl_05.jpg'));

%Main function
function id = tnm034(img)
    [trainWeights, avgFace, bestEigVecs] = trainDb(); % Train DB 
    originalImg = img;
    processedImg = imgProcess(originalImg); % Illumination and color normalization.
    detectedFace = faceDetect(processedImg); % Rotation, scale, normalization etc.
    id = faceRecognition(detectedFace, trainWeights, avgFace, bestEigVecs); % Match features with db
end