%Creates List of Keog Files
% ftp://optics.gi.alaska.edu/PKR/DASC/RAW/2014/
% ftp://optics.gi.alaska.edu/PKR/DASC/RAW/2015/
% comment in/out SINGLE sections

% clear all;close all;clc;
%% read entire directory from Alaska server, takes ~1-2hours to run
% clearvars -except DayDir_save DayDir
FTPServer = ftp('optics.gi.alaska.edu')%crash here means not connecting to server
rootfolder = 'PKR/DMSP/NCDF';
cd(FTPServer,rootfolder);
yearfolder = ["2014", "2015", "2016", "2017", "2018", "2019"];
% yearfolder = ["2018", "2019"];
DayDir = {};

set = 0;
c = 1; %counter for day number 
for i=1:length(yearfolder)%loop every year
    cd(FTPServer,yearfolder(i))%go to year subfolder
    YearDir = dir(FTPServer);
    for j=1:length(YearDir)
        tried = 0;
        while true
            cd(FTPServer,YearDir(j).name)%Failed to connect to server here at 2018 1022 trying again to run codep('pause');
            if isempty(ans)
                disp('Trying Again');
                FTPServer = ftp('optics.gi.alaska.edu');
                cd(FTPServer,rootfolder);
                cd(FTPServer,yearfolder(i));
                tried = tried + 1;
                if tried == 5
                    break
                end
            else
                DayDir{c} = dir(FTPServer); %directories of day subfolders
                c = c+1
                cd(FTPServer,'..');
                break
            end
        end
    end
    cd(FTPServer,'..');
end

%%

BytesPerImage = DayDir{1}(1).bytes;%same all
KeogFileList = strings;%stores DayDir converted to string vector of ASC filenames
%filenames contain timestamp/freq info, all that are needed

% SingleDayCell = {DayDir{1}.name}';
% ASCFileList = [ASCFileList; convertCharsToStrings(SingleDayCell)];

for i=1:length(DayDir)
    i
    if ~isempty(DayDir{i})%folders rarely empty, only process if not empty
        SingleDayCell = {DayDir{i}.name}';
        if (rem(length(SingleDayCell),3)~=0)
            i
            rem(length(SingleDayCell),3)
            SingleDayCell{1}
        end
        if (i==1)%have to write as new variable
            KeogFileList = convertCharsToStrings(SingleDayCell);
        else
            KeogFileList = [KeogFileList; convertCharsToStrings(SingleDayCell)];%add to existing list
        end
    end
end

save('KeogFileList.mat','BytesPerImage','KeogFileList')

load('KeogFileList.mat') %to open saved file list
% create cell (folder) for each day
% not creating subcells for each freq since already longish time loading
KeogFileListSorted = {};
KeogDays = datetime.empty;%array to store dates present in ASCFileListSorted
TempDatetime = datetime;
skipped_filename = [];
skipped_i = [];
% load('CodeJustInCase.mat');
g = i;
for i=1:length(KeogFileList)
    i
    TempDateStr = KeogFileList(i);
    TempDateStr = strtok(TempDateStr,'.'); %part before .###.FITS
    TempStrParts = strsplit(TempDateStr,'_');%1x5 cell, 3=ch wavelength###, 4=yyyymmdd, 5=HHMMSS
    if numel(TempStrParts) < 5
        disp('ERROR AH');
        skipped_filename(end+1) = KeogFileList(i);
        skipped_i(end+1) = i;
        save('CodeJustInCase');
    else
        TempDatetime = datetime(datevec(TempStrParts{4}, 'yyyymmdd'));
        %if first or new date, create new cell
        if (isempty(KeogDays) || isempty(find(KeogDays==TempDatetime)))
            KeogDays(length(KeogDays)+1) = TempDatetime;%add current date to end of list
            KeogFileListSorted{(length(KeogFileListSorted)+1)} = KeogFileList(i);
        else %add ASC filename to existing cell
            C = find(KeogDays==TempDatetime);%should be single value
            KeogFileListSorted{C}(length(KeogFileListSorted{C})+1) = KeogFileList(i);
        end
    end
end
save('KeogFileList2.mat','BytesPerImage','KeogFileList','KeogFileListSorted','KeogDays')




