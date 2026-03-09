function [reducedPaletteLab, colorSwatch] = reduce_palette_global(palette100Lab, numReducedColors)
    [reducedPaletteLab, colorSwatch] = optimize_palette_global(palette100Lab, numReducedColors);
end