%Part 4
%% Part 4 Made a list of ASC that correspond to the scint events
disp('Running Part 4');
load('workspace3.mat')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for S=1:length(ScintData) %loop through each sheet(S)
    if ~isempty(ScintData{S})%only deal with nonempty types
        [ScintData{S}] = ScintASCListGen(ScintData{S},NumScintEvents(S),ASCDays,ASCFileListSortedTime,ASCFileListSorted);
    end
end

for S = 1:length(ScintData)
    S
    if ~isempty(ScintData{S})
        [ScintData{S}] = PRNAnglebtw(ScintData{S}, NumScintEvents(S), data_dir);
    end
end

filename = 'FullScintResults.xlsx';

save('scint_data_part_4.mat','ScintData')

[ASCScintList, ASCScintListSorted, ASCScintDays] = ASCCombine(ScintData,NumScintEvents);
save('DownloadList.mat','ASCScintList','ASCScintDays','ASCScintListSorted')
disp('DONE generating list of ASC files per scint event')
save('workspace4.mat',...
    'ScintData', 'NumScintEvents', 'SheetName', 'root_dir', 'RBRatio_Thresh', ...
    '-v7.3','-nocompression')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Adding code to move the download list to the download folder and check if we have all of the files downloaded, if not run the script to downlaod files
load('DownloadList.mat')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
copyfile([pwd '\DownloadList.mat'], [pwd '\ASCDownloads\Download\DownloadList.mat']);
FileNames = [];
wd = cd; 
cd(root_dir);
cd(data_dir);
ASCScintList_temp = strings();
ASCScintListSorted_temp = cell(1,1228)
ASCScintDays_temp = strings();
Files = dir(fullfile('ASCDownloadFolder','*.FITS'));

wd=cd
cd(wd)

if ~isempty(ASCScintList)
    DownloadASCModified;
end

disp('Finished Part 4');