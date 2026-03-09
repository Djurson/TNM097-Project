function [vx, vy, qTail] = push_subdivided(vx, vy, qTail, tvx, tvy)
    m = @(a, b) (a + b) / 2;
    m12x = m(tvx(1), tvx(2)); m12y = m(tvy(1), tvy(2));
    m23x = m(tvx(2), tvx(3)); m23y = m(tvy(2), tvy(3));
    m31x = m(tvx(3), tvx(1)); m31y = m(tvy(3), tvy(1));

    vx(qTail:qTail+3, :) = [tvx(1), m12x, m31x;
                             tvx(2), m23x, m12x;
                             tvx(3), m31x, m23x;
                             m12x,   m23x, m31x];
    vy(qTail:qTail+3, :) = [tvy(1), m12y, m31y;
                             tvy(2), m23y, m12y;
                             tvy(3), m31y, m23y;
                             m12y,   m23y, m31y];
    qTail = qTail + 4;
end
