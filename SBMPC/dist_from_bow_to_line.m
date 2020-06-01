function [ dist ] = dist_from_bow_to_line( point_x, point_y, start_x, start_y, end_x, end_y )


%http://paulbourke.net/geometry/pointlineplane/ 
x3 = point_y;  % INPUT Y VALUE
y3 = point_x; %  INPUT X VALUE
x1 = start_y;  %   INPUT LINE START Y
y1 = start_x;  %   INPUT LINE START X
x2 = end_y;  % INPUT LINE END Y
y2 = end_x; %  INPUT LINE END X

px = x2-x1;
py = y2-y1;

norm = px*px + py*py;

u =  ((x3 - x1) * px + (y3 - y1) * py) / norm;

if u > 1
    u = 1;
elseif u < 0
    u = 0;
end

x = x1 + u * px;
y = y1 + u * py;

dx = x - x3;
dy = y - y3;


dist = sqrt(dx*dx + dy*dy);

end

