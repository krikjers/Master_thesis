close all;
clc

% figure('DefaultAxesFontSize',17);
% title('Penalty score for non-apparent speed change')
% grid on;
% hold on;
% plot([0, 0.5], [1, 0], 'b');
% plot([0.5, 1], [0,0], 'b');
% xlabel('\DeltaU (% decrease in speed)');
% ylabel('Penalty');








% 
% figure('DefaultAxesFontSize',17);
% title('Safety score for pose')
% grid on;
% hold on;
% ylabel("Score");
% xlabel("\alpha_{cpa} / \beta_{cpa} [deg]");
% f = @(x) 1 - cosd(x);
% plot([-110,-90],[1,1], 'b');
% 
% plot([90,110],[1,1], 'b');
% fplot(f, [-90,90], 'b');
% xlim([-110, 110]);
% ylim([-0.1, 1.1]);




% figure('DefaultAxesFontSize',17);
% title('Safety score for distance')
% grid on;
% hold on;
% ylabel("Score");
% xlabel("r_{cpa} [m]");
% 
% h(1) = plot([0,200],[0,0], 'r');
% plot([200,600],[0,0.6], 'r');
% plot([600,1000],[0.6,1], 'r');
% plot([1000,1250],[1,1], 'r');
% 
% h(2) = plot([0,100],[0,0], 'b');
% plot([100,400],[0,0.6], 'b');
% plot([400,750],[0.6,1], 'b');
% plot([750,1000],[1,1], 'b');
% 
% 
% legend(h, "Region 1", "Region 2");
% 
% xlim([0, 1250]);
% ylim([-0.1, 1.1]);

% 
% 

% figure('DefaultAxesFontSize',17);
% title('Penalty score for delayed maneuver')
% grid on;
% hold on;
% ylabel("Penalty");
% xlabel("r_{maneuver} [m]");
% plot([0,1000],[1,0], 'b');
% plot([1000,1300],[0,0], 'b');
% 
% xlim([0, 1300]);
% ylim([-0.1, 1.1]);


% 
% figure('DefaultAxesFontSize',17);
% title('Penalty score for non-apparent heading change')
% grid on;
% hold on;
% ylabel("Penalty");
% xlabel("\Delta \psi [deg]");
% plot([-50,-30],[0,0], 'b');
% plot([-30,-4],[0,1], 'b');
% plot([-4,4],[1,1], 'b');
% plot([4,30],[1,0], 'b');
% plot([30,50],[0,0], 'b');
% xlim([-50, 50]);
% xticks([-50,-40,-30,-20,-10,0,10,20,30,40,50]);
% ylim([-0.1, 1.1]);



figure('DefaultAxesFontSize',17);
title('Safety score for port-to-port passing')
grid on;
hold on;
zlabel("Score");
xlabel("\alpha_{cpa} [deg]");
ylabel("\beta_{cpa} [deg]");
[a,b] = meshgrid(-300:10:360);
Z = ((sind(a)-1)/(2)).^2.*((sind(b)-1)/(2)).^2;
surf(a,b,Z);
xlim([-200,120]);
ylim([0,350]);

% figure('DefaultAxesFontSize',17);
% title('Penalty score for heading change')
% grid on;
% hold on;
% ylabel("Penalty");
% plot([-50,-30],[1,1], 'b');
% plot([-30,-4],[1,0], 'b');
% plot([-4,4],[0,0], 'b');
% plot([4,30],[0,1], 'b');
% plot([30,50],[1,1], 'b');
% xlim([-50, 50]);
% xticks([-50,-40,-30,-20,-10,0,10,20,30,40,50]);
% ylim([-0.1, 1.1]);
% xlabel("\Delta \psi [deg]");
% ylabel("Penalty");





figure('DefaultAxesFontSize',17);
title('Penalty score for maneuvering when not in extremis')
grid on;
hold on;
ylabel("Penalty");
plot([0,L_min],[0,0], 'b');
plot([L_max, L_max+300],[1,1], 'b');

xlim([0, L_max+200]);
ylim([-0.1, 1.1]);
xlabel("r_{maneuver} [m]");
ylabel("Penalty");
f = @(x) 1- ((x - L_max)/(L_max-L_min))^2;
fplot(f, [300,750], 'b');



% 
% figure('DefaultAxesFontSize',17);
% title('Penalty score for non-starboard turns')
% grid on;
% hold on;
% ylabel("Penalty");
% plot([0,d_T/2],[0,0], 'b');
% plot([d_T, d_T+300],[1,1], 'b');
% xlim([0, d_T+50]);
% ylim([-0.1, 1.1]);
% xlabel("d [m]");
% ylabel("Penalty");
% f = @(x) 1- (2*(d_T - x)/(d_T))^4;
% fplot(f, [d_T/2,d_T], 'b');
