% %% 
% close all;
% clc;


% %%
% figure('DefaultAxesFontSize',14);
% hold on;
% grid on;
% title("ownm ship heading");
% x = 0:pi/20:2*pi;
% y = sin(x);
% plot(x,y)
% str = {'start','end'};
% text([1 6],[0 0],str,'FontSize',12);
% 



%% 
close all;

markerSize = 7;
lineWidth = 1;
fontSize = 18;
diamond_num_offset_y = 0;
diamond_num_offset_x = 0;
num_offset_y = -560;
num_offset_x = 95;


figure('DefaultAxesFontSize',13);
%pbaspect([2 2 1]);
if (scenario_name == "crossing_w_sbmpc_obs_on_right_2" || scenario_name == "crossing_w_sbmpc_obs_on_right_2_w_intentions")
    xlim_1 = -3000;
    xlim_2 =  4000;
    ylim_1 = -4000;
    ylim_2 =  3000;    
    xlabels_1 = '-2000';
    xlabels_2 = '0';
    xlabels_3 = '2000';
    xlabels_4 = '';
    time_stop = 200;    
    set(gcf, 'Position',  [500, 600, 900, 330]);
elseif (scenario_name == "plot_explanation" || scenario_name == "plot_explanation_w_intentions")
    xlim_1 = -2600;
    xlim_2 =  6000;
    ylim_1 = -4300;
    ylim_2 =  4300;
    xlabels_1 = '-2000';
    xlabels_2 = '0';
    xlabels_3 = '2000';
    xlabels_4 = '4000';
    time_stop = 300;  
    set(gcf, 'Position',  [500, 600, 900, 330]);
elseif(scenario_name == "head_on_w_SBMPC_obs" || scenario_name == "head_on_w_SBMPC_obs_w_intentions")
    xlim_1 = -4000;
    xlim_2 =  4000;
    ylim_1 = -4000;
    ylim_2 =  4000;
    xlabels_1 = '';
    xlabels_2 = '-2000';
    xlabels_3 = '0';
    xlabels_4 = '2000';
    time_stop = 200;   
    set(gcf, 'Position',  [500, 600, 900, 330]);
elseif( scenario_name== "crossing_w_changing_normal_obs_on_left" || scenario_name == "crossing_w_changing_normal_obs_on_left_w_intentions")
    xlim_1 = -4100;
    xlim_2 =  4100;
    ylim_1 = -4000;
    ylim_2 =  4200;
    xlabels_1 = '-2000';
    xlabels_2 = '0';
    xlabels_3 = '2000';
    xlabels_4 = '';
    time_stop = 200;    
    set(gcf, 'Position',  [500, 600, 900, 330]);
elseif( scenario_name== "crossing_w_changing_normal_obs_on_left_w_circle" || scenario_name == "crossing_w_changing_normal_obs_on_left_w_circle_w_intentions")
    xlim_1 = -4100;
    xlim_2 =  6100;
    ylim_1 = -4000;
    ylim_2 =  6200;
    xlabels_1 = '';
    xlabels_2 = '-2000';
    xlabels_3 = '0';
    xlabels_4 = '2000';
    time_stop = 200;    
    set(gcf, 'Position',  [500, 600, 900, 330]);
elseif(scenario_name == "overtakes_normal_obs" || scenario_name == "overtakes_normal_obs_w_intentions") 
    xlim_1 = -3500;
    xlim_2 =  3000;
    ylim_1 = -3500;
    ylim_2 =  3000;
    xlabels_1 = '-2000';
    xlabels_2 = '0';
    xlabels_3 = '2000';
    xlabels_4 = '';
    time_stop = 200;   
    set(gcf, 'Position',  [500, 600, 900, 330]);
elseif(scenario_name == "overtakes_normal_obs_w_boundary_obs" || scenario_name == "overtakes_normal_obs_w_boundary_obs_w_intentions") 
    xlim_1 = -2700;
    xlim_2 =  2700;
    ylim_1 = -3200;
    ylim_2 =  2700;
    xlabels_1 = '-2000';
    xlabels_2 = '0';
    xlabels_3 = '2000';
    xlabels_4 = '';
    time_stop = 200;    
    set(gcf, 'Position',  [500, 600, 828, 330]);
