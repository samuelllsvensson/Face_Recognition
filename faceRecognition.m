function id = faceRecognition(img, trainWeights, avgFace, bestEigVecs, numberOfFaces, numberOfPersons)
    testId = im2double(img);
    testBaseVector = testId(:);

    testFaceVariation = testBaseVector - avgFace;

    testWeight = bestEigVecs' * testFaceVariation;

    smallestDistance = 10000000000;
    smallestI = -1;

    for i=1:numberOfFaces % i=1:numberOfFaces for eigen faces, 1:numberOfPeople for fisher
        distance = norm(testWeight-trainWeights(:, i));
        if (distance<smallestDistance)
            smallestDistance = distance;
            smallestI = i;
        end
    end
    
    id = smallestI;
end