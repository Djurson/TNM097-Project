
function out = triangle_bead_mosaic(imgIn, opts)
if nargin < 2, opts = struct(); end
opts = set_defaults(opts, ...
    "Wout", 1200, ...
    "minW", 600, "maxW", 3000, ...
    "side", 18, ...
    "paletteN", 100, ...
    "paletteMode", "global", ...
    "paletteSeed", 1, ...
    "globalPoolSize", 50000);

I = read_any_image(imgIn);
I = im2double_safe(I);

% --- scale rules ---
[H,W,~] = size(I);
if W > opts.maxW
    I = imresize_safe(I, opts.maxW/W);
elseif W < opts.minW
    warning("Image enlarged – quality may decrease");
    I = imresize_safe(I, opts.minW/W);
end

% --- set final output width ---
[H,W,~] = size(I);
if W ~= opts.Wout
    newH = round(H * (opts.Wout / W));
    I = imresize_safe(I, [newH opts.Wout]);
end

Ilab = rgb2lab_safe(I);

% --- build palette ---
switch lower(string(opts.paletteMode))
    case "global"
        paletteLab = make_global_palette_fps(opts.paletteN, opts.globalPoolSize, opts.paletteSeed);
    case "image"
        error("paletteMode='image' kräver kmeans (Statistics Toolbox). Använd 'global' på din MATLAB.");
    otherwise
        error("Unknown paletteMode: %s", string(opts.paletteMode));
end

[mosaicRGB, idxMap] = render_triangle_mosaic(Ilab, paletteLab, opts.side);

out.mosaicRGB  = mosaicRGB;
out.paletteLab = paletteLab;
out.indexMap   = idxMap;
end