elseif(scenario_name == "overtaken_by_normal_obs" || scenario_name == "overtaken_by_normal_obs_w_intentions") 
    xlim_1 = -3200;
    xlim_2 =  3200;
    ylim_1 = -3200;
    ylim_2 =  4700;
    xlabels_1 = '-2000';
    xlabels_2 = '0';
    xlabels_3 = '2000';
    xlabels_4 = '';
    time_stop = 200;    
    set(gcf, 'Position',  [500, 600, 775, 350]);
elseif( scenario_name == "head_on_w_changing_normal_ship" || scenario_name == "head_on_w_changing_normal_ship_w_intentions")
    xlim_1 = -4500;
    xlim_2 =  4500;
    ylim_1 = -4000;
    ylim_2 =  5000;
    xlabels_1 = '';
    xlabels_2 = '-2000';
    xlabels_3 = '0';
    xlabels_4 = '2000';
    time_stop = 200;   
    set(gcf, 'Position',  [500, 600, 900, 330]);  
elseif( scenario_name == "crossing_w_changing_normal_obs_on_right_2" || scenario_name == "crossing_w_changing_normal_obs_on_right_2_w_intentions")
    xlim_1 = -3000;
    xlim_2 =  3600;
    ylim_1 = -3300;
    ylim_2 =  4300;
    xlabels_1 = '-2000';
    xlabels_2 = '0';
    xlabels_3 = '2000';
    xlabels_4 = '';
    time_stop = 200;    
    set(gcf, 'Position',  [500, 600, 780, 330]);           
elseif( scenario_name == "cross_right_and_overtaken" || scenario_name == "cross_right_and_overtaken_w_intentions")
    xlim_1 = -2000;
    xlim_2 =  4000;
    ylim_1 = -4000;
    ylim_2 =  2000;
    xlabels_1 = '';
    xlabels_2 = '';
    xlabels_3 = '';
    xlabels_4 = '';
    time_stop = 200;  
    set(gcf, 'Position',  [500, 600, 900, 330]);  
elseif( scenario_name == "cross_mixed_w_circle" || scenario_name == "cross_mixed_w_circle_w_intentions")
    xlim_1 = -4100;
    xlim_2 =  4100;
    ylim_1 = -5000;
    ylim_2 =  3200;
    xlabels_1 = '';
    xlabels_2 = '-2000';
    xlabels_3 = '0';
    xlabels_4 = '2000';
    time_stop = 200;  
    set(gcf, 'Position',  [500, 600, 900, 330]); 
elseif( scenario_name == "overtakes_and_ho_2_sbmpc_obs" || scenario_name == "overtakes_and_ho_2_sbmpc_obs_w_intentions")
    xlim_1 = -2700;
    xlim_2 =  2700;
    ylim_1 = -3750;
    ylim_2 =  3800;
    xlabels_1 = '-2000';
    xlabels_2 = '0';
    xlabels_3 = '2000';
    xlabels_4 = '';
    time_stop = 380;  
    set(gcf, 'Position',  [500, 600, 650, 330]); 
elseif( scenario_name == "ho_and_2_crossings_3_ships" || scenario_name == "ho_and_2_crossings_3_ships_w_intentions")
    xlim_1 = -4500;
    xlim_2 =  4500;
    ylim_1 = -4500;
    ylim_2 =  4500;
    xlabels_1 = '';
    xlabels_2 = '';
    xlabels_3 = '';
    xlabels_4 = '';
    time_stop = 200;  
    set(gcf, 'Position',  [500, 600, 900, 330]); 
elseif( scenario_name == "ho_overtakes_sbmpc_crossing_3_mixed_obs" || scenario_name == "ho_overtakes_sbmpc_crossing_3_mixed_obs_w_intentions")
    xlim_1 = -3200;
    xlim_2 =  4000;
    ylim_1 = -4300;
    ylim_2 =  5200;
    xlabels_1 = '-2000';
    xlabels_2 = '0';
    xlabels_3 = '2000';
    xlabels_4 = '';
    time_stop = 200;  
    set(gcf, 'Position',  [500, 600, 682, 330]); 
elseif( scenario_name == "ho_overtaken_cross_w_boundary_3_obs" || scenario_name == "ho_overtaken_cross_w_boundary_3_obs_w_intentions")
    xlim_1 = -3250;
    xlim_2 =  4000;
    ylim_1 = -5600;
    ylim_2 =  3500;
    xlabels_1 = '-2000';
    xlabels_2 = '0';
    xlabels_3 = '2000';
    xlabels_4 = '';
    time_stop = 300;  
    set(gcf, 'Position',  [500, 600, 718, 330]); 
