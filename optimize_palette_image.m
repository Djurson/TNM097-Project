function [optimizedPaletteLab, optPaletteSwatch] = optimize_palette_image(Ilab, fullPaletteLab, numOptimizedColors, coverage_ratio)
    % Take out sample pixels
    sampleQuantity = 50000;

    [height, width, ~] = size(Ilab);
    pixelsLab = reshape(Ilab, height*width, 3);

    numPixels = height * width;
    if numPixels > sampleQuantity 
        idx = randperm(numPixels, sampleQuantity); 
        pixelsLab = pixelsLab(idx, :);
    end
    %

    % If there was any gap / background color
    fullPaletteRGB = lab2rgb(fullPaletteLab);
    
    darkPaletteRGB = fullPaletteRGB * coverage_ratio;
    darkPaletteLab = rgb2lab(darkPaletteRGB);

    % K means to extract most dominant colors
    [~, centroidsLab] = kmeans(pixelsLab, numOptimizedColors, 'MaxIter', 200, 'EmptyAction', 'drop');
    matchedIndices = knnsearch(darkPaletteLab, centroidsLab);
    unique_idx = unique(matchedIndices);

    optimizedPaletteLab = fullPaletteLab(unique_idx, :);

    % Create color swatch
    optPaletteRGB = lab2rgb(optimizedPaletteLab);
    actualNumColors = size(optimizedPaletteLab, 1);

    cols = floor(sqrt(actualNumColors));
    while mod(actualNumColors, cols) ~= 0
        cols = cols - 1;
    end
    rows = actualNumColors / cols;

    swatch = reshape(optPaletteRGB, [rows, cols, 3]);

    optPaletteSwatch = repelem(swatch, 15, 15);
end