%Part 7
%% Part 7 construct triplet ordered nx3 FITS and datetime arrays for each scintillation, ie complete triplet found within cloud free intervals

disp('Running part 7');
load('workspace6.mat')
disp('Loaded!...');
for S=1:length(ScintData) %loop through each sheet(S)
    S
    if ~isempty(ScintData{S})%only deal with nonempty types
        [ScintData{S}] = ScintASCListOrder3(ScintData{S},NumScintEvents(S));
    end
end
save('workspace7.mat',...
    'ScintData', 'NumScintEvents', 'SheetName', 'root_dir', 'RBRatio_Thresh', ...
    '-v7.3','-nocompression')
disp('Finished Part 7');