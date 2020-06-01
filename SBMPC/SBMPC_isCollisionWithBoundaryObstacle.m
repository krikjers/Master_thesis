function [ collision ] = SBMPC_isCollisionWithBoundaryObstacle( vessel_center_x, vessel_center_y, vessel_length, vessel_heading, boundary_start_x, boundary_start_y, boundary_end_x, boundary_end_y)
%collision is detected if the line from the center of the vessel to the vessel bow intersects with the boundary obstacle line.
vessel_bow_x = vessel_center_x + cos(vessel_heading)*(vessel_length/2);
vessel_bow_y = vessel_center_y + sin(vessel_heading)*(vessel_length/2);

line_for_vessel_start_x = vessel_center_x;
line_for_vessel_start_y = vessel_center_y;
line_for_vessel_end_x   = vessel_bow_x;
line_for_vessel_end_y   = vessel_bow_y;

%code from https://stackoverflow.com/questions/27928373/how-to-check-whether-two-lines-intersect-or-not/27978025
x=[boundary_start_x boundary_end_x line_for_vessel_start_x line_for_vessel_end_x];
y=[boundary_start_y boundary_end_y line_for_vessel_start_y line_for_vessel_end_y];
dt1=det([1,1,1;x(1),x(2),x(3);y(1),y(2),y(3)])*det([1,1,1;x(1),x(2),x(4);y(1),y(2),y(4)]);
dt2=det([1,1,1;x(1),x(3),x(4);y(1),y(3),y(4)])*det([1,1,1;x(2),x(3),x(4);y(2),y(3),y(4)]);

if(dt1<=0 && dt2<=0)
  collision=true;         %If lines intesect
else
  collision=false;
end 


end

