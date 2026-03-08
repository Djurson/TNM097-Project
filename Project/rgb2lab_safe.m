
function Lab = rgb2lab_safe(RGB)
% Fallback om rgb2lab (Image Processing Toolbox) saknas.
if exist('rgb2lab','file') == 2
    Lab = rgb2lab(RGB);
    return;
end

RGB = im2double_safe(RGB);
RGB = srgb2linear(RGB);

M = [0.4124564 0.3575761 0.1804375;
     0.2126729 0.7151522 0.0721750;
     0.0193339 0.1191920 0.9503041];

isNx3 = ismatrix(RGB) && size(RGB,2)==3 && ndims(RGB)==2;
if isNx3
    XYZ = RGB * M.';
else
    XYZ = reshape(RGB,[],3) * M.';
end

Xn = 0.95047; Yn = 1.00000; Zn = 1.08883;
x = XYZ(:,1)/Xn; y = XYZ(:,2)/Yn; z = XYZ(:,3)/Zn;

f = @(t) ((t > (6/29)^3).*t.^(1/3) + (t <= (6/29)^3).*(t/(3*(6/29)^2) + 4/29));
fx = f(x); fy = f(y); fz = f(z);

L = 116*fy - 16;
a = 500*(fx - fy);
b = 200*(fy - fz);

LabN = [L a b];
if isNx3
    Lab = LabN;
else
    Lab = reshape(LabN, size(RGB,1), size(RGB,2), 3);
end
end

function lin = srgb2linear(s)
a = 0.055;
lin = zeros(size(s));
mask = s <= 0.04045;
lin(mask) = s(mask) / 12.92;
lin(~mask) = ((s(~mask) + a) / (1+a)).^2.4;
end
