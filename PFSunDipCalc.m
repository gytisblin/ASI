function [TimeList, TimeSeconds, Zenith, Azimuth, SavedFileNames] = PFSunDipCalc(FileNames, run_SunDipCalc)
flag = run_SunDipCalc;
switch flag
    case 0
% check saved SunAngles matches current ones
SavedFileStruct = load('SunAngles.mat','DataFileNames');
SavedFileNames = SavedFileStruct.DataFileNames;
if (isequal(SavedFileNames, FileNames))
    load('SunAngles.mat');
    disp('Loaded saved sun dip angles in SunAngles.mat')
else
    error('ERROR - saved dates in SunAngles.mat do not match workspace')
end

save('SunAngles.mat','TimeList','TimeSeconds','Azimuth','Zenith','DataFileNames')

    case 1
%% comment in this section to regenerate sun dip angles (takes ~20min)
location.longitude = -147.45; %negative = W
location.latitude = 65.12; %positive = N
location.altitude = 497; %meters

for i=1:length(FileNames)
    disp(FileNames{i});
    Time{i} = ncread(FileNames{i},'Time');
    TimeMin = 1;
    TimeMax = length(Time{i});
    CountNum = TimeMax - TimeMin + 1;
    %     find date from filename
    TempDateStr = FileNames{i};
    TempDateStr = strtok(TempDateStr,'.'); %part before .NC
    TempDateStr = strtok(flip(TempDateStr),'_'); %reverses, so reads after last_
    TempDateStr = flip(TempDateStr); %flips back
    Date = datetime(datevec(TempDateStr,'yyyymmdd'));
    TimeSeconds{i} = double(Time{i}(TimeMin:TimeMax)); %might not nead this line
    TimeList{i} = repmat(Date,CountNum,1) + seconds(Time{i}(TimeMin:TimeMax)); %add/catenate date+sec
    
    Zenith{i} = zeros(1,TimeMax); %preallocate
    Azimuth{i} = zeros(1,TimeMax);
    for j=1:TimeMax
        tempPosition = sun_position_sdb(datestr(TimeList{i}(j)), location);
        Zenith{i}(j) = tempPosition.zenith;
        Azimuth{i}(j) = tempPosition.azimuth;
    end
end
DataFileNames = FileNames;
SavedFileNames = DataFileNames;
if exist('SunAngles.mat')
    save('SunAngles.mat','TimeList','TimeSeconds','Azimuth','Zenith','DataFileNames', '-append');
else
    save('SunAngles.mat','TimeList','TimeSeconds','Azimuth','Zenith','DataFileNames');
end
end
end