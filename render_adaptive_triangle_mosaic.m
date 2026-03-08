function [outRGB, idxMap] = render_adaptive_triangle_mosaic(Ilab, paletteLab, maxSize, minSize, detailThreshold)
    % Adaptive triangle mosaic using subdivision based on local luminance detail.
    
    [height, width, ~] = size(Ilab);
    outRGB = zeros(height, width, 3);
    idxMap = zeros(height, width);
    
    paletteRGB = lab2rgb(paletteLab);

    % Extract the L channel (lightness) to measure image detail/contrast
    L_channel = Ilab(:,:,1);

    % --- 1. Generate the initial coarse grid of large triangles ---
    h = maxSize * sqrt(3) / 2;
    dx = maxSize / 2;
    nY = ceil(height / h);
    nX = ceil(width / dx);
    
    % Pre-allocate queues for performance (avoids slow dynamic array resizing in MATLAB loops)
    maxQueue = 500000; 
    queue_vx = zeros(maxQueue, 3);
    queue_vy = zeros(maxQueue, 3);
    qHead = 1; 
    qTail = 1;
    
    for iy = 1:nY
        y0 = (iy - 1) * h;
        for ix = 1:nX
            x0 = (ix - 1) * dx;
            up = mod(ix + iy, 2) == 0;
            
            vx = [x0, x0 + dx, x0 + maxSize] + 1;
            if up
                vy = [y0 + h, y0, y0 + h] + 1;
            else
                vy = [y0, y0 + h, y0] + 1;
            end
            
            queue_vx(qTail, :) = vx;
            queue_vy(qTail, :) = vy;
            qTail = qTail + 1;
        end
    end

    % Pre-allocate storage for the final triangles that survive the detail test
    final_vx = zeros(maxQueue, 3);
    final_vy = zeros(maxQueue, 3);
    finalCount = 0;

    % --- 2. Process triangles and subdivide based on frequency content ---
    while qHead < qTail
        % Pop the next triangle from the queue
        vx = queue_vx(qHead, :);
        vy = queue_vy(qHead, :);
        qHead = qHead + 1;
        
        % Bounding box to analyze the underlying image patch
        xmin = max(1, floor(min(vx))); xmax = min(width, ceil(max(vx)));
        ymin = max(1, floor(min(vy))); ymax = min(height, ceil(max(vy)));
        
        % Measure local detail using the Lightness range within the bounding box
        % High range = high frequency/detail (edges). Low range = smooth color (sky).
        patch = L_channel(ymin:ymax, xmin:xmax);
        detailLevel = max(patch(:)) - min(patch(:));
        
        currentSide = vx(3) - vx(1); % Approximate side length based on x-coordinates
        
        % Subdivision condition: High detail AND we haven't reached the minimum triangle size
        if detailLevel > detailThreshold && currentSide > minSize * 1.1
            % Calculate midpoints of the 3 edges to form 4 new sub-triangles
            m12x = (vx(1) + vx(2)) / 2; m12y = (vy(1) + vy(2)) / 2;
            m23x = (vx(2) + vx(3)) / 2; m23y = (vy(2) + vy(3)) / 2;
            m31x = (vx(3) + vx(1)) / 2; m31y = (vy(3) + vy(1)) / 2;
            
            % Push the 4 new sub-triangles to the end of the queue
            queue_vx(qTail:qTail+3, :) = [
                vx(1), m12x, m31x;
                vx(2), m23x, m12x;
                vx(3), m31x, m23x;
                m12x, m23x, m31x % The center inverted triangle
            ];
            queue_vy(qTail:qTail+3, :) = [
                vy(1), m12y, m31y;
                vy(2), m23y, m12y;
                vy(3), m31y, m23y;
                m12y, m23y, m31y
            ];
            qTail = qTail + 4;
        else
            % If detail is low or triangle is minimal, save it for final rendering
            finalCount = finalCount + 1;
            final_vx(finalCount, :) = vx;
            final_vy(finalCount, :) = vy;
        end
    end

    % --- 3. Render the final adapted triangles ---
    for i = 1:finalCount
        vx = final_vx(i, :);
        vy = final_vy(i, :);
        
        cx = round(mean(vx));
        cy = round(mean(vy));
        
        if cx < 1 || cx > width || cy < 1 || cy > height
            continue;
        end
        
        % Sample the center color and find the closest palette match in CIELAB
        lab = squeeze(Ilab(cy, cx, :))'; 
        
        dL = paletteLab(:, 1) - lab(1);
        da = paletteLab(:, 2) - lab(2);
        db = paletteLab(:, 3) - lab(3);
        dE2 = dL.^2 + da.^2 + db.^2;
        [~, idx] = min(dE2);
        
        % Barycentric masking to color pixels inside the triangle
        xmin = max(1, floor(min(vx))); xmax = min(width, ceil(max(vx)));
        ymin = max(1, floor(min(vy))); ymax = min(height, ceil(max(vy)));
        
        [Xg, Yg] = meshgrid(xmin:xmax, ymin:ymax);
        mask = pointInTri(Xg, Yg, vx, vy);
        
        for c = 1:3
            tmp = outRGB(ymin:ymax, xmin:xmax, c);
            tmp(mask) = paletteRGB(idx, c);
            outRGB(ymin:ymax, xmin:xmax, c) = tmp;
        end
        
        tmpI = idxMap(ymin:ymax, xmin:xmax);
        tmpI(mask) = idx;
        idxMap(ymin:ymax, xmin:xmax) = tmpI;
    end
    
    outRGB = min(max(outRGB, 0), 1);
end

function inside = pointInTri(X, Y, vx, vy)
    % Barycentric coordinate test
    x1 = vx(1); y1 = vy(1);
    x2 = vx(2); y2 = vy(2);
    x3 = vx(3); y3 = vy(3);
    
    den = (y2 - y3).*(x1 - x3) + (x3 - x2).*(y1 - y3);
    a = ((y2 - y3).*(X - x3) + (x3 - x2).*(Y - y3)) ./ den;
    b = ((y3 - y1).*(X - x3) + (x1 - x3).*(Y - y3)) ./ den;
    c = 1 - a - b;
    
    inside = (a >= 0) & (b >= 0) & (c >= 0);
end