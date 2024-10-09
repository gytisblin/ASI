%Part 5
%% Part 5 Cmpares the cloud free times with scinilation events to generate a list of needed ASC time images
disp('Runnning part 5');
load('workspace4.mat')
load('DownloadList.mat')
disp('Loaded!...');

% clean up ASC image lists for each scintillating time
for S=1:length(ScintData) %loop through each sheet(S)
    if ~isempty(ScintData{S})%only deal with nonempty types
        [ScintData{S}] = ScintASCListOrder(ScintData{S},NumScintEvents(S));
    end
end
save('workspace5.mat',...
    'ScintData', 'NumScintEvents', 'SheetName', 'root_dir', 'RBRatio_Thresh', ...
    '-v7.3','-nocompression')
disp('Finished Part 5');