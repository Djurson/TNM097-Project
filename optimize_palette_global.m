function [selectedPaletteLab, optPaletteSwatch] = optimize_palette_global(fullPaletteLab, numColorsWanted)
    N = size(fullPaletteLab, 1);
    numColorsWanted = min(numColorsWanted, N);

    % Selection index map of colors from fullPaletteLab
    selectedIdx = zeros(numColorsWanted, 1);

    % Calculate the center of the color space
    center = mean(fullPaletteLab, 1);
    d2center = sum((fullPaletteLab - center).^2, 2);
    [~, selectedIdx(1)] = min(d2center);

    % Initialize the minimum distance array
    minDist2 = inf(N, 1);

    % Farthest Point Sampling
    for k = 2:numColorsWanted
        lastColor = fullPaletteLab(selectedIdx(k-1), :);
        d2 = sum((fullPaletteLab - lastColor).^2, 2);
        minDist2 = min(minDist2, d2);

        [~, nextIdx] = max(minDist2);
        selectedIdx(k) = nextIdx;
    end

    % Create the swatch
    selectedPaletteLab = fullPaletteLab(selectedIdx, :);
    selectedPaletteRGB = lab2rgb(selectedPaletteLab);
    
    cols = floor(sqrt(numColorsWanted));
    while mod(numColorsWanted, cols) ~= 0
        cols = cols - 1;
    end
    rows = numColorsWanted / cols;

    swatch = reshape(selectedPaletteRGB, [rows, cols, 3]);

    optPaletteSwatch = repelem(swatch, 15, 15);
end