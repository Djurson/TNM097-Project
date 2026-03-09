function triangles = build_initial_grid(maxSize, height, width)
    cellH = maxSize * sqrt(3) / 2;
    dx    = maxSize / 2;
    nCellsY = ceil(height / cellH);
    nCellsX = ceil(width  / dx);
    n = nCellsY * nCellsX;
    vx = zeros(n, 3);
    vy = zeros(n, 3);
    k  = 0;
    for iy = 1:nCellsY
        y0 = (iy - 1) * cellH;
        for ix = 1:nCellsX
            x0 = (ix - 1) * dx;
            k  = k + 1;
            up = mod(ix + iy, 2) == 0;
            vx(k, :) = [x0, x0 + dx, x0 + maxSize] + 1;
            if up
                vy(k, :) = [y0 + cellH, y0, y0 + cellH] + 1;
            else
                vy(k, :) = [y0, y0 + cellH, y0] + 1;
            end
        end
    end
    triangles = struct('vx', vx(1:k,:), 'vy', vy(1:k,:));
end