function idx = closest_color(lab, paletteLab)
    dE2 = sum((paletteLab - lab) .^ 2, 2);
    [~, idx] = min(dE2);
end