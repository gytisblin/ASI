%Main Running Code
root_dir = ''
data_dir = fullfile(root_dir, 'Data');
addpath(genpath(root_dir));
% % % % % cd(fullfile(root_dir, 'Code'));

% CHANGELOG:
% V5:Used for AGU Conference (12/19)
% V7:Version used for MS Thesis (4/20/20)
% V8:Added refinements for exact comparison to ASI vs PFISR (5/7/20)
% V9:pixel region,ASI designation with B direction (5/16/20)
% V10: Updated keogram cloud detection method, use 9 pixel average for ASI
% layer RB Ratio, updated PFISR Filtered data

%Set which parts to run
% run_array = [0 1 2 3 4 5 6 7 8 9 10 11 12]; %If you want to run all parts through including setting the settings
tic
run_array = [0 1 2 3 4 5 6 7 8 9];
run_array = [4 5 6 7 8 9];
% run_array = [0 8];
for i = 1:length(run_array)
    %% Set These Values Before Running
    run_array = [0 1 2 3 4 5 6 7 8 9];
    run_array = [4 5 6 7 8 9];
%     run_array = [0 8];
    run_SunDipCalc = 0; %if = 1 calculates the sun dip angles (needed if running with new data/for the first time) otherwise if data has already been ran set to 0
    run_DownloadKeograms = 0; %if = 1 will download the keograms, if running for the first time = 1 otherwise = 0
    run_CameraFTP = 0;
    flag = run_array(i);
    switch flag
        case 0
            Part0;
        case 1
            Part1;
        case 2
            Part2;
        case 3
            Part3;
        case 4
            Part4;
        case 5
            Part5;
        case 6
            Part6;
        case 7
            Part7;
        case 8
            Part8;
        case 9
            Part9;
       
    end
end
toc