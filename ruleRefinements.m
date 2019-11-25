function image = ruleRefinements(img)
    props = regionprops(img, 'Solidity', 'BoundingBox', 'Orientation', 'PixelIdxList');
    
    for i = 1:length(props)
        height = props(i).BoundingBox(4);
        width = props(i).BoundingBox(3);
        if props(i).Solidity <= 0.5 && (height/width < 0.8 || height/width > 4.0) && (props(i).Orientation < -45 || props(i).Orientation > 45)
            pixelIndices = props(i).PixelIdxList;
            img(pixelIndices) = 0;
        end
    end

    image = img;
end

