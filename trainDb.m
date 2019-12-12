%Train with database
function [trainWeights, avgFace, bestEigVecs] = trainDb(maxNumberOfFaces, numberOfPersons)
    numberOfFaces = 0;

    baseVectors = zeros(85800, numberOfFaces);
    for i=1:maxNumberOfFaces
        originalImg = imread(sprintf('faces/image_%04d.jpg', i));
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

    bestEigVecs = faceVariations * eigVec;
    bestEigVecs = normc(bestEigVecs);
    bestEigVecs = bestEigVecs(:, :);

    trainWeights = bestEigVecs' * faceVariations;
end