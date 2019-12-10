%Return final face image
function [face, faceFound] = faceDetect(img)
    % Get face mask
    faceMask = getFaceMask(img);
    
    % Get eye and mouth map
    imgEye = getEyeMap(faceMask, img);
    [imgMouth, mouthX, mouthY] = getMouthMap(faceMask);
    
    % Get eye-mouth triangle
    [imgEye, faceFound] = getCandidates(imgEye, mouthX, mouthY);

    face = imgEye|imgMouth;
    
    props = regionprops(face,'centroid');
    centroids = cat(1,props.Centroid);
    [m,~] = size(centroids);
    
    if faceFound == false || m < 3
        return
    end
    
    % Align face
    [angle, dx, dy, leftEye, rightEye, mouth] = faceAlignment(face);
    
    % Size of cropped image
    xSize = (rightEye(1)-leftEye(1))+200;
    ySize = (mouth(2)-rightEye(2))+100;
    
    % Normalize mask
    normMask = imrotate(face, angle);
    normMask = imtranslate(normMask,[dx,dy]);
    targetSize = [floor(xSize) floor(ySize)];
  
    if size(normMask) > abs(targetSize)
        r = centerCropWindow2d(size(normMask),abs(targetSize));
    else
        faceFound = false;
        return
    end
    
    %normMask = imcrop(normMask,r);
   
    % Normalize face
    normFace = imrotate(img, angle);
    normFace = imtranslate(normFace,[dx,dy]);
    normFace = rgb2gray(normFace);
    normFace = imcrop(normFace,r);
    normFace = imresize(normFace, [330 260]);
        
%     % Get normalized face eye and mouth
%     props = regionprops(normMask,'centroid');
%     centroids = cat(1,props.Centroid);
%     normLeftEye = centroids(1,:);
%     normRightEye = centroids(3,:);
%     normMouth = centroids(2,:);
%     
%     % Create markers
%     pos = [normLeftEye; normRightEye; normMouth];
%     color = {'red','red','red'};
%     markedFace = insertMarker(normFace,pos,'x','color',color,'size',12);
%    
%     % Plot normalized face
%     figure;
%     subplot(1,5,1)
%     imshow(img);
%     title('Original');
%     
%     subplot(1,5,2)
%     imshow(eyeMouthImg);
%     title('Before candidates');
%     
%     subplot(1,5,3)
%     imshow(face);
%     title('After candidates');
%     
%     subplot(1,5,4)
%     imshow(normMask);
%     title('After Alignment');
%     
%     subplot(1,5,5)
%     imshow(markedFace);
%     title('Normalized face');

    face = normFace;
end