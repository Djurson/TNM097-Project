
function paletteLab = make_global_palette_fps(N, poolSize, seed)
% Global palett som täcker färgrymden (greedy farthest-point sampling) i Lab.

rng(seed);
RGB = rand(poolSize,3);
LAB = rgb2lab(RGB);

% Start: slumpad punkt
paletteLab = LAB(randi(poolSize),:);

% Håll minsta kvadrerade avståndet till nuvarande palett för varje punkt
minD2 = lab_min_dist2(LAB, paletteLab(1,:));

for k = 2:N
    % välj punkten som maximerar minsta avståndet
    [~, i] = max(minD2);
    paletteLab = [paletteLab; LAB(i,:)]; %#ok<AGROW>

    % uppdatera minD2 med avstånd till den nya punkten
    d2new = lab_min_dist2(LAB, paletteLab(end,:));
    minD2 = min(minD2, d2new);
end
end

function d2 = lab_min_dist2(LAB, p)
dL = LAB(:,1) - p(1);
da = LAB(:,2) - p(2);
db = LAB(:,3) - p(3);
d2 = dL.^2 + da.^2 + db.^2;
end
