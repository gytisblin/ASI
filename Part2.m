%Part 2

%% Part 2 SCINTIATION FILES
disp('Running Part 2');
load('workspace')
% now refer to scintillation event spreadsheet, done with keogram
% processing

disp('START assigning scintillation event day/night...')
    
for S=1:length(SheetName) %loop through each sheet(S)
    [ScintRawData{S}, ScintData{S}, NumScintEvents(S)] = ScintDayNight(ScintSpreadFileName, SheetName, SunDipCutoff, S);
end
disp('DONE categorizing day/night')
disp('START assigning scintillation/keogram/cloud  parameters...')
for S=1:length(SheetName) %loop through each sheet(S)
    disp(['S=',num2str(S),' sheet ',SheetName{S}])
    NumNightFiles=length(NightKeogDates);
    [ScintData{S}] = ScintKeogramCompare(ScintData{S},NightFileNames,NightCutoffTimes,...
        NumScintEvents(S),NumNightFiles,NTimeList,Ncv_FFC,CVGreenCutoff,CVRedCutoff,...
        NAvgIntensityFFC, AvgIntGreenCutoff);
end
disp('DONE assigning scintillation/keogram/cloud  parameters')

disp('START assigning scintillation event cloud detection...')
disp('DONE categorizing cloud detection')
disp('START saving FullScintResults.xlsx spreadsheet...')
filename = 'FullScintResults.xlsx';
delete (filename);
fclose all;
for S=1:length(SheetName) %loop through each sheet(S)
    if ~isempty(ScintData{S})%only write nonempty sheets
        writetable(ScintData{S}(:,[1:25,33:35]),fullfile(pwd,filename),'Sheet',SheetName{S})
    end
    ScintRawData{S} = readtable(ScintSpreadFileName,'Sheet',SheetName{S});%crash here means file wrong name or not in MATLAB path

end
save('workspace2.mat','-v7.3','-nocompression')
disp('Finished Part 2');