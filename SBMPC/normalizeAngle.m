function normalizedAngle = normalizeAngle(angle)
    %from: https://stackoverflow.com/questions/2320986/easy-way-to-keeping-angles-between-179-and-180-degrees
    %input angle is rad and output angle shold be rad
    angle = rad2deg(angle);
    %reduce the angle  
    angle =  mod(angle, 360); 

    % force it to be the positive remainder, so that 0 <= angle < 360  
    angle = mod((angle + 360), 360);  

    % force into the minimum absolute value residue class, so that -180 < angle <= 180  
    if (angle > 180)  
        angle = angle - 360; 
    end
    angle = deg2rad(angle);
    
    normalizedAngle = angle;
       
    
end
