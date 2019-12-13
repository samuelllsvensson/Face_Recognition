function [trainWeights, avgFace, bestEigVecs] = trainFisherFaces(numberOfFaces, numberOfPersons)
%Use the (numOfFaces/numOfPersons) when evaluating the smallest distance
%from the input image
numOfFaces = numberOfFaces;
numOfPersons = numberOfPersons;
numOfImgPerPerson = numOfFaces / numOfPersons;

baseVectors = zeros(85800, numOfFaces);

for i=1:numOfFaces
  originalImg = imread(sprintf('DB3/image_%04d.jpg', i));
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

meanVec = zeros(85800, numOfPersons);
totalMean = zeros(85800, 1);

for i = 1:numOfPersons
    meanVec(:,i) = (1.0/numOfImgPerPerson)*sum(baseVectors(:,1 + (i-1) * numOfImgPerPerson:i * numOfImgPerPerson), 2);
end

totalMean(:,1) = (1.0/numOfPersons)*sum(meanVec(:,1:numOfPersons),2);

covBetween = (1.0/numOfPersons)*sum(transpose(meanVec(:,1:numOfPersons)-totalMean(:,1))*(meanVec(:,1:numOfPersons)-totalMean(:,1)), 2);
covWithin = zeros(numOfPersons,1);

for i = 1:numOfPersons
    w = baseVectors(:,1 + (i-1) * numOfImgPerPerson:i * numOfImgPerPerson) - meanVec(:,1);
    help = (1.0/numOfImgPerPerson)*sum(w' * w, 2);
    covWithin(i,1) = help(1,1);
end

[eigVecW, ~] = eig(covBetween*covWithin');
eigVecW = real(eigVecW);

avgFace = totalMean;
faceVariations = meanVec - avgFace;

bestEigVecs = faceVariations * eigVecW;
bestEigVecs = normc(bestEigVecs);

trainWeights = bestEigVecs' * faceVariations;

end

