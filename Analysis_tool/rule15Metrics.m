function [ P15_ahead, S15 ] = rule15Metrics( alpha_cpa, T_ahead_low, T_ahead_high, S16, S17, gamma15_ahead, rule15, rule16, rule17  )
%alpha_cpa = contact angle at cpa
%T_ahead_low, T_ahead_high = threshold values. Only give penalty if contact angle is in the range [T_ahead_low, T_ahead_high]
% S16, S17 = score for rule 16 and 17
% gamma15_ahead = weight parameter


rad2deg = 180/pi;
deg2rad = pi/180;
if (rule15 == true)
    if (alpha_cpa > T_ahead_low && alpha_cpa < T_ahead_high)
        P15_ahead = 1;
    else
        P15_ahead = 0;
    end

    if (rule15 == true && rule16 == true)
        %own ship is give way in crossing situation
        S15 = max(0, (S16 - gamma15_ahead*P15_ahead));
    elseif(rule15 == true && rule17 == true)
        % own ship is stand on in crossing situation.
        S15 = S17;
    end

else
    P15_ahead = -1;
    S15 = -1;
end


end

