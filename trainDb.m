%Train with database
function [trainWeights, avgFace, bestEigVecs] = trainDb(maxNumberOfFaces, numberOfPersons)
    numberOfFaces = 0;

    baseVectors = zeros(85800, numberOfFaces);
    for i=1:maxNumberOfFaces
        originalImg = imread(sprintf('DB4/image_%04d.jpg', i));
        processedImg = imgProcess(originalImg);
        [detectedFace, faceFound] = faceDetect(processedImg);
        id = im2double(detectedFace);
        
        % Discard images of wrong dimensions and lack of eye-mouth candidates
        if size(id(:)) ~= 85800
            faceFound = false;
        end
        if ~faceFound
            baseVectors(:, i) = zeros(85800,1);
        else        
            baseVectors(:, i) = id(:);
            numberOfFaces = numberOfFaces + 1;
        end
    end

    avgFace = (1.0/numberOfFaces)*sum(baseVectors, 2);
    faceVariations = baseVectors - avgFace;

    C = faceVariations' * faceVariations;

    [eigVec, ~] = eig(C);
    numOfWantedEig = 293;
    numOfBestEig = numberOfFaces - numOfWantedEig;

    bestEigVecs = faceVariations * eigVec;
    bestEigVecs = normc(bestEigVecs);
    bestEigVecs = bestEigVecs(:, numOfBestEig:numberOfFaces); % Choose number of faces to use

    trainWeights = bestEigVecs' * faceVariations;
end