function imgRot = eyeAlignment(img)
imgMod = mat2gray(img);

%Find closest rectangle arround eyes
[row,col] = find(imgMod(:,:,1) == 1);
eyeDist = abs(max(col) - min(col));
eyeLevel = abs(max(row) - min(row));

%Crop image to the closest rectangle
se = strel('disk',10 ,8);
imgMod = imerode(imgMod,se);
imgMod = imcrop(imgMod,[min(col) min(row) eyeDist eyeLevel]);

%Find new rows
[row,~] = find(imgMod(:,:,1) == 1);

minLevel = 1000;
alpha = 1;
finalAngle = 0;

%Rotate by alpha until rectangle cant be smaller in height
if(~isempty(row))
    if(row(1) > row(length(row)))
        alpha = -1;
    end
    while(abs(max(row) - min(row)) < minLevel)
    imgMod = imrotate(imgMod, alpha);
    minLevel = abs(max(row) - min(row));
    [row,~] = find(imgMod(:,:,1) == 1);
    finalAngle = finalAngle + alpha;
    end
end

%Final rotation of the argument
imgRot = imrotate(img, finalAngle);
end
