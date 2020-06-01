function [ P13_ahead, S13 ] = rule13Metrics( rule13, rule16, rule17, S16, S17, gamma13_ahead, alpha_cpa  )
    %rule13, rule16, rule17 are true if the rule apply. these are calcuated
    %from "typeOfCollisionSituation" function.
    % S16, S17 are metrics for rule 16 and 17
    % gamma13_ahead is a weight parameter
    % alpha_cpa is the contact angle at cpa.

    rad2deg = 180/pi;
    deg2rad = pi/180;
    if (alpha_cpa > -45*deg2rad && alpha_cpa < 45*deg2rad)
        P13_ahead = 1;
    else
        P13_ahead = 0;
    end
        
    if (rule13 == true && rule17 == true)
        %own ship is overtaken (is stand on)
        S13 = S17;
    elseif (rule13 == true && rule16 == true)
        %own ship overtakes (is give way)
        S13 = max(0, S16 - gamma13_ahead*P13_ahead);
    else
        S13 = -1; %if not an overtake situation
    end


end

