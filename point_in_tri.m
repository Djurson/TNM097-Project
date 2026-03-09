function inside = point_in_tri(X, Y, vx, vy)
    den = (vy(2)-vy(3)).*(vx(1)-vx(3)) + (vx(3)-vx(2)).*(vy(1)-vy(3));
    a   = ((vy(2)-vy(3)).*(X-vx(3)) + (vx(3)-vx(2)).*(Y-vy(3))) ./ den;
    b   = ((vy(3)-vy(1)).*(X-vx(3)) + (vx(1)-vx(3)).*(Y-vy(3))) ./ den;
    inside = (a >= 0) & (b >= 0) & (1-a-b >= 0);
end