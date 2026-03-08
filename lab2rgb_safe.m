
function RGB = lab2rgb_safe(Lab)
% Fallback om lab2rgb (Image Processing Toolbox) saknas.
if exist('lab2rgb','file') == 2
    RGB = lab2rgb(Lab);
    return;
end

isNx3 = ismatrix(Lab) && size(Lab,2)==3 && ndims(Lab)==2;
if isNx3
    L = Lab(:,1); a = Lab(:,2); b = Lab(:,3);
else
    L = Lab(:,:,1); a = Lab(:,:,2); b = Lab(:,:,3);
    L = L(:); a = a(:); b = b(:);
end

fy = (L + 16)/116;
fx = fy + a/500;
fz = fy - b/200;

finv = @(t) ((t > 6/29).*t.^3 + (t <= 6/29).*(3*(6/29)^2*(t - 4/29)));
x = finv(fx); y = finv(fy); z = finv(fz);

Xn = 0.95047; Yn = 1.00000; Zn = 1.08883;
X = x*Xn; Y = y*Yn; Z = z*Zn;

Minv = [ 3.2404542 -1.5371385 -0.4985314;
        -0.9692660  1.8760108  0.0415560;
         0.0556434 -0.2040259  1.0572252];

RGBlin = [X Y Z] * Minv.';
RGB = linear2srgb(RGBlin);
RGB = min(max(RGB,0),1);

if isNx3
    % keep Nx3
else
    sz = size(Lab);
    H = sz(1); W = sz(2);
    RGB = reshape(RGB, H, W, 3);
end
end

function s = linear2srgb(lin)
a = 0.055;
s = zeros(size(lin));
mask = lin <= 0.0031308;
s(mask) = 12.92 * lin(mask);
s(~mask) = (1+a)*lin(~mask).^(1/2.4) - a;
end
