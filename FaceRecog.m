clear;
clc;
numRight = 0;
for i = 1:16
     id = tnm034(imread(sprintf('DB1/db1_%02d.jpg', i)));
    
    if id == i
        numRight = numRight + 1;
    end
end
percent = numRight/16

%Main function
function id = tnm034(img)
    % Saved mat files of 450 images - 100 best eigen vecstors are chosen
    avgFace = load('avgFace.mat').avgFace; 
    bestEigVecs = load('bestEigVecs.mat').bestEigVecs; 
    trainWeights = load('trainWeights.mat').trainWeights; 

    numberOfFaces = 450; % 450 for whole database
    numberOfPersons = 5; %Only used for fisher faces
    
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
    [detectedFace, faceFound] = faceDetect(processedImg); % Rotation, scale, normalization etc.
    
    if faceFound == false
       id = 0;
       return
    end

    id = faceRecognition(detectedFace, trainWeights, avgFace, bestEigVecs, numberOfFaces, numberOfPersons) % Match features with db
    
    % Return correct id
    if id <= 21
        id = 1 
    elseif id <= 41
        id = 2
    elseif id <= 46
        id = 0
    elseif id <= 68
        id = 3
    elseif id <= 89
        id = 0
    elseif id <= 112
        id = 4
    elseif id <= 132
        id = 0
    elseif id <= 137
        id = 5
    elseif id <= 158
        id = 6
    elseif id <= 175
        id = 0
    elseif id <= 195
        id = 7
    elseif id <= 216
        id = 8
    elseif id <= 241
        id = 9
    elseif id <= 263
        id = 10
    elseif id <= 268
        id = 0
    elseif id <= 287
        id = 11
    elseif id <= 336
        id = 0
    elseif id <= 356
        id = 12
    elseif id <= 376
        id = 13
    elseif id <= 398
        id = 14
    elseif id <= 403
        id = 0
    elseif id <= 408
        id = 15
    elseif id <= 428
        id = 16
    else
        id = 0
    end
    
end