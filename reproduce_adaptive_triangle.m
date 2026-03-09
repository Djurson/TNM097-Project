function [outRGB, idxMap] = reproduce_adaptive_triangle(Ilab, paletteLab, maxSize, minSize, detailThreshold, coverage_ratio)
    [height, width, ~] = size(Ilab);
    outRGB  = zeros(height, width, 3);
    idxMap  = zeros(height, width);
    paletteRGB = lab2rgb(paletteLab);
    L_channel  = Ilab(:,:,1);

    darkPaletteRGB = paletteRGB * coverage_ratio;
    darkPaletteLab = rgb2lab(darkPaletteRGB);

    triangles = build_initial_grid(maxSize, height, width);
    triangles = subdivide(triangles, L_channel, maxSize, minSize, detailThreshold);

    [outRGB, idxMap] = render(triangles, Ilab, darkPaletteLab, paletteRGB, outRGB, idxMap, height, width);

    outRGB = min(max(outRGB, 0), 1);
end