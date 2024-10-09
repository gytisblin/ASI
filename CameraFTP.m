% file to download ASC RAW .FITS files from Don Hampton's FTP server
% ftp://optics.gi.alaska.edu/PKR/DASC/RAW/2014/
% ftp://optics.gi.alaska.edu/PKR/DASC/RAW/2015/
% comment in/out SINGLE sections

% clear all;close all;clc;
%% read entire directory from Alaska server, takes ~1-2hours to run
% clearvars -except DayDir_save DayDir
function [] = CameraFTP(NightKeogDates)
FTPServer = ftp('optics.gi.alaska.edu')%crash here means not connecting to server
rootfolder = 'PKR/DASC/RAW';
cd(FTPServer,rootfolder);
years = unique(year(NightKeogDates));
yearfolder = strings(1, length(years));
for i = 1:length(yearfolder)
    yearfolder(i) = num2str(years(i))
end
DownloadDayes = cell(1, length(yearfolder));
days = day(NightKeogDates);
% for i = 1:length(yearfolder)
%     zd = strings(1, sum(year(NightKeogDates) == years(i)));
%     zm = zd;
%     zd(days(year(NightKeogDates) == years(i))>9) = '';
%     zd(days(year(NightKeogDates) == years(i))<10) = '0';
%     zm(days(year(NightKeogDates) == years(i))>9) = '';
%     zm(days(year(NightKeogDates) == years(i))<10) = '0';
%     DownloadDays{i} = strcat(num2str(years(year(NightKeogDates) == years(i))), zm, num2str(month(year(NightKeogDates) == years(i))), zd, num2str(days(year(NightKeogDates) == years(i))));
% end


    
    for k = 1:length(NightKeogDates)
        k_date=NightKeogDates(k)
        
        [y,m,d]=ymd(k_date)
        ynew=num2str(y)
        if m<10
            zerostring=num2str(0)
            mstring=num2str(m)
            mnew=strcat(zerostring,mstring)
        else
            mnew=num2str(m)
        end
        if d<10
            zerostring=num2str(0)
            dstring=num2str(d)
            dnew=strcat(zerostring,dstring)
           
        else
            dnew=num2str(d)
        end
        try
           
            filename=strcat(ynew,mnew,dnew);
            DownloadDays{k}=filename
        end
    end





DayDir = {};
set = 0;
c = 1; %counter for day number 
% for i=1:length(yearfolder)%loop every year
%     cd(FTPServer,yearfolder(i))%go to year subfolder
% %     YearDir = dir(FTPServer);
% if i==1
%     w=1
%     q=80
% elseif i==2
%     w=81
%     q=142
% elseif i==3
%     w=143
%     q=179
% elseif i==4
%     w=180
%     q=198
% elseif i==5
%     w=199
%     q=229
%     
% end
%     for j=w:q
%         tried = 0;
%         while true
%             value=DownloadDays{j}
%             try
%             cd(FTPServer,DownloadDays{j})%Failed to connect to server here at 2018 1022 trying again to run codep('pause');
%             catch
%                 disp('pause');
%             end
%             
%             if isempty(ans)
%                 disp('Trying Again');
%                 FTPServer = ftp('optics.gi.alaska.edu');
%                 cd(FTPServer,rootfolder);
%                 cd(FTPServer,yearfolder(i));
%                 tried = tried + 1;
%                 if tried == 5
%                     break
%                 end
%             else
%                 DayDir{c} = dir(FTPServer); %directories of day subfolders
%                 if i==1
%                     c = c+1
%                 elseif i==2
%                     c = c+1
%                 elseif i==3
%                     c = c+1
%                 elseif i==4
%                     c = c+1
%                 elseif i==5
%                     c = c+1
%                 end
%                 cd(FTPServer,'..');
%                 break
%             end
%         end
%     end
%     cd(FTPServer,'..');
% end

%%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% yearfolder = ["2014", "2015", "2016", "2017", "2018"]
% for i=1:length(yearfolder)%loop every year
%     cd(FTPServer,yearfolder(i))%go to year subfolder
%     YearDir = dir(FTPServer);
%     for j=1:length(YearDir)
%         tried = 0;
%         while true
%             cd(FTPServer,YearDir(j).name)%Failed to connect to server here at 2018 1022 trying again to run codep('pause');
%             if isempty(ans)
%                 disp('Trying Again');
%                 FTPServer = ftp('optics.gi.alaska.edu');
%                 cd(FTPServer,rootfolder);
%                 cd(FTPServer,yearfolder(i));
%                 tried = tried + 1;
%                 if tried == 5
%                     break
%                 end
%             else
%                 DayDir{c} = dir(FTPServer); %directories of day subfolders
%                 c = c+1
%                 cd(FTPServer,'..');
%                 break
%             end
%         end
%     end
%     cd(FTPServer,'..');
% end
% 
% 
% 
% 
% 
% 
% 
% BytesPerImage = DayDir{1}(1).bytes;%same all
% ASCFileList = strings;%stores DayDir converted to string vector of ASC filenames
% %filenames contain timestamp/freq info, all that are needed
% 
% % SingleDayCell = {DayDir{1}.name}';
% % ASCFileList = [ASCFileList; convertCharsToStrings(SingleDayCell)];
% 
% for i=1:length(DayDir)
%     i
%     if ~isempty(DayDir{i})%folders rarely empty, only process if not empty
%         SingleDayCell = {DayDir{i}.name}';
%         if (rem(length(SingleDayCell),3)~=0)
%             i
%             rem(length(SingleDayCell),3)
%             SingleDayCell{1}
%         end
%         if (i==1)%have to write as new variable
%             ASCFileList = convertCharsToStrings(SingleDayCell);
%         else
%             ASCFileList = [ASCFileList; convertCharsToStrings(SingleDayCell)];%add to existing list
%         end
%     end
% end
% 
% save('ASCFileList.mat','BytesPerImage','ASCFileList')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
load('ASCFileList.mat') %to open saved file list
% create cell (folder) for each day
% not creating subcells for each freq since already longish time loading
ASCFileListSorted = {};
ASCDays = datetime.empty;%array to store dates present in ASCFileListSorted
TempDatetime = datetime;
skipped_filename = [];
skipped_i = [];
% load('CodeJustInCase.mat');
g = i;
for i=1:length(ASCFileList)
    i
    TempDateStr = ASCFileList(i);
    TempDateStr = strtok(TempDateStr,'.'); %part before .###.FITS
    TempStrParts = strsplit(TempDateStr,'_');%1x5 cell, 3=ch wavelength###, 4=yyyymmdd, 5=HHMMSS
    if numel(TempStrParts) < 5
        disp('ERROR AH');
        skipped_filename(end+1) = ASCFileList(i);
        skipped_i(end+1) = i;
        save('CodeJustInCase');
    else
        TempDatetime = datetime(datevec(TempStrParts{4}, 'yyyymmdd'));
        %if first or new date, create new cell
        if (isempty(ASCDays) || isempty(find(ASCDays==TempDatetime)))
            ASCDays(length(ASCDays)+1) = TempDatetime;%add current date to end of list
            ASCFileListSorted{(length(ASCFileListSorted)+1)} = ASCFileList(i);
        else %add ASC filename to existing cell
            C = find(ASCDays==TempDatetime);%should be single value
            ASCFileListSorted{C}(length(ASCFileListSorted{C})+1) = ASCFileList(i);
        end
    end
end
save('ASCFileList2.mat','BytesPerImage','ASCFileList','ASCFileListSorted','ASCDays')
end




