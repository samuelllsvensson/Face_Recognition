function [trainWeights, avgFace, bestEigVecs] = trainFisherFaces()
%Use the (numOfFaces/numOfPersons) when evaluating the smallest distance
%from the input image

numOfFaces = 6.0;
numOfPersons = 2.0;

baseVectors = zeros(85800, numberOfFaces);

for i=1:numOfFaces
  originalImg = imread(sprintf('DB3/db3_%02d.jpg', i));
  processedImg = imgProcess(originalImg);
  detectedFace = faceDetect(processedImg);
  id = im2double(detectedFace);
  baseVectors(:, i) = id(:);
end

meanVec = zeros(85800, 3);
totalMean = zeros(85800, 1);

meanVec(:,1) = (1.0/numOfPersons)*sum(baseVectors(:,1:2), 2);
meanVec(:,2) = (1.0/numOfPersons)*sum(baseVectors(:,3:4), 2);
meanVec(:,3) = (1.0/numOfPersons)*sum(baseVectors(:,5:6), 2);
totalMean(:,1) = (1.0/3.0)*sum(meanVec(:,1:3),2);

covBetween = (1.0/3.0)*sum(transpose(meanVec(:,1:3)-totalMean(:,1))*(meanVec(:,1:3)-totalMean(:,1)), 2);
covWithin = zeros(3,1);
w = baseVectors(:,1:2) - meanVec(:,1);
covWithin1 = (1.0/2.0)*sum(w' * w, 2);
w = baseVectors(:,3:4) - meanVec(:,1);
covWithin2 = (1.0/2.0)*sum(w' * w, 2);
w = baseVectors(:,5:6) - meanVec(:,1);
covWithin3 = (1.0/2.0)*sum(w' * w, 2);

covWithin(1,1) = covWithin1(1,1);
covWithin(2,1) = covWithin2(1,1);
covWithin(3,1) = covWithin3(1,1);

[eigVecW, ~] = eig(covBetween*covWithin');

avgFace = totalMean;
faceVariations = meanVec - avgFace;

bestEigVecs = faceVariations * eigVecW;
bestEigVecs = normc(bestEigVecs);

trainWeights = bestEigVecs' * faceVariations;

end