elseif( scenario_name == "ho_cross_4_obs" || scenario_name == "ho_cross_4_obs_w_intentions")
    xlim_1 = -1400;
    xlim_2 =  3900;
    ylim_1 = -3400;
    ylim_2 =  3700;
    xlabels_1 = '';
    xlabels_2 = '0';
    xlabels_3 = '';
    xlabels_4 = '2000';
    time_stop = 500;  
    set(gcf, 'Position',  [500, 600, 678, 330]);
elseif( scenario_name == "cross_4_obs" || scenario_name == "cross_4_obs_w_intentions")
    xlim_1 = -4500;
    xlim_2 =  3900;
    ylim_1 = -4450;
    ylim_2 =  3950;
    xlabels_1 = '';
    xlabels_2 = '';
    xlabels_3 = '';
    xlabels_4 = '';
    time_stop = 300;  
    set(gcf, 'Position',  [500, 600, 900, 330]);
end
    





if (endsWith(scenario_name,"_w_intentions") == true)
    suptitle('Trajectory w/ modified SBMPC');
else
    suptitle('Trajectory w/ SBMPC');
end
ax1 = subplot(1,3,2, 'align');
hold on;

axis equal;
grid on;
xlim([xlim_1, xlim_2]);
ylim([ylim_1, ylim_2]);
xlabel('East [m]');
%ylabel('North [m]');
set(gca,'Yticklabel',[]) %to just get rid of the numbers but leave the ticks.
xticklabels = get(ax1, 'Xticklabel');
xticklabels{end} = '';   %needs to exist but make it empty
xticklabels{1} = xlabels_1;   
xticklabels{2} = xlabels_2;   
xticklabels{3} = xlabels_3;   
xticklabels{4} = xlabels_4;   
set(ax1, 'XTickLabel', xticklabels);
for i=1:(number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)
    if(t_detected(i) ~= -1)
        if(i <= number_of_obstacle_ships)
            plot(obstacle_ships_Y(i,:), obstacle_ships_X(i,:), 'r', 'LineWidth',lineWidth);
            plot(obstacle_ships_Y(i,end), obstacle_ships_X(i,end), 'o-r', 'MarkerSize', markerSize);
            text(obstacle_ships_Y(i,1) + num_offset_y ,obstacle_ships_X(i,1) + num_offset_x ,int2str(i-1),'Color','black','FontSize',fontSize);
            if(t_detected(i) ~= -1)
                %plot(own_vessel_y(t_cpa(i)), own_vessel_x(t_cpa(i)), 'd-r', 'MarkerSize', markerSize);
                %plot(obstacle_ships_Y(i,t_cpa(i)), obstacle_ships_X(i,t_cpa(i)), 'd-r', 'MarkerSize', markerSize);
                %text(own_vessel_y(t_cpa(i))+diamond_num_offset_y, own_vessel_x(t_cpa(i))+diamond_num_offset_x ,int2str(1),'Color','black','FontSize',fontSize);
            end

        else
            plot(obstacle_ships_Y(i,:), obstacle_ships_X(i,:), 'm', 'MarkerSize', markerSize);
            plot(obstacle_ships_Y(i,end), obstacle_ships_X(i,end), 'o-m','MarkerSize', markerSize);
            text(obstacle_ships_Y(i,1) + num_offset_y ,obstacle_ships_X(i,1) + num_offset_x ,int2str(i-1),'Color','black','FontSize',fontSize);

            if(t_detected(i) ~= -1)    
                %plot(own_vessel_y(t_cpa(i)), own_vessel_x(t_cpa(i)), 'd-m', 'MarkerSize', markerSize);
               % plot(obstacle_ships_Y(i,t_cpa(i)), obstacle_ships_X(i,t_cpa(i)), 'd-m', 'MarkerSize', markerSize);
                %text(own_vessel_y(t_cpa(i))+diamond_num_offset_y, own_vessel_x(t_cpa(i)) + diamond_num_offset_x ,int2str(1),'Color','black','FontSize',fontSize);
            end
        end 
    end
end

