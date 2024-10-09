%Part 6
%% Part 6 compare CloudFreeInterval [nx2] against EventASCFiles
disp('Running part 6');
load('workspace5.mat')
load('DownloadList.mat')
disp('Loaded!...');

for S=1:length(ScintData) %loop through each sheet(S)
    S
    if ~isempty(ScintData{S})%only deal with nonempty types
        [ScintData{S}] = ScintASCListOrder2(ScintData{S},NumScintEvents(S));
    end
end
clear NCalIntensityL%save memory now keograms done
clear NFFC
clear NNormFFC
save('workspace6.mat',...
    'ScintData', 'NumScintEvents', 'SheetName', 'root_dir', 'RBRatio_Thresh', ...
    '-v7.3','-nocompression')
disp('Finished Part 6');