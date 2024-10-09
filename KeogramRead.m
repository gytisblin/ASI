function [CalIntensity, xpic, ypic, AvgIntensity, Wavelength, CloudShapeOut, FFC, std_FFC, AvgIntensityFFC, cv_FFC, NormFFC, Date, TimeList, TimeSeconds, cv_cal]...
    = KeogramRead(NCFilename, CloudShapeIn, TimeCutoffIndex, CutoffAngle, root_dir, data_dir)

disp(strcat(NCFilename,'- ','- TimeCutoff-',num2str(TimeCutoffIndex)));

%read NetCDF file
wd = cd;
cd(root_dir)
cd(fullfile(data_dir, NCFilename(end-10:end-7)));
Time  = ncread(NCFilename,'Time');
PeakIntensity  = ncread(NCFilename,'PeakIntensity');
BaseIntensity  = ncread(NCFilename,'BaseIntensity');
Wavelength  = ncread(NCFilename,'Wavelength');
disp('read, now processing...');
cd(wd);

% find location where background values greater than emission keogram
DiffIntensity = PeakIntensity - BaseIntensity;
% cutoffs for start/end, from element TimeMin through TimeMax
if (isempty(TimeCutoffIndex))
    disp('no TimeCutoff using all times')
    TimeMin = 1;
    TimeMax = length(Time);%ie entire set
else %use presets
    disp('preset TimeCutoff cutting times')
    TimeMin = TimeCutoffIndex(1);
    TimeMax = TimeCutoffIndex(2);
end

CountNum = TimeMax - TimeMin + 1;
% find date from filename
TempDateStr = NCFilename;
TempDateStr = strtok(TempDateStr,'.'); %part before .NC
TempDateStr = strtok(flip(TempDateStr),'_'); %reverses, so reads after last_
TempDateStr = flip(TempDateStr); %flips back
Date = datetime(datevec(TempDateStr,'yyyymmdd'));
TimeSeconds = double(Time(TimeMin:TimeMax)); %might not nead this line
TimeList = repmat(Date,CountNum,1) + seconds(Time(TimeMin:TimeMax)); %add/catenate date+sec

AngleLength = 181-2*CutoffAngle; %length of resulting angle dimension
DiffShort = DiffIntensity((CutoffAngle+1):(181-CutoffAngle),:,TimeMin:TimeMax);
CalIntensity = double(DiffShort);
% Rayleighs/Count conversion factor supplied by Don Hampton, placeholder 1s
% for channels were conversion not supplied (freqs aurora light not
% expected)
RayleighsPerCount = [25.4 1 1 6.2 7.8 1];
RayleighsPerCount = repmat(RayleighsPerCount,AngleLength,1,size(CalIntensity,3)); %now create mat for multiplying with CalIntensity
CalIntensity = CalIntensity .* RayleighsPerCount;
CalIntensity(CalIntensity < 0) = 0; %for sanity remove negative

AvgIntensity = squeeze(mean(CalIntensity,1));
xpic = [];
ypic = [];
% Construct 'CloudShape' AngleLengthx6 by averaging times when cloudy
% input times visually identified as cloudy
% average for instant across those times for each channel
% normallizing by avg intensity for each channel for those times
% first normalize by time average (ie Avg Intensity)
NormIntensity = CalIntensity ./ repmat(permute(AvgIntensity,[3 1 2]),AngleLength,1,1);
std_cal = squeeze(std(CalIntensity,0,1));
AvgIntensitycal = squeeze(mean(CalIntensity,1));
cv_cal = std_cal ./ AvgIntensitycal; %TEST INDEX
if (isempty(CloudShapeIn))
    %if null construct cloudshape from within file
    ind4 = cv_cal(4,:) <= 0.15; % only use timepoints with low CV to construct cloudshape
    disp('constructing CloudShape')
    CloudShape = squeeze(mean(NormIntensity(:,:,ind4) ,3));
else
    disp('used existing CloudShape')
    CloudShape = CloudShapeIn;
end
CloudShapeOut = CloudShape; %OUTPUT
CloudMat = repmat(CloudShape,1,1,size(CalIntensity,3));

% Flat Field Correction Technique (standard technique)
FFC = CalIntensity ./ CloudMat;
std_FFC = squeeze(std(FFC,0,1));
AvgIntensityFFC = squeeze(mean(FFC,1));
cv_FFC = std_FFC ./ AvgIntensityFFC; %TEST INDEX
NormFFC = FFC ./ repmat(permute(AvgIntensityFFC,[3 1 2]),AngleLength,1,1);
% for sanity set = 0 for both when AvgIntensity=0 (rather than inf)

cv_FFC(isnan(cv_FFC)) = 0;
% if NCFilename == 'PKR_SMSP_STD_20140101.NC';
%    TEMP_Plotting
%    disp('pause');
% end
NormFFC(isnan(NormFFC)) = 0;
end