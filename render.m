function [outRGB, idxMap] = render(triangles, Ilab, paletteLab, paletteRGB, outRGB, idxMap, height, width)
    for i = 1:size(triangles.vx, 1)
        tvx = triangles.vx(i, :);
        tvy = triangles.vy(i, :);

        cx = round(mean(tvx));
        cy = round(mean(tvy));
        if cx < 1 || cx > width || cy < 1 || cy > height
            continue;
        end

        idx = closest_color(squeeze(Ilab(cy, cx, :))', paletteLab);

        xmin = max(1, floor(min(tvx))); xmax = min(width,  ceil(max(tvx)));
        ymin = max(1, floor(min(tvy))); ymax = min(height, ceil(max(tvy)));
        [Xg, Yg] = meshgrid(xmin:xmax, ymin:ymax);
        mask = point_in_tri(Xg, Yg, tvx, tvy);

        for c = 1:3
            tmp = outRGB(ymin:ymax, xmin:xmax, c);
            tmp(mask) = paletteRGB(idx, c);
            outRGB(ymin:ymax, xmin:xmax, c) = tmp;
        end
        tmp = idxMap(ymin:ymax, xmin:xmax);
        tmp(mask) = idx;
        idxMap(ymin:ymax, xmin:xmax) = tmp;
    end
end