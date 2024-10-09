%Part 3
%% Part 3 gets ASC fies that correspnd to the scint events
disp('Running Part 3');
load('workspace2.mat')

disp('START generating list of ASC files per scint event...')

 load('ASCFileList2.mat')
load('ASCFileList.mat')
ASCDownloadList = strings;%list of ASC files to download based on all scint events/types
% extract timestamps from filenames as number HHMMSS (UT)
ASCFileListSortedTime = {};
for i=1:length(ASCFileListSorted)
    i;
    TempTimeStr = ASCFileListSorted{i};
    TempTimeStr = strtok(TempTimeStr,'.'); %part before .###.FITS
    TempStrParts = split(TempTimeStr,'_');%1xNimagesx5 array, (1,N,5)=HHMMSS for each image
    ASCFileListSortedTime{i} = str2double(TempStrParts(:,:,5));
end
save('workspace3.mat',...
    'ScintData', 'NumScintEvents', 'SheetName', 'root_dir', 'ASCDays' , 'ASCFileListSortedTime',...
    'ASCFileListSorted', 'data_dir', 'RBRatio_Thresh',...
    '-v7.3','-nocompression')
disp('Finished Part 3');