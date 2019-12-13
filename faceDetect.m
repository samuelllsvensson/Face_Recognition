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
    
    % Discard if eye and mouth candidates are not found
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
       
    % Normalize face
    normFace = imrotate(img, angle);
    normFace = imtranslate(normFace,[dx,dy]);
    normFace = rgb2gray(normFace);
    normFace = imcrop(normFace,r);
    normFace = imresize(normFace, [330 260]);

    face = normFace;
end