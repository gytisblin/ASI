load('DownloadListChar.mat')
addpath(genpath('C:\Users\Alex\Desktop\CloudShapeRun\Data'))
notexist = []
for i = 1:length(ASCScintDaysChar)
    for k = 1:length(ASCScintListSortedChar{i})
        disp([num2str(i) '/' num2str(length(ASCScintDaysChar)) ...
            ' ' num2str(k) '/' num2str(length(ASCScintListSortedChar{i}))])
        if ~exist(ASCScintListSortedChar{i}{k})
            print('Not Exist');
            notexist(end+1) = (ASCScintListSortedChar{i}{k});
        end
    end
end
            