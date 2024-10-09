function [ScintData] = ScintASCListOrder(ScintData, NumScintEvents)
% compare CloudFreeInterval [nx2] against EventASCFiles
% generate list of EventASCTimes
% for each n save FITS filenames in G/B/RASCsort

% first get HHMMSS timestamp for start/end of each scint event (same format
% as ASCFileListSortedTime)
% StartTimeNum = str2double(convertCharsToStrings(cellstr(datestr(ScintData.ScintTimeStart,'HHMMSS'))));
% EndTimeNum = str2double(convertCharsToStrings(cellstr(datestr(ScintData.ScintTimeEnd,'HHMMSS'))));
EventASCTime = cell(NumScintEvents,1);
GASCSort = cell(NumScintEvents,1);
BASCSort = cell(NumScintEvents,1);
RASCSort = cell(NumScintEvents,1);
ScintData = addvars(ScintData,EventASCTime,GASCSort,BASCSort,RASCSort);

ASCDayIndex = 0;%preallocate
ASCImageIndex = 0;
StartNum = 0;
EndNum = 0;
for i=1:NumScintEvents
    GASCSort = [];
    BASCSort = [];
    RASCSort = [];
    EventASCTime = [];
    
    if(~isempty(ScintData.CloudFreeInterval))
        if(~isempty(ScintData.EventASCFiles))
            EventASCTime = NaT(length(ScintData.EventASCFiles{i}), 1);
            for n=1:length(ScintData.EventASCFiles{i})
                i
                n
                TempTimeStr = ScintData.EventASCFiles{i}(n);
                TempTimeStr = strtok(TempTimeStr,'.'); %part before .###.FITS
                TempStrParts = split(TempTimeStr,'_');%1xNimagesx5 array, (1,N,5)=HHMMSS for each image
                casetimestring = (strcat(TempStrParts(4),TempStrParts(5)));
                % end
                casetimevec=datevec(casetimestring,'yyyymmddHHMMSS');
                temp = datetime(casetimevec);
                EventASCTime(n) = datetime(casetimevec);
            end
        end
    end
    
    ScintData.EventASCTime{i} = EventASCTime;
    ScintData.GASCSort{i} = GASCSort;
    ScintData.BASCSort{i} = BASCSort;
    ScintData.RASCSort{i} = RASCSort;
end
end