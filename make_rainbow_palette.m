function [paletteLab, paletteImage] = make_rainbow_palette(numColors, numShades)
    % Generates a grid of colors (numShades x numColors)
    % Columns (x-axis) change the hue (rainbow)
    % Rows (y-axis) change the shade (light at top, dark at bottom)

    % 1. Create Hue grid (0 to almost 1 to cover the rainbow without repeating red)
    hues = linspace(0, 1 - 1/numColors, numColors);
    H = repmat(hues, numShades, 1);

    % 2. Create Saturation and Value (Brightness) grids
    % y goes from 0 (top) to 1 (bottom)
    y = linspace(0, 1, numShades)';
    
    % Top half: vary Saturation from 0 (white/light) to 1 (pure color)
    % Bottom half: Saturation stays at 1
    S = repmat(1 - (2*y - 1).^2, 1, numColors);
    % S = repmat(min(1, 2 * y), 1, numColors);
    
    % Top half: Value stays at 1
    % Bottom half: vary Value from 1 (pure color) to 0 (black/dark)
    V = repmat(min(1, 2 * (1 - y)), 1, numColors);

    % 3. Combine into an HSV image and convert to RGB
    HSV = cat(3, H, S, V);
    paletteImage = hsv2rgb(HSV); % This is an RGB image we can visualize

    % 4. Flatten the 2D image into a list of RGB colors (N x 3)
    rgbList = reshape(paletteImage, [], 3);

    % 5. Convert to LAB for the mosaic rendering
    paletteLab = rgb2lab(rgbList);
end