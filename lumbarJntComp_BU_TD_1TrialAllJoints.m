%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script is to compare bottom up and top down ID methods in
% calculating lumbar joint torques
% Three movement types are selected: Walk36; Run81; Squat.
%
% By: Huawei Wang
% Date: May 26, 2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear
clc

%% comparison trials, lumbar jnt columns
trialNames = ["walk_36"];
lumbarJntAngCol_bu = [15, 14, 11, 8, 9, 10, 2, 3, 4, 5, 6, 7];
lumbarJntAngCol_td = [12, 11, 8, 22, 23, 24, 2, 3, 4, 5, 6, 7];
lumbarJntAngLabel = ["Ankle-r-Ang", "Knee-r-Ang", "Hip-r-Ang", ...
    "Lumbar-extension-Ang", "Lumbar-bending-Ang", "Lumbar-rotation-Ang" ...
    "Free-tilt-Ang", "Free-list-Ang", "Free-rotation-Ang", ...
    "Free-fx-Dis", "Free-fy-Dis", "Free-fz-Dis"];
lumbarJntTorCol_bu = [19, 17, 11, 8, 9, 10, 2, 3, 4, 5, 6, 7];
lumbarJntTorCol_td = [19, 17, 8, 14, 15, 16, 2, 3, 4, 5, 6, 7];
lumbarJntTorLabel = ["Ankle-r-Tor", "Knee-r-Tor", "Hip-r-Tor", ...
    "Lumbar-extension-Tor", "Lumbar-bending-Tor", "Lumbar-rotation-Tor" ...
    "Free-tilt-Tor", "Free-list-Tor", "Free-rotation-Tor", ...
    "Free-fx-For", "Free-fy-For", "Free-fz-For"];

filePath_TopDown = 'SubjData_TopDown';
filePath_BottomUp = 'SubjData_BottomUp';

%% load top down data

fig1 = figure();
fig2 = figure();
lw = 2;

for itrial = 1:length(trialNames)
   trial = trialNames(itrial);
   topdown_data = load(sprintf('%s/%s_%s.mat', filePath_TopDown, filePath_TopDown, trial));
   bottomup_data = load(sprintf('%s/%s_%s.mat', filePath_BottomUp, filePath_BottomUp, trial));
   
   for icol = 1:length(lumbarJntAngCol_bu)
       col_bu = lumbarJntAngCol_bu(icol);
       col_td = lumbarJntAngCol_td(icol);
       figure(fig1)
       subplot(4, ceil(length(lumbarJntAngCol_bu)/4), icol)
       if icol > 3 && icol < 7
           plot(topdown_data.Datastr.Resample.Sych.IKAngData(:, col_td), 'k-', 'linewidth', lw)
           hold on
           plot(-bottomup_data.Datastr.Resample.Sych.IKAngData(:, col_bu), 'r--', 'linewidth', lw/2)
       else
           plot(topdown_data.Datastr.Resample.Sych.IKAngData(:, col_td), 'k-', 'linewidth', lw)
           hold on
           plot(bottomup_data.Datastr.Resample.Sych.IKAngData(:, col_bu), 'r--', 'linewidth', lw/2)
       end

       title(lumbarJntAngLabel(icol))      
       if icol == ceil(length(lumbarJntAngCol_bu)/4)
           legend(["top down", "bottom up"])
       end
       sgtitle(trial); 
       hold off
   end
   
   for icol = 1:length(lumbarJntTorCol_td)
       col_bu = lumbarJntTorCol_bu(icol);
       col_td = lumbarJntTorCol_td(icol);
       figure(fig2)
       subplot(4, ceil(length(lumbarJntAngCol_bu)/4), icol)
       if icol > 3 && icol < 7
           plot(topdown_data.Datastr.Resample.Sych.IDTrqData(:, col_td), 'k-', 'linewidth', lw)
           hold on
           plot(-bottomup_data.Datastr.Resample.Sych.IDTrqData(:, col_bu), 'r--', 'linewidth', lw/2)
           title(lumbarJntTorLabel(icol))      
       else
           plot(topdown_data.Datastr.Resample.Sych.IDTrqData(:, col_td), 'k-', 'linewidth', lw)
           hold on
           plot(bottomup_data.Datastr.Resample.Sych.IDTrqData(:, col_bu), 'r--', 'linewidth', lw/2)
           title(lumbarJntTorLabel(icol))  
       end
       
       if icol == ceil(length(lumbarJntAngCol_bu)/4)
           legend(["top down", "bottom up"])
       end
       sgtitle(trial);   
       hold off    
   end

end

savefig(fig1, sprintf('AngComp_%s.fig', trial));
savefig(fig2, sprintf('TorComp_%s.fig', trial));


