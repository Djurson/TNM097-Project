function [outRGB, idxMap] = render(triangles, Ilab, searchPaletteLab, drawPaletteRGB, outRGB, idxMap, height, width)
    for i = 1:size(triangles.vx, 1)
        tvx = triangles.vx(i, :);
        tvy = triangles.vy(i, :);

        % Bounding box for the specific triangle
        xmin = max(1, floor(min(tvx))); xmax = min(width,  ceil(max(tvx)));
        ymin = max(1, floor(min(tvy))); ymax = min(height, ceil(max(tvy)));

        if xmin > xmax || ymin > ymax
            continue;
        end


        % Generates a local meshgrid for the triangle
        [Xg, Yg] = meshgrid(xmin:xmax, ymin:ymax);
        mask = point_in_tri(Xg, Yg, tvx, tvy);

        % If the triangle is to small to not cover any pixel
        if ~any(mask(:))
            continue;
        end

        % Gets the color values of the bounding box & calculates a mean
        % Color value for the box
        boxL = Ilab(ymin:ymax, xmin:xmax, 1);
        boxA = Ilab(ymin:ymax, xmin:xmax, 2);
        boxB = Ilab(ymin:ymax, xmin:xmax, 3);
        
        meanL = mean(boxL(mask));
        meanA = mean(boxA(mask));
        meanB = mean(boxB(mask));

        meanColor = [meanL, meanA, meanB];

        % Finds the closest color to the mean color in the color palette
        idx = closest_color(meanColor, searchPaletteLab);

        % Applies the color that is the closest to the out pixels
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