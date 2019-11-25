function image = ruleRefinements(img)
    props = regionprops(img, 'Solidity', 'BoundingBox', 'Orientation', 'Extrema', 'PixelIdxList');
    
    for i = 1:length(props)
        height = double(props(i).BoundingBox(4));
        width = double(props(i).BoundingBox(3));
        aspectRatio = width/height;
        
        solidity = props(i).Solidity;
        orientation = props(i).Orientation;
       
        % Remove blobs that does not satisfy any of the rules
        if solidity <= 0.5 && (aspectRatio < 0.8 || aspectRatio > 4.0) && (orientation < -45 || orientation > 45)
            pixelIndices = props(i).PixelIdxList;
            img(pixelIndices) = 0;
        end
    end
    
    img = imclearborder(img); % Remove all blobs that connect to the image border

    image = img;
end

