function id = faceRecognition(img, trainWeights, avgFace, bestEigVecs)
    testId = im2double(img);
    testBaseVector = testId(:);

    testFaceVariation = testBaseVector - avgFace;

    testWeight = bestEigVecs' * testFaceVariation;

    smallestDistance = 10000000000;
    smallestI = -1;
    
    numberOfFaces = 16;

    for i=1:numberOfFaces
        distance = norm(testWeight-trainWeights(:, i));
        if (distance<smallestDistance)
            smallestDistance = distance;
            smallestI = i;
        end
    end
    
    id = smallestI;
end