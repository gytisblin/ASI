% script scans inputed directories and returns list of files in each
% for comparing years worth of keograms
% options for checking completeness of files found without reading files
function [FileNames]= KeogramDirectoryScan(DirNames, data_dir, root_dir)

% INPUT DirNames = char vector cell array of folder names, 
% ie DirNames = {'2014'; '2015'}
% OUTPUT FileNames = char vector cell array of all filenames .NC (1D not 2D)
FileNames = [];
wd = cd; 
cd(root_dir);
cd(data_dir);
for i = 1:length(DirNames)
    FileInfo = dir(fullfile(DirNames{i},'*.NC'));
    FileName = {FileInfo.name};
    FileNames = [FileNames FileName];
end
cd(wd)
end
