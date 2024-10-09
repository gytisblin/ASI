%Creates List of Keog Files
% ftp://optics.gi.alaska.edu/PKR/DASC/RAW/2014/
% ftp://optics.gi.alaska.edu/PKR/DASC/RAW/2015/
% comment in/out SINGLE sections

% clear all;close all;clc;
%% read entire directory from Alaska server, takes ~1-2hours to run
% clearvars -except DayDir_save DayDir
KeogDownloadFilder = 'C:\Users\Alex\Desktop\CloudShapeRun\Data\';
FTPServer = ftp('optics.gi.alaska.edu')%crash here means not connecting to server
rootfolder = 'PKR/DMSP/NCDF';
cd(FTPServer,rootfolder);
addpath(genpath('C:\Users\Alex\Desktop\CloudShapeRun\Data'));
yearfolder = ["2012", "2013", "2014", "2015", "2016", "2017"];
% yearfolder = ["2018", "2019"];
DayDir = {};

set = 0;
c = 1; %counter for day number
for i=1:length(yearfolder)%loop every year
    KeogDir = dir([KeogDownloadFolder num2str(yearfolder(i))]);
    KeogName = [];
    if length(KeogDir) < 3
        empt = 1;
    else
        empt = 0;
        for k = 3:length(KeogDir)
            n = KeogDir(k).name;
            d = n(end-10:end-3);
            d = str2double(d);
            KeogName(end+1) = d;
        end
    end
    cd(FTPServer,yearfolder(i))%go to year subfolder
    YearDir = dir(FTPServer);
    for j=1:length(YearDir)
        try
            n = YearDir(j).name;
            if empt == 0
                d = n(end-10:end-3)
                d = str2double(d);
                x = find(KeogName == d);
                if x == 0
                    mget(FTPServer,YearDir(j).name,[KeogDownloadFolder num2str(yearfolder(i))]);
                end
            else
                mget(FTPServer,YearDir(j).name,[KeogDownloadFolder num2str(yearfolder(i))]);
            end
        catch
            disp('pause');
        end
    end
    cd(FTPServer,'..');
end