for i = 1:num_circle_obstacles
    d = radius(i)*2;
    px = center_y(i)-radius(i);
    py = center_x(i)-radius(i);
    h = rectangle('Position',[px py d d],'Curvature',[1,1], 'LineWidth',lineWidth);
    daspect([1,1,1])
end

for i = 1:num_boundary_obstacles      
    line_start_position = boundary_obstacle_start_positions(i,:);
    start_x = line_start_position(1);
    start_y = line_start_position(2);

    line_end_position = boundary_obstacle_end_positions(i,:);
    end_x = line_end_position(1);
    end_y = line_end_position(2);
    plot([start_y end_y], [start_x end_x], 'k', 'LineWidth',lineWidth)   
end
if (strcmp(scenario_name, 'ho_overtaken_cross_w_boundary_3_obs') || strcmp(scenario_name, 'ho_overtaken_cross_w_boundary_3_obs_w_intentions'))
   plot( [-1900 1000], [0 0 ], 'k', 'LineWidth',lineWidth);   
end

plot(own_vessel_y, own_vessel_x, 'b', 'LineWidth',lineWidth);
plot(own_vessel_y(end), own_vessel_x(end), 'o-b', 'MarkerSize', markerSize);





ax2 = subplot(1,3,1, 'align');
smallest_cpa = min(r_cpa);
smallest_cpa_index = find(r_cpa == smallest_cpa);
smallest_t_cpa = t_cpa(smallest_cpa_index);

hold on;
grid on;
axis equal;
xlim([xlim_1, xlim_2]);
ylim([ylim_1, ylim_2]);
%pbaspect([1 2 1]);
xlabel('East [m]');
%ylabel('North [m]');
set(gca,'Yticklabel',[]) %to just get rid of the numbers but leave the ticks.
xticklabels = get(ax2, 'Xticklabel');
xticklabels{end} = '';   %needs to exist but make it empty
xticklabels{1} = xlabels_1;   
xticklabels{2} = xlabels_2;   
xticklabels{3} = xlabels_3;   
xticklabels{4} = xlabels_4;   
set(ax2, 'XTickLabel', xticklabels);
for i=1:(number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)
    if(t_detected(i) ~= -1)
        if(i <= number_of_obstacle_ships)
            plot(obstacle_ships_Y(i,1:smallest_t_cpa), obstacle_ships_X(i,1:smallest_t_cpa), 'r', 'LineWidth',lineWidth);
            plot(obstacle_ships_Y(i,smallest_t_cpa), obstacle_ships_X(i,smallest_t_cpa), 'o-r', 'MarkerSize', markerSize);
            text(obstacle_ships_Y(i,1) + num_offset_y ,obstacle_ships_X(i,1) + num_offset_x ,int2str(i-1),'Color','black','FontSize',fontSize);
        else
            plot(obstacle_ships_Y(i,1:smallest_t_cpa), obstacle_ships_X(i,1:smallest_t_cpa), 'm', 'MarkerSize', markerSize);
            plot(obstacle_ships_Y(i,smallest_t_cpa), obstacle_ships_X(i,smallest_t_cpa), 'o-m', 'MarkerSize', markerSize);
            text(obstacle_ships_Y(i,1) + num_offset_y, obstacle_ships_X(i,1) + num_offset_x, int2str(i-1),'Color','black','FontSize',fontSize);
        end  
    end
    
end

for i = 1:num_circle_obstacles
    d = radius(i)*2;
    px = center_y(i)-radius(i);
    py = center_x(i)-radius(i);
    h = rectangle('Position',[px py d d],'Curvature',[1,1],  'LineWidth',lineWidth);
    daspect([1,1,1])
end

for i = 1:num_boundary_obstacles       
    line_start_position = boundary_obstacle_start_positions(i,:);
    start_x = line_start_position(1);
    start_y = line_start_position(2);

    line_end_position = boundary_obstacle_end_positions(i,:);
    end_x = line_end_position(1);
    end_y = line_end_position(2);
    plot([start_y end_y], [start_x end_x], 'k', 'LineWidth',lineWidth)   
end

if (strcmp(scenario_name, 'ho_overtaken_cross_w_boundary_3_obs') || strcmp(scenario_name, 'ho_overtaken_cross_w_boundary_3_obs_w_intentions'))
   plot( [-1900 1000], [0 0 ], 'k', 'LineWidth',lineWidth);   
