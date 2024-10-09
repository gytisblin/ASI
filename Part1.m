%Part 1

%% Part 1 gets kegram fies names
disp('Running Part 1');
NumDataFiles = 0;%number for nonempty NC files
FigCounter = 0;%number current figures

% Get the sheet names from the scintillation excel sheet
[~, s] = xlsfinfo(ScintSpreadFileName)
SheetName = s(contains(s, ["L1CA", "L2CL"]));
clear s


% Get a list of days that scintillation occurs
ScintRawData = cell(1, length(SheetName));
ScintYears = Years_Running;
ScintDays = cell(1, length(ScintYears));
for S = 1:length(SheetName)
    ScintRawData{S} = readtable(ScintSpreadFileName,'Sheet',SheetName{S}, 'ReadRowNames', 0);%crash here means file wrong name or not in MATLAB path
    year_temp = ScintRawData{S}{:,1};
    doy_temp = ScintRawData{S}{:,2};
    date_temp = datetime(year_temp, 1, doy_temp);
    ScintDays{ScintYears == year_temp(1)} = unique([ScintDays{ScintYears == year_temp(1)}; date_temp]);
end
for i = 1:length(CloudFileYearly)
    str_temp = CloudFileYearly{i};
    year_temp = str2double(str_temp(14:17));
    if sum(ScintYears == year_temp)>0
        date_temp = datetime(str2double(str_temp(14:17)), str2double(str_temp(18:19)), str2double(str_temp(19:20)));
        ScintDays{ScintYears == year_temp} = unique([ScintDays{ScintYears == year_temp(1)}; date_temp]);
    end
end
clear year_temp doy_temp

% Downloads keograms
if run_DownloadKeograms == 1
    disp('Start Downloading Keograms');
    get_keograms(ScintDays, Years_Running, root_dir)
    disp('Finished Downloading Keograms');
end

disp('START generating file name lists...')
DirFileNames = KeogramDirectoryScan(DirNames, data_dir, root_dir); %Gets the file names for all of the files in the year folders
disp('DONE DirFileNames generated')

disp('START scanning for empty NC files...')
j = 0;%counter for full NC files
DataFileNames = {};%nonempty filenames

for i=1:length(DirFileNames)
    DirFileNames{i} %debug
    file_year = str2double(DirFileNames{i}(14:17));
    file_month = str2double(DirFileNames{i}(18:19));
    file_day = str2double(DirFileNames{i}(20:21));
    file_date = datetime(file_year, file_month, file_day);
    if sum(ScintDays{ScintYears == file_year} == file_date) == 1
        hasData = NCDataCheck(DirFileNames{i}); %Checks if the data is in that file
        if(hasData & ~strcmp(DirFileNames{i},ExcludeFile))
            NumDataFiles = NumDataFiles + 1;%tick
            j = j+1;%tick
            DataFileNames{j} = DirFileNames{i};%add names of nonempty, changes the ist t ny incude the fies with data
        end
    end
end

clear j hasdata
NumDirFiles = length(DirFileNames)
NumDataFiles
disp('DONE DataFileNames generated')
clear NumDirFiles NumDataFiles

disp('START calculating sun dip angles...')
[TimeList, TimeSeconds, Zenith, Azimuth, SavedFileNames] = PFSunDipCalc(DataFileNames, run_SunDipCalc);
disp('DONE SunDip generated')

disp('START removing dusk/dawn times (w/ sun dip)...')
[NightFileNames, NightCutoffIndex, NightCutoffTimes, NumNightFiles, NightKeogDates] = PruneDuskDawn(DataFileNames, Zenith, SunDipCutoff, TimeList);
NumNightFiles
clear NumNightFiles
disp('DONE NightFileNames, NightCutoffIndex generated')

disp('START constructing CloudShape')
if strcmp(CloudShapeOption, 'single') %Not used anymore
    [ZCalIntensityL, Zxpic, Zypic, ZAvgIntensity, ZWavelength, ZCloudShapeMaster, ZFFC, Zstd_FFC, ZAvgIntensityFFCZ, Zcv_FFC, ZNormFFC, ZDate, ZTimeList, ZTimeSeconds, ZNcv_cal] = ...
            KeogramRead(CloudFileSingle, [], CloudTimeSingle,TimeCutoffSingle, CutoffAngle, slash, root_dir, data_dir);
    FigCounter = FigCounter+1;
    CloudShapeMaster = ZCloudShapeMaster;
    CloudShapePlot(CloudShapeMaster, CutoffAngle, ZWavelength, CloudFileSingle, FigCounter);
