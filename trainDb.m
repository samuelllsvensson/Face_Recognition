%Train with database
function [trainWeights, avgFace, bestEigVecs] = trainDb()
    numberOfFaces = 16;

    baseVectors = zeros(85800, numberOfFaces);

    for i=1:16
        originalImg = imread(sprintf('DB1/db1_%02d.jpg', i));
        processedImg = imgProcess(originalImg);
        detectedFace = faceDetect(processedImg);
        id = im2double(detectedFace);
        baseVectors(:, i) = id(:);
    end

    avgFace = (1.0/numberOfFaces)*sum(baseVectors, 2);
    faceVariations = baseVectors - avgFace;

    C = faceVariations' * faceVariations;

    [eigVec, ~] = eig(C);

    bestEigVecs = faceVariations * eigVec;
    bestEigVecs = normc(bestEigVecs);
    bestEigVecs = bestEigVecs(:, 6:numberOfFaces);

    trainWeights = bestEigVecs' * faceVariations;
end