end

plot(own_vessel_y(1:smallest_t_cpa), own_vessel_x(1:smallest_t_cpa), 'b', 'LineWidth',lineWidth);
plot(own_vessel_y(smallest_t_cpa), own_vessel_x(smallest_t_cpa), 'o-b', 'MarkerSize', markerSize);












ax3 = subplot(1,3,3, 'align');
hold on;
grid on;
axis equal;
xlim([xlim_1, xlim_2]);
ylim([ylim_1, ylim_2]);
%pbaspect([1 2 1]);
xlabel('East [m]');
ylabel('North [m]');
xticklabels = get(ax3, 'Xticklabel');
yticklabels = get(ax3, 'Yticklabel');
xticklabels{end} = '';   %needs to exist but make it empty
xticklabels{1} = xlabels_1;   
xticklabels{2} = xlabels_2;   
xticklabels{3} = xlabels_3;   
xticklabels{4} = xlabels_4;   
set(ax3, 'XTickLabel', xticklabels);
for i=1:(number_of_obstacle_ships + number_of_SBMPC_obstacle_ships)
    if(t_detected(i) ~= -1)
        if(i <= number_of_obstacle_ships)
            plot(obstacle_ships_Y(i,1:time_stop), obstacle_ships_X(i,1:time_stop), 'r', 'LineWidth',lineWidth);
            plot(obstacle_ships_Y(i,time_stop), obstacle_ships_X(i,time_stop), 'o-r', 'MarkerSize', markerSize);
            text(obstacle_ships_Y(i,1) + num_offset_y ,obstacle_ships_X(i,1) + num_offset_x ,int2str(i-1),'Color','black','FontSize',fontSize);
        else
            plot(obstacle_ships_Y(i,1:time_stop), obstacle_ships_X(i,1:time_stop), 'm', 'MarkerSize', markerSize);
            plot(obstacle_ships_Y(i,time_stop), obstacle_ships_X(i,time_stop), 'o-m', 'MarkerSize', markerSize);
            text(obstacle_ships_Y(i,1) + num_offset_y, obstacle_ships_X(i,1) + num_offset_x ,int2str(i-1),'Color','black','FontSize',fontSize);
        end  
    end
    
end

for i = 1:num_circle_obstacles
    d = radius(i)*2;
    px = center_y(i)-radius(i);
    py = center_x(i)-radius(i);
    h = rectangle('Position',[px py d d],'Curvature',[1,1],  'LineWidth',lineWidth);
    daspect([1,1,1])
end

for i = 1:num_boundary_obstacles       
    line_start_position = boundary_obstacle_start_positions(i,:);
    start_x = line_start_position(1);
    start_y = line_start_position(2);

    line_end_position = boundary_obstacle_end_positions(i,:);
    end_x = line_end_position(1);
    end_y = line_end_position(2);
    plot([start_y end_y], [start_x end_x], 'k', 'LineWidth',lineWidth)   
end
if (strcmp(scenario_name, 'ho_overtaken_cross_w_boundary_3_obs') || strcmp(scenario_name, 'ho_overtaken_cross_w_boundary_3_obs_w_intentions'))
   plot( [-1900 1000], [0 0 ], 'k', 'LineWidth',lineWidth);   
end

plot(own_vessel_y(1:time_stop), own_vessel_x(1:time_stop), 'b', 'LineWidth',lineWidth);
plot(own_vessel_y(time_stop), own_vessel_x(time_stop), 'o-b', 'MarkerSize', markerSize);


set(ax3, 'Position', [.05 .187 .38 .7]); %1.
set(ax2, 'Position', [.308 .187 .38 .7]);   %2.
set(ax1, 'Position', [.566 .187 .38 .7]); %3.







%% 

figure('DefaultAxesFontSize',14);
set(gcf, 'Position',  [100, 100, 560, 330]);
pbaspect([2 1 1]);
if (endsWith(scenario_name,"_w_intentions") == true)
    title('Heading w/ modified SBMPC' , 'fontweight', 'Normal');
else
    title('Heading w/ SBMPC' , 'fontweight', 'Normal');
