%Train with database
function [trainWeights, avgFace, bestEigVecs] = trainDb(maxNumberOfFaces, numberOfPersons)
    numberOfFaces = 0;

    baseVectors = zeros(85800, numberOfFaces);
    for i=1:maxNumberOfFaces
        originalImg = imread(sprintf('DB4/image_%04d.jpg', i)); %DB3/image_%04d.jpg DB1/db1_%02d.jpg
        processedImg = imgProcess(originalImg);
        [detectedFace, faceFound] = faceDetect(processedImg);
        id = im2double(detectedFace);
        
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
    numberOfFaces

    avgFace = (1.0/numberOfFaces)*sum(baseVectors, 2);
    faceVariations = baseVectors - avgFace;

    C = faceVariations' * faceVariations;

    [eigVec, ~] = eig(C);
    numOfBestEig = numberOfFaces - 100

    bestEigVecs = faceVariations * eigVec;
    bestEigVecs = normc(bestEigVecs);
    bestEigVecs = bestEigVecs(:, numOfBestEig:numberOfFaces);

    trainWeights = bestEigVecs' * faceVariations;
end