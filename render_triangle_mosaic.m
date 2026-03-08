
function [outRGB, idxMap] = render_triangle_mosaic(Ilab, paletteLab, side)
[H,W,~] = size(Ilab);
outRGB = zeros(H,W,3);
idxMap = zeros(H,W);

h  = side*sqrt(3)/2;
dx = side/2;
nY = ceil(H/h);
nX = ceil(W/dx);

paletteRGB = lab2rgb(paletteLab);

for iy = 1:nY
    y0 = (iy-1)*h;
    for ix = 1:nX
        x0 = (ix-1)*dx;

        up = mod(ix+iy,2)==0;
        % Triangel-vertices
        vx = [x0, x0+side/2, x0+side] + 1;
        if up
            vy = [y0+h, y0, y0+h] + 1;
        else
            vy = [y0, y0+h, y0] + 1;
        end

        % Centroid (medel av hörn)
        cx = round(mean(vx));
        cy = round(mean(vy));

        if cx < 1 || cx > W || cy < 1 || cy > H
            continue;
        end

        lab = squeeze(Ilab(cy,cx,:))';  % 1x3

        dL = paletteLab(:,1) - lab(1);
        da = paletteLab(:,2) - lab(2);
        db = paletteLab(:,3) - lab(3);
        dE2 = dL.^2 + da.^2 + db.^2;
        [~, idx] = min(dE2);

        % Rita triangeln genom att fylla en bounding box och testa barycentriskt
        xmin = max(1, floor(min(vx))); xmax = min(W, ceil(max(vx)));
        ymin = max(1, floor(min(vy))); ymax = min(H, ceil(max(vy)));

        [Xg,Yg] = meshgrid(xmin:xmax, ymin:ymax);
        mask = pointInTri(Xg, Yg, vx, vy);

        for c = 1:3
            tmp = outRGB(ymin:ymax, xmin:xmax, c);
            tmp(mask) = paletteRGB(idx,c);
            outRGB(ymin:ymax, xmin:xmax, c) = tmp;
        end
        tmpI = idxMap(ymin:ymax, xmin:xmax);
        tmpI(mask) = idx;
        idxMap(ymin:ymax, xmin:xmax) = tmpI;
    end
end

outRGB = min(max(outRGB,0),1);
end

function inside = pointInTri(X, Y, vx, vy)
% Barycentrisk point-in-triangle test (snabb, ingen toolbox)
x1=vx(1); y1=vy(1);
x2=vx(2); y2=vy(2);
x3=vx(3); y3=vy(3);

den = (y2 - y3).*(x1 - x3) + (x3 - x2).*(y1 - y3);
a = ((y2 - y3).*(X - x3) + (x3 - x2).*(Y - y3)) ./ den;
b = ((y3 - y1).*(X - x3) + (x1 - x3).*(Y - y3)) ./ den;
c = 1 - a - b;

inside = (a >= 0) & (b >= 0) & (c >= 0);
end
