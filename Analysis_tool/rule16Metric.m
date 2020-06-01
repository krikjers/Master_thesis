function [ S16 ] = rule16Metric( S_safety, P8_delay, P8_app, rule16 )
    
if(rule16 == true)
   S16 = S_safety*(1-P8_delay)*(1-P8_app);  
else
    S16 = 0;
end

end

