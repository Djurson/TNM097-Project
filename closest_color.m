function idx = closest_color(lab, paletteLab)
    % Finds the closest color between a color and a color palette
    dE2 = sum((paletteLab - lab) .^ 2, 2);
    [~, idx] = min(dE2);
end