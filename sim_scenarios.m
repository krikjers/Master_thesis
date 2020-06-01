

for sc_sim_step = 1:2
   close all;
   parameter_initialization
   use_intentions = [true, false];


   if(use_intentions(sc_sim_step) == true)
        cd SBMPC_intentions
        sim modules_intentions.slx
        cd ..   
   else
        cd SBMPC
        sim modules.slx
        cd ..

   end
    
   seconds = t/tsamp;
   if (use_intentions(sc_sim_step) == true)
        scenario_name = scenario_name + "_w_intentions";
   end
   save(scenario_name);
   

end

figure();
plot(1,1);




