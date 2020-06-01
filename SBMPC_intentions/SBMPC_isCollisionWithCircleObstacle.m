function [ collision ] = SBMPC_isCollisionWithCircleObstacle( vessel_center_x, vessel_center_y, vessel_length, vessel_heading, circle_x, circle_y, radius, safety_margin)
   %returns collision = 1 if vessel is inside or on the edge of the circle 
   %vessel heading is in rad
   collision = false;
   vessel_bow_x = vessel_center_x + cos(vessel_heading)*(vessel_length/2);
   vessel_bow_y = vessel_center_y + sin(vessel_heading)*(vessel_length/2);

   if ( (vessel_bow_x-circle_x)^2 + (vessel_bow_y-circle_y)^2 < (radius+safety_margin)^2)
       collision = true;% the point (x,y) is inside the circle,
   elseif ( (vessel_bow_x-circle_x)^2 + (vessel_bow_y-circle_y)^2 == (radius+safety_margin)^2)
       collision = true; %the point (x,y) is on the circle
   elseif ( (vessel_bow_x-circle_x)^2 + (vessel_bow_y-circle_y)^2 > (radius+safety_margin)^2)
       collision = false; % the point (x,y) is outside the circle.
   end
end

