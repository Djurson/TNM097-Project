function preProcessedImg = preprocessImage(img, minW, Wout)

figure;
imshow(img);
title('Original Image');

% Set final output width
[height,width,~] = size(img);
if width ~= Wout
    if width < minW
        warning("Image scaled up, quality may decrease");
    end
    newH = round(height * (Wout / width));
    img = imresize(img, [newH Wout]);
end

preProcessedImg = img;

figure;
imshow(preProcessedImg);
title("Preprocessed Img");

end