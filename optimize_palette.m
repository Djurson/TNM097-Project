function [optimizedPaletteLab, optPaletteSwatch] = optimize_palette(Ilab, fullPaletteLab, numOptimizedColors, sampleQuantity)
    % Flatten the image into a list of pixels
    [height, width, ~] = size(Ilab);
    pixelsLab = reshape(Ilab, height*width, 3);

    % To speed up the calculation, we randomly sample 50,000 pixels
    numPixels = height * width;
    if numPixels > sampleQuantity 
        idx = randperm(numPixels, sampleQuantity); 
        pixelsLab = pixelsLab(idx, :);
    end

    numSamples = size(pixelsLab, 1);
    numPalette = size(fullPaletteLab, 1);
    matchedIndices = zeros(numSamples, 1);

    % For each sampled pixel, find the closest bead in the full database
    for i = 1:numSamples
        matchedIndices(i) = closest_color(pixelsLab(i,:), fullPaletteLab);
    end

    % Count how many pixels snapped to each bead in the palette
    counts = histcounts(matchedIndices, 0.5:(numPalette+0.5));

    % Sort the palette colors by their usage frequency (descending)
    [~, sortedIndices] = sort(counts, 'descend');

    % Select the top 'numOptimizedColors' indices
    % (We use min() just in case the image uses fewer colors than requested)
    k = min(numOptimizedColors, sum(counts > 0));
    topIndices = sortedIndices(1:k);

    % Create the final optimized palette
    optimizedPaletteLab = fullPaletteLab(topIndices, :);

    % Create swatch for visualization
    optPaletteRGB = lab2rgb(optimizedPaletteLab);

    swatch = reshape(optPaletteRGB, 1, [], 3);
    optPaletteSwatch = repmat(swatch, 50, 1, 1);
end