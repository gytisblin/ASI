% downloads list of ASC files from DownloadList.mat (built from scint list
% using CloudShapeCheckFull.m Run after part 4
% server-
% ftp://optics.gi.alaska.edu/PKR/DASC/RAW/2014/
% ftp://optics.gi.alaska.edu/PKR/DASC/RAW/2015/
clear all;close all;clc;

%% code to convert DownloadList.mat -> DownloadListChar.mat
%%%%% convert from strings to char so useable with older MATLAB versions
% COMMENT IN/OUT
numfilesdownloaded = 0;
load('DownloadList.mat')
ASCScintDaysChar = convertStringsToChars(ASCScintDays);
ASCScintListChar = convertStringsToChars(ASCScintList);
ASCScintListSortedChar = cell(length(ASCScintListSorted),1);
for i=1:length(ASCScintListSorted)
    ASCScintListSortedChar{i} = convertStringsToChars(ASCScintListSorted{i});
end
save('DownloadListChar.mat','ASCScintDaysChar','ASCScintListChar','ASCScintListSortedChar')
%%

load('DownloadListChar.mat')
FTPServer = ftp('optics.gi.alaska.edu')%crash here means not connecting to server
rootfolder = 'PKR/DASC/RAW';
cd(FTPServer,rootfolder);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% yearfolder = ['2014';'2015'; '2016'; '2017'; '2018'; '2019'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
yearfolder = ['2014';'2015'; '2016'; '2017'; '2018'];
%scan through ASCScintDaysChar to find last day of 2014
c = 0;
while (strcmp(ASCScintDaysChar{c+1}(1:4),'2014'))
    c = c+1;%set current position as potentila last, keep looping
end
d = c;
while (strcmp(ASCScintDaysChar{d+1}(1:4),'2015'))
    d = d+1;%set current position as potentila last, keep looping
end
e = d;
while (strcmp(ASCScintDaysChar{e+1}(1:4),'2016'))
    e = e+1;
end
f = e;
while (strcmp(ASCScintDaysChar{f+1}(1:4),'2017'))
    f = f+1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% g = f;
% while (strcmp(ASCScintDaysChar{g+1}(1:4),'2018'))
%     g = g+1;
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
g=i
% lastday = max(find(strncmpi(ASCScintDays,"2014",4)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5555
% loopbounds_2019 = [1 c; (c+1) d; (d+1) e; (e+1) f; (f+1) g; (g+1) length(ASCScintDaysChar)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
loopbounds = [1 c; (c+1) d; (d+1) e; (e+1) f; (f+1) g];

% mkdir('ASCDownloadFolder');
addpath(genpath('E:\GNSS_Research\Code\alex_code\scintillation_asi_layer_detection\Code\Data\ASCDownloads'));
% addpath('C:\Users\David\Desktop\MATLAB Work\ASCDownloadFolder');
% addpath('C:\Users\RE-223-9\Documents\FTPWork\Download\ASCDownloadFolder');
not_downloaded = {};
n=0;
for y = 1:size(yearfolder,1)
    y
    cd(FTPServer,yearfolder(y,:))%go to year subfolder
    for i = loopbounds(y,1):loopbounds(y,2)%loopbounds(y,1):loopbounds(y,2)
        i
        ASCScintDaysChar{i}
        cd(FTPServer,ASCScintDaysChar{i})
        
        for k=1:length(ASCScintListSortedChar{i})
            k
            n=n+1
            ASCScintListSortedChar{i}{k}
            %check if file already exists, if it does don't download
            if ~exist(ASCScintListSortedChar{i}{k})
                try
                    mget(FTPServer,ASCScintListSortedChar{i}{k},'ASCDownloadFolder');
                    numfilesdownloaded = numfilesdownloaded + 1;
                    disp('Downlaoded');
                catch
                    disp('Not Downloaded');
                    not_downloaded{end+1} = ASCScintListSortedChar{i}{k};
                end
                
            else
                disp('already downloaded')
            end
        end
        cd(FTPServer,'..');
    end
    cd(FTPServer,'..');
end

disp([num2str(numfilesdownloaded) ' files were downloaded']);

% exist('PKR_DASC_0428_20140101_110338.154.FITS')


