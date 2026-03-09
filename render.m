function [outRGB, idxMap] = render(triangles, Ilab, searchPaletteLab, drawPaletteRGB, outRGB, idxMap, height, width)
    for i = 1:size(triangles.vx, 1)
        tvx = triangles.vx(i, :);
        tvy = triangles.vy(i, :);

        xmin = max(1, floor(min(tvx))); xmax = min(width,  ceil(max(tvx)));
        ymin = max(1, floor(min(tvy))); ymax = min(height, ceil(max(tvy)));

        if xmin > xmax || ymin > ymax
            continue;
        end

        [Xg, Yg] = meshgrid(xmin:xmax, ymin:ymax);
        mask = point_in_tri(Xg, Yg, tvx, tvy);

        % If the triangle is to small to not cover any pixel
        if ~any(mask(:))
            continue;
        end

        boxL = Ilab(ymin:ymax, xmin:xmax, 1);
        boxA = Ilab(ymin:ymax, xmin:xmax, 2);
        boxB = Ilab(ymin:ymax, xmin:xmax, 3);
        
        meanL = mean(boxL(mask));
        meanA = mean(boxA(mask));
        meanB = mean(boxB(mask));
        meanColor = [meanL, meanA, meanB];

        idx = closest_color(meanColor, searchPaletteLab);

        for c = 1:3
            tmp = outRGB(ymin:ymax, xmin:xmax, c);
            tmp(mask) = drawPaletteRGB(idx, c);
            outRGB(ymin:ymax, xmin:xmax, c) = tmp;
        end
        tmp = idxMap(ymin:ymax, xmin:xmax);
        tmp(mask) = idx;
        idxMap(ymin:ymax, xmin:xmax) = tmp;
    end
end