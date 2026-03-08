
function J = imresize_safe(I, arg)
% imresize_safe: använder imresize om det finns, annars interp2-resize.
% arg kan vara skalfaktor (scalar) eller [newH newW].

if exist('imresize','file') == 2
    if isscalar(arg)
        J = imresize(I, arg, "bicubic");
    else
        J = imresize(I, arg, "bicubic");
    end
    return;
end

I = im2double_safe(I);
[H,W,C] = size(I);

if isscalar(arg)
    newH = max(1, round(H*arg));
    newW = max(1, round(W*arg));
else
    newH = arg(1); newW = arg(2);
end

[xq,yq] = meshgrid(linspace(1,W,newW), linspace(1,H,newH));
[x,y]   = meshgrid(1:W, 1:H);

J = zeros(newH,newW,C);
for c=1:C
    J(:,:,c) = interp2(x,y,I(:,:,c),xq,yq,'linear',0);
end
J = min(max(J,0),1);
end
