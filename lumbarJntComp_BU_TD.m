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
trialNames = ["walk_36", "run_81", "squat"];
lumbarJntAngCol_bu = [8, 9, 10];
lumbarJntAngCol_td = [22, 23, 24];
lumbarJntAngLabel = ["Lumbar-extension-Ang", "Lumbar-bending-Ang", "Lumbar-rotation-Ang"];
lumbarJntTorCol_bu = [8, 9, 10];
lumbarJntTorCol_td = [14, 15, 16];
lumbarJntTorLabel = ["Lumbar-extension-Tor", "Lumbar-bending-Tor", "Lumbar-rotation-Tor"];

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
       subplot(length(lumbarJntAngCol_bu), length(trialNames), (icol-1)*length(trialNames) + itrial)
       plot(topdown_data.Datastr.Resample.Sych.IKAngData(:, col_td), 'k-', 'linewidth', lw)
       hold on
       plot(-bottomup_data.Datastr.Resample.Sych.IKAngData(:, col_bu), 'r--', 'linewidth', lw/2)
       if itrial == 1
           ylabel(lumbarJntAngLabel(icol))
       end
       if icol == 1
           title(trialNames(itrial))
       end
       
       if itrial == length(trialNames) && icol == 1
           legend(["top down", "bottom up"])
       end
       
       hold off
   end
   
   for icol = 1:length(lumbarJntTorCol_td)
       col_bu = lumbarJntTorCol_bu(icol);
       col_td = lumbarJntTorCol_td(icol);
       figure(fig2)
       subplot(length(lumbarJntTorCol_td), length(trialNames), (icol-1)*length(trialNames) + itrial)
       plot(topdown_data.Datastr.Resample.Sych.IDTrqData(:, col_td), 'k-', 'linewidth', lw)
       hold on
       plot(-bottomup_data.Datastr.Resample.Sych.IDTrqData(:, col_bu), 'r--', 'linewidth', lw/2)
       hold off
       if itrial == 1
           ylabel(lumbarJntTorLabel(icol))
       end
       if icol == 1
           title(trialNames(itrial))
       end
       
      if itrial == length(trialNames) && icol == 1
           legend(["top down", "bottom up"])
       end
       
   end

end