elseif strcmp(CloudShapeOption,'every')
    disp('CloudShapeOption "every" NEED CODE')
elseif strcmp(CloudShapeOption,'yearly')
    %Determines a new calibration every year, if chosen must go through and
    %manually choose the cloudy times to analyze 
    CloudShapeMaster = cell(1, length(Years_Running));
    for i = 1:length(Years_Running)
        Index = strfind(NightFileNames, CloudFileYearly{i});
        Index = find([Index{:}] == 1);
        [ZCalIntensityL, Zxpic, Zypic, ZAvgIntensity, ZWavelength, ZCloudShapeMaster, ZFFC, Zstd_FFC, ZAvgIntensityFFCZ, Zcv_FFC, ZNormFFC, ZDate, ZTimeList, ZTimeSeconds,ZNcv_cal] = ...
            KeogramRead(CloudFileYearly{i}, [],NightCutoffIndex(Index,:), CutoffAngle, root_dir, data_dir); %reads the first Kegram file to get some info
        
        CloudShapeMaster{i} = ZCloudShapeMaster;
    end
     save('CloudShapeMasterYearly.mat', 'CloudShapeMaster')
else
    disp('CloudShapeOption ERROR')
end
clear ZCalIntensityL Zxpic Zypic ZAvgIntensity ZWavelength ZCloudShapeMaster ZFFC Zstd_FFC...
    ZAvgIntensityFFCZ Zcv_FFC ZNormFFC ZDate ZTimeList ZTimeSeconds ZNcv_cal
disp('DONE constructing CloudShape')

disp('START reading keogram files...')
% only read files/times on NightFileNames list, ie those within sundip
% cutoff
Ncv_norm = cell(1, length(NightFileNames));
NCalIntensityL = cell(1, length(NightFileNames));
Nxpic = cell(1, length(NightFileNames));
Nypic = cell(1, length(NightFileNames));
NAvgIntensity = cell(1, length(NightFileNames));
NWavelength = cell(1, length(NightFileNames));
NCloudShape = cell(1, length(NightFileNames));
NFFC = cell(1, length(NightFileNames));
Nstd_FFC = cell(1, length(NightFileNames));
NAvgIntensityFFC = cell(1, length(NightFileNames));
Ncv_FFC = cell(1, length(NightFileNames));
NNormFFC  = cell(1, length(NightFileNames));
NDate = cell(1, length(NightFileNames));
NTimeList = cell(1, length(NightFileNames));
NTimeSeconds = cell(1, length(NightFileNames));
Ncv_cal = cell(1, length(NightFileNames));
if strcmp(CloudShapeOption, 'single')
    for i=1:length(NightFileNames)
        NightFileNames{i}
        [NCalIntensityL{i}, Nxpic{i}, Nypic{i}, NAvgIntensity{i}, NWavelength{i},...
            NCloudShape{i}, NFFC{i}, Nstd_FFC{i}, NAvgIntensityFFC{i}, Ncv_FFC{i}, NNormFFC{i}, NDate{i}, NTimeList{i}, NTimeSeconds{i}, Ncv_cal{i}] = ...
            KeogramRead(NightFileNames{i}, CloudShapeMaster, [], NightCutoffIndex(i,:), CutoffAngle, slash, root_dir, data_dir);
    end
elseif strcmp(CloudShapeOption,'yearly')
    for i=1:length(NightFileNames)
        NightFileNames{i}
        y = NightFileNames{1}(end-10:end-7);
        y = str2num(y);
        [NCalIntensityL{i}, Nxpic{i}, Nypic{i}, NAvgIntensity{i}, NWavelength{i},...
            NCloudShape{i}, NFFC{i}, Nstd_FFC{i}, NAvgIntensityFFC{i}, Ncv_FFC{i},...
            NNormFFC{i}, NDate{i}, NTimeList{i}, NTimeSeconds{i}, Ncv_cal{i}] = ...
            KeogramRead(NightFileNames{i}, CloudShapeMaster{find(Years_Running == y)}, NightCutoffIndex(i,:), CutoffAngle, root_dir, data_dir);
        clear y
    end
else
end
clear NDate Ncv_cal Nstd_FFC NTimeSeconds NCalIntensity NFFC
disp('DONE reading keogram files')

if run_CameraFTP == 1
    disp('Running CameraFTP: Reading the ASC files from the server');
    CameraFTP(NightKeogDates)
    disp('Done Running CameraFTP');
end

save('workspace.mat','-v7.3','-nocompression')
disp('Finished Part 1');