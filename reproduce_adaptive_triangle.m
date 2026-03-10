function [outRGB, idxMap] = reproduce_adaptive_triangle(Ilab, paletteLab, maxSize, minSize, detailThreshold, coverage_ratio)
    [height, width, ~] = size(Ilab);
    outRGB  = zeros(height, width, 3);
    idxMap  = zeros(height, width);
    paletteRGB = lab2rgb(paletteLab);
    L_channel  = Ilab(:,:,1);

    darkPaletteRGB = paletteRGB * coverage_ratio;
    darkPaletteLab = rgb2lab(darkPaletteRGB);

    % Create the base triangle grid
    triangles = build_initial_grid(maxSize, height, width);

    % Subdivide the triangle grid
    triangles = subdivide(triangles, L_channel, minSize, detailThreshold);

    figure;
    imshow(L_channel, []); % Visar svart-vita originalbilden
    hold on;
    % Ritar alla trianglar med röda linjer och genomskinlig fyllning
    patch('XData', triangles.vx', 'YData', triangles.vy', 'FaceColor', 'none', 'EdgeColor', 'r', 'LineWidth', 0.5);
    %title('Preview: Adaptive Triangle Grid');
    hold off;

    % Renders the final grid of triangles
    [outRGB, idxMap] = render(triangles, Ilab, darkPaletteLab, paletteRGB, outRGB, idxMap, height, width);

    outRGB = min(max(outRGB, 0), 1);
end