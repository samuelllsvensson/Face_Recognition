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
    
    % Threshold for rejecting faces
    threshold = 20;
    
    if smallestDistance > threshold
        id = 0;
        return
    end
    
    id = smallestI;
    
    % Return correct id
    if id <= 21
        id = 1 ;
    elseif id <= 41
        id = 2;
    elseif id <= 46
        id = 0;
    elseif id <= 68
        id = 3;
    elseif id <= 89
        id = 0;
    elseif id <= 112
        id = 4;
    elseif id <= 132
        id = 0;
    elseif id <= 137
        id = 5;
    elseif id <= 158
        id = 6;
    elseif id <= 175
        id = 0;
    elseif id <= 195
        id = 7;
    elseif id <= 216
        id = 8;
    elseif id <= 241
        id = 9;
    elseif id <= 263
        id = 10;
    elseif id <= 268
        id = 0;
    elseif id <= 287
        id = 11;
    elseif id <= 336
        id = 0;
    elseif id <= 356
        id = 12;
    elseif id <= 376
        id = 13;
    elseif id <= 398
        id = 14;
    elseif id <= 403
        id = 0;
    elseif id <= 408
        id = 15;
    elseif id <= 428
        id = 16;
    else
        id = 0;
    end
end