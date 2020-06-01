Master's thesis in Cybernetics and Robotics at NTNU.

The aim of the master's thesis was to determine if utilization of other vessels’ intentions can improve the
performance of an existing short-term collision avoidance method; the Simulation-BasedModel Predictive Control (SBMPC) 
algorithm by Johansen et al. (2016). 

The code contains a vessel simulator and an analysis tool.



The vessel simulator is able to simulate the behavior of several ships and static obstacles at the same time. 
Obstacle ships with and without a collision avoidance system can be added.

The simulator is developed based on the mathematical ship models by Fossen (2011). LOS guidance calulates desired path for the vessel based 
on predefined waypoints. A feedback linearizing controller is used for controlling the ship. A separate collision avoidance block
makes the ship able to avoid collision with both static and dynamic obstacles.

After simulations are performed with the simulator, the simulation results can be analyzed with the provided analysis tool. 
This tool will calculate metrics for determining the collision avoidance performance. The metrics are partly based on the work
in the PhD thesis by Woerner (2016).