end
hold on;
grid on;
%plot(seconds, own_vessel_desired_psi*rad2deg + psi_ca*rad2deg, 'k', 'LineWidth',lineWidth);
plot(seconds, own_vessel_psi*rad2deg, 'b', 'LineWidth',lineWidth);
plot(seconds, psi_ca*rad2deg, 'k--','LineWidth',lineWidth); 
plot(seconds, own_vessel_desired_psi*rad2deg, 'r--','LineWidth',lineWidth); 
ylabel('Heading [deg]');
xlabel('Time [s]');
xlim([0,length(seconds)]);
lgd = legend('\psi', '\psi_{ca}', '\psi_d', 'Location', 'northeast');
lgd.FontSize = 18;


%NB!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%use ",'HandleVisibility','off'" to avoid a graph showing up in legend. see
%https://au.mathworks.com/matlabcentral/answers/406-how-do-i-skip-items-in-a-legend




%%



figure('DefaultAxesFontSize',14);
set(gcf, 'Position',  [700, 100, 560, 330]);
pbaspect([2 1 1]);
if (endsWith(scenario_name,"_w_intentions") == true)
    title('Speed w/ modified SBMPC' , 'fontweight', 'Normal');
else
    title('Speed w/ SBMPC', 'fontweight', 'Normal');
end
hold on;
grid on;
plot(seconds, own_vessel_desired_u.*Pr, 'k', 'LineWidth',lineWidth);
plot(seconds, own_vessel_u, 'b', 'LineWidth',lineWidth);
ylabel('Speed [m/s]');
xlabel('Time [s]');
xlim([0,length(seconds)]);
lgd = legend('u_c', 'u', 'Location', 'northeast');
lgd.FontSize = 15;
ylim([0,7.5]);









%%



% ax = subplot(2,3,4);
% x = int2str(33);
% %text(0.5,0.5,['Obstacle: ', int2str(1), newline, 'tessssssss'], 'FontSize', 14, 'FontWeight', 'bold');
% text(0.3,1,['Obstacle: ', int2str(1)], 'FontSize', 14, 'FontWeight', 'bold');
% text(0.3,0.9,['Active COLREGs: ', '3,4,5,6'], 'FontSize', 12);
% text(0.3,0.8,['Metric scores:'], 'FontSize', 12, 'FontWeight', 'bold');
% text(0.3,0.7,['S_{safety} = ', int2str(S_safety(1,1))], 'FontSize', 12);
% text(0.3,0.6,['S^8 = ', int2str(S8(1,1))], 'FontSize', 12);
% text(0.3,0.5,['S^{13} = ', int2str(S13(1,1))], 'FontSize', 12);
% text(0.3,0.4,['S^{14} = ', int2str(S14(1,1))], 'FontSize', 12);
% text(0.3,0.3,['S^{15} = ', int2str(S15(1,1))], 'FontSize', 12);
% text(0.3,0.2,['S^{16} = ', int2str(S16(1,1))], 'FontSize', 12);
% text(0.3,0.1,['S^{17} = ', int2str(S17(1,1))], 'FontSize', 12);
% set ( ax, 'visible', 'off');
% 
% ax = subplot(2,3,5);
% x = int2str(33);
% %text(0.5,0.5,['Obstacle: ', int2str(1), newline, 'tessssssss'], 'FontSize', 14, 'FontWeight', 'bold');
% text(0.3,1,['Obstacle: ', int2str(2)], 'FontSize', 14, 'FontWeight', 'bold');
% text(0.3,0.9,['Active COLREGs: ', '3,4,5,6'], 'FontSize', 12);
% text(0.3,0.8,['Metric scores:'], 'FontSize', 12, 'FontWeight', 'bold');
% text(0.3,0.7,['S_{safety} = ', int2str(S_safety(2,1))], 'FontSize', 12);
% text(0.3,0.6,['S^8 = ', int2str(S8(2,1))], 'FontSize', 12);
% text(0.3,0.5,['S^{13} = ', int2str(S13(2,1))], 'FontSize', 12);
% text(0.3,0.4,['S^{14} = ', int2str(S14(2,1))], 'FontSize', 12);
% text(0.3,0.3,['S^{15} = ', int2str(S15(2,1))], 'FontSize', 12);
% text(0.3,0.2,['S^{16} = ', int2str(S16(2,1))], 'FontSize', 12);
% text(0.3,0.1,['S^{17} = ', int2str(S17(2,1))], 'FontSize', 12);
% set ( ax, 'visible', 'off');
