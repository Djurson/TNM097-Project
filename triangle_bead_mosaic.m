
function out = triangle_bead_mosaic(imgIn, opts)
img = im2double(imread(imgIn));

% Preprocessing (scaling)
processedImg = preprocessImage(img, opts);
Ilab = rgb2lab(processedImg);

[paletteLab, paletteImage] = make_rainbow_palette(opts.numColors, opts.numShades);

[mosaicRGB, idxMap] = render_triangle_mosaic(Ilab, paletteLab, opts.side);

out.mosaicRGB  = mosaicRGB;
out.paletteLab = paletteLab;
out.indexMap   = idxMap;
out.paletteImage = paletteImage;
end
