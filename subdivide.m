function triangles = subdivide(triangles, L_channel, maxSize, minSize, detailThreshold)
    [imgHeight, imgWidth] = size(L_channel);
    maxQueue = 500000;
    vx = [triangles.vx; zeros(maxQueue, 3)];
    vy = [triangles.vy; zeros(maxQueue, 3)];
    qHead = 1;
    qTail = size(triangles.vx, 1) + 1;

    final_vx = zeros(maxQueue, 3);
    final_vy = zeros(maxQueue, 3);
    finalCount = 0;

    while qHead < qTail
        tvx = vx(qHead, :);
        tvy = vy(qHead, :);
        qHead = qHead + 1;

        xmin = max(1, floor(min(tvx))); xmax = min(imgWidth, ceil(max(tvx)));
        ymin = max(1, floor(min(tvy))); ymax = min(imgHeight, ceil(max(tvy)));

        if xmin > xmax || ymin > ymax
            detail = 0;
        else
            patch  = L_channel(ymin:ymax, xmin:xmax);
            detail = max(patch(:)) - min(patch(:));
        end

        sideLen = tvx(3) - tvx(1);
        if detail > detailThreshold && sideLen > minSize * 1.1
            [vx, vy, qTail] = push_subdivided(vx, vy, qTail, tvx, tvy);
        else
            finalCount = finalCount + 1;
            final_vx(finalCount, :) = tvx;
            final_vy(finalCount, :) = tvy;
        end
    end

    triangles = struct('vx', final_vx(1:finalCount,:), 'vy', final_vy(1:finalCount,:));
end