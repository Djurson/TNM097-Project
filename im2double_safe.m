
function I = im2double_safe(I)
% im2double utan IPT
if isa(I,'double')
    return;
end
if isa(I,'uint8')
    I = double(I)/255;
elseif isa(I,'uint16')
    I = double(I)/65535;
else
    I = double(I);
    mx = max(I(:));
    if mx > 1
        I = I / mx;
    end
end
end
