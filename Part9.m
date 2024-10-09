%Part 9
%% Part 9 Determine vera sciniatin categry and update the fuscintresut sheet
disp('Running part 9');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('workspace8.mat')
load('DownloadList.mat')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Loaded!...');
RBRatio_Thresh=1.35
% Designate scintillation events as E/F based on majority of timestamps
for S=1:length(ScintData) %loop through each sheet(S)
    if ~isempty(ScintData{S})%only deal with nonempty types
        [ScintData{S}] = ResultCompare(ScintData{S},NumScintEvents(S));
    end
end

% generate Stats table
% and compare ASC result with ISR in StatsISR
filename = 'Stats.xlsx';
if exist(filename)
    delete ([root_dir '\' filename]);
end
% [Stats{i}, StatsISR{i}, ScintData] = StatGen(ScintData,NumScintEvents,SheetName, prnbtw_lim(i), prnbtw_lim(i+1));
[Stats, StatsISR, ScintData] = StatGen(ScintData,NumScintEvents,SheetName);
writetable(Stats,[root_dir '\' filename],'Sheet','Stats');
writetable(StatsISR,[root_dir '\' filename],'Sheet','StatsISR')


filename = 'FullScintResultsNEW.xlsx';%update master list
if exist(filename)
    delete ([root_dir '\' filename]);
end
VarNames = ScintData{1}.Properties.VariableNames;
ResultsVarNames = {'Year', 'DOY', 'Frequency', 'PRN', 'StartHH', 'StartMM', 'EndHH', 'EndMM',...
    'NumRecieversOpertating', 'PFISR_E_F', 'PFISR_E_F_old', 'StartAz', 'ASI_EFO', 'ASI_EF', 'runningE', ...
    'runningF', 'Category', 'CategoryLong', 'Notes', 'ScintTimeStart', 'ScintTimeEnd', 'ScintLength', ...
    'DipStart', 'DipEnd', 'NightStart', 'NightEnd', 'KeogStart', 'KeogEnd', 'KeogStartIndex', 'KeogEndIndex',...
    'NumCloudFreeMsmts', 'NumCloudFreeIntervals', 'LongestInterval'};
ResultsColind = NaN(1, length(VarNames));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i = 1:length(ResultsVarNames)
%     if strcmp(VarNames, ResultsVarNames{i}) ~= 0
%         ResultsColind(i) = find(strcmp(VarNames, ResultsVarNames{i}));
%     else
%         error(['Data ' ResultsVarNames{i} ' is not in ScintData']);
%     end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ResultsColind=ResultsVarNames
for S=1:length(SheetName) %loop through each sheet(S)
    if ~isempty(ScintData{S})%only write nonempty sheets
%         Table = ScintData{S}(:,ResultsColind);
            Table_data=ScintData{S}
            [NumRows, NumColums]=size(Table_data)
            for r=1:NumRows
           Table(r,1)=Table_data(r,1)
           Table(r,2)=Table_data(r,2)
           Table(r,3)=Table_data(r,3)
           Table(r,4)=Table_data(r,4)
           Table(r,5)=Table_data(r,5)
           Table(r,6)=Table_data(r,6)
           Table(r,7)=Table_data(r,7)
           Table(r,8)=Table_data(r,8)
           Table(r,9)=Table_data(r,9)
           Table(r,10)=Table_data(r,10)
           Table(r,11)=Table_data(r,11)
           Table(r,12)=Table_data(r,12)
           Table(r,13)=Table_data(r,13)
           Table(r,14)=Table_data(r,79)
           Table(r,15)=Table_data(r,80)
            end
        writetable(Table,[root_dir '\' filename],'Sheet',SheetName{S})
    end
    clear Table_data Table NumRows NumColums
end

save('workspace9.mat','-v7.3','-nocompression')
disp('Finished Part 9');