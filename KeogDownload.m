% downloads list of Keog files from KeogFileList2.mat
% server-
% ftp://optics.gi.alaska.edu/PKR/DASC/RAW/2014/
% ftp://optics.gi.alaska.edu/PKR/DASC/RAW/2015/
clear all;close all;clc;

%% code to convert DownloadList.mat -> DownloadListChar.mat
%%%%% convert from strings to char so useable with older MATLAB versions
% COMMENT IN/OUT
numfilesdownloaded = 0;
load('KeogFileList2.mat')
KeogDownloadDaysChar = convertStringsToChars(KeogFileListSorted);
save('KeogDownloadListChar.mat','KeogDownloadDaysChar')
%%

load('KeogDownloadListChar.mat')
FTPServer = ftp('optics.gi.alaska.edu')%crash here means not connecting to server
rootfolder = 'PKR/DMSP/RAW';
cd(FTPServer,rootfolder);
yearfolder = ['2014';'2015'; '2016'; '2017'; '2018'; '2019'];

%scan through KeogDownloadDaysChar to find last day of 2014
c = 0;
while (strcmp(KeogDownloadDaysChar{c+1}(1:4),'2014'))
    c = c+1;%set current position as potentila last, keep looping
end
d = c;
while (strcmp(KeogDownloadDaysChar{d+1}(1:4),'2015'))
    d = d+1;%set current position as potentila last, keep looping
end
e = d;
while (strcmp(KeogDownloadDaysChar{e+1}(1:4),'2016'))
    e = e+1;
end
f = e;
while (strcmp(KeogDownloadDaysChar{f+1}(1:4),'2017'))
    f = f+1;
end
g = f;
while (strcmp(KeogDownloadDaysChar{g+1}(1:4),'2018'))
    g = g+1;
end

% lastday = max(find(strncmpi(KeogScintDays,"2014",4)));
loopbounds = [1 c; (c+1) d; (d+1) e; (e+1) f; (f+1) g; (g+1) length(KeogDownloadDaysChar)];

% mkdir('KeogDownloadFolder');
addpath(genpath('C:\Users\Alex\Desktop\CloudShapeRun\Data'));
% addpath('C:\Users\David\Desktop\MATLAB Work\KeogDownloadFolder');
% addpath('C:\Users\RE-223-9\Documents\FTPWork\Download\KeogDownloadFolder');
not_downloaded = {};
n=0;
for y = 1:size(yearfolder,1)
    y
    
    for k=1:length(KeogDownloadDaysChar{i})
        k
        n=n+1
        KeogDownloadDaysChar{i}{k}
        %check if file already exists, if it does don't download
        if ~exist(KeogDownloadDaysChar{i}{k})
            try
                mget(FTPServer,KeogDownloadDaysChar{i}{k},'KeogDownloadFolder');
                numfilesdownloaded = numfilesdownloaded + 1;
                disp('Downlaoded');
            catch
                disp('Not Downloaded');
                not_downloaded{end+1} = KeogDownloadDaysChar{i}{k};
            end
            
        else
            disp('already downloaded')
        end
    end
    cd(FTPServer,'..');
    
    cd(FTPServer,'..');
end

disp([num2str(numfilesdownloaded) ' files were downloaded']);

% exist('PKR_DKeog_0428_20140101_110338.154.FITS')


