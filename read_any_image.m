
function I = read_any_image(imgIn)
if ischar(imgIn) || isstring(imgIn)
    I = imread(imgIn);
else
    I = imgIn;
end
if size(I,3)==1
    I = repmat(I,1,1,3);
end
end
