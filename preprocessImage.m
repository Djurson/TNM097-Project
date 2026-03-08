function preProcessedImg = preprocessImage(img, minW, maxW, Wout)

figure;
imshow(img);
title('Original Image');

% Rescale image
[~,width,~] = size(img);
if width > maxW
    img = imresize(img, maxW/width);
elseif width < minW
    warning("Image enlarged – quality may decrease");
    img = imresize(img, minW/width);
end

% Set final output width
[height,width,~] = size(img);
if width ~= Wout
    newH = round(height * (Wout / width));
    img = imresize(img, [newH Wout]);
end

preProcessedImg = img;

figure;
imshow(preProcessedImg);
title("Preprocessed Img");

end