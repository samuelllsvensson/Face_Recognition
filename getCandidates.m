function image = getCandidates(img)
    props = regionprops(img,'centroid', 'PixelIdxList');
    centroids = cat(1,props.Centroid);
    [m,n] = size(centroids);
    
    candidateArr = [1,2,3]; % Array with most likely candidates
    bestAngle1 = 100000.0;
    bestAngle2 = 100000.0;
    critAngle = 1.2; % Angle to aim for
  
    % Go through list of blobs and update the most likely candidates
    % O(m^3)?
    for i = 1:m
        for j = i+1:m
            for k = j+1:m
                % Blobs
                eye1 = [centroids(i,:),0];
                mouth = [centroids(j,:),0];
                eye2 = [centroids(k,:),0];
                
                % Vectors
                vector1 = eye2-eye1;
                vector2 = mouth-eye1;
                vector3 = mouth-eye2;
                
                % Limits for mouth
                minX = eye1(1);
                maxX = eye2(1);
                
                % Angles 
                angle1 = acos((dot(vector1, vector2)/dot(norm(vector1), norm(vector2)))); % Angle at eye 1
                angle2 = acos((dot(-vector1, vector3)/dot(norm(vector1), norm(vector3)))); % Angle at eye 2
                
                % If conditions for face triangle are met - reassign new
                % best candidates
                if  (eye2(2) > eye1(2)*0.9 && eye2(2) < eye1(2)*1.1 && ...
                         mouth(1) > minX && mouth(1) < maxX && abs(angle1-critAngle) <= bestAngle1 && abs(angle2-critAngle) <= bestAngle2)
 
                    bestAngle1 = abs(angle1-critAngle);
                    bestAngle2 = abs(angle2-critAngle);
                    candidateArr = [i,j,k];
                end
            end
        end
    end

    % Clear blobs that are not eyes and mouth
    % O(m*n)
    for i = 1:m
        isCandidate = false;
        for j = 1:length(candidateArr)
            if candidateArr(j)==i % Check if blob is best candidate
                isCandidate = true;
                break;
            end
        end
        if isCandidate == false
            img(props(i).PixelIdxList) = 0; % Remove blobs
        end
    end
    image = img;
end
