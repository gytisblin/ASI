function [ScintData] = ScintASCListOrder2(ScintData, NumScintEvents)
% compare CloudFreeInterval [nx2] against EventASCFiles
% generate list of EventASCTimes
% for each n save FITS filenames in G/B/RASCsort

% first get HHMMSS timestamp for start/end of each scint event (same format
% as ASCFileListSortedTime)
% StartTimeNum = str2double(convertCharsToStrings(cellstr(datestr(ScintData.ScintTimeStart,'HHMMSS'))));
% EndTimeNum = str2double(convertCharsToStrings(cellstr(datestr(ScintData.ScintTimeEnd,'HHMMSS'))));
% EventASCTime = cell(NumScintEvents,1);
GASCSort = cell(NumScintEvents,1);
BASCSort = cell(NumScintEvents,1);
RASCSort = cell(NumScintEvents,1);
GASCprnbtw = cell(NumScintEvents,1);
BASCprnbtw = cell(NumScintEvents,1);
RASCprnbtw = cell(NumScintEvents,1);
GASCazel = cell(NumScintEvents,1);
BASCazel = cell(NumScintEvents,1);
RASCazel = cell(NumScintEvents,1);
GTimeSort = cell(NumScintEvents,1);
BTimeSort = cell(NumScintEvents,1);
RTimeSort = cell(NumScintEvents,1);
ScintData = addvars(ScintData,GTimeSort,BTimeSort,RTimeSort, GASCprnbtw, RASCprnbtw, BASCprnbtw, GASCazel, BASCazel, RASCazel);

ASCDayIndex = 0;%preallocate
ASCImageIndex = 0;
StartNum = 0;
EndNum = 0;
SnapTime = NaT;
FreqStr = "";
TempStr = strings(5,1);
CloudFreeInterval = {};
doneflag = 0;
numinterval = 0;
currinterval = 0;
Filename = "";
g=0;
b=0;
r=0;

for i=1:NumScintEvents%min([NumScintEvents 30])
    GASCSort = string.empty;
    BASCSort = string.empty;
    RASCSort = string.empty;
    GASCprnbtw = [0];
    BASCprnbtw = [0];
    RASCprnbtw = [0];
    GASCazel = [0 0];
    RASCazel = [0 0];
    BASCazel = [0 0];
    GTimeSort = datetime.empty;
    BTimeSort = datetime.empty;
    RTimeSort = datetime.empty;
    g=0;
    b=0;
    r=0;
    
    if(~isempty(ScintData.CloudFreeInterval{i}))
        if(~isempty(ScintData.EventASCFiles{i}))
            %             EventASCTime = NaT(length(ScintData.EventASCFiles{i}), 1);
            CloudFreeInterval = ScintData.CloudFreeInterval{i} %nx2 datetime
            numinterval = size(CloudFreeInterval,1)
            for n=1:length(ScintData.EventASCFiles{i})
                i
                n
                Filename = ScintData.EventASCFiles{i}(n)
                prnbtw = ScintData.prnbtw{i}(n);
                if isempty(prnbtw{1})
                    prnbtw = {NaN};
                end
                azel = ScintData.prnazel{i}(n);
                if isempty(azel{1})
                    azel = {NaN NaN};
                end
                SnapTime = ScintData.EventASCTime{i}(n)
                %loop for number of cloud free intervals
                doneflag = 0;
                currinterval = 1;
                while((currinterval<=numinterval) && (~doneflag))
                    currinterval
                    numinterval
                    if((CloudFreeInterval(currinterval,1)<=SnapTime) && (CloudFreeInterval(currinterval,2)>=SnapTime))
                        %                         place in appropriate folder based on wavelength
                        hit='good'
                        %                         if isempty(GASCSort)
                        %                             GASCSort = "";
                        %                             BASCSort = "";
                        %                             RASCSort = "";
                        %                         end
                        TempStr = split(Filename,'_');
                        FreqStr = TempStr(3)
                        if (strcmp(FreqStr,"0558"))
                            g=g+1;
                            GASCSort(g,1) = Filename;
                            GASCprnbtw(g,1) = prnbtw{1};
                            GASCazel(g,:) = azel{1};
                            GTimeSort(g,1) = SnapTime;
                        elseif (strcmp(FreqStr,"0428"))
                            b=b+1;
                            BASCSort(b,1) = Filename;
                            BASCprnbtw(b,1) = prnbtw{1};
                            BASCazel(b,:) = azel{1};
                            BTimeSort(b,1) = SnapTime;
                        elseif (strcmp(FreqStr,"0630"))
                            r=r+1;
                            RASCSort(r,1) = Filename;
                            RASCprnbtw(r,1) = prnbtw{1};
                            RASCazel(r,:) = azel{1};
                            RTimeSort(r,1) = SnapTime;
                        else
                            Filename
                            FreqStr
                            error('Error determining .FITS wavelength')
                        end
                        doneflag = 1;
                    end
                    currinterval = currinterval+1;
                    %if it finished looping and none are in , BASCSort etc
                    %remain empty
                end
                
            end
        end
    end
    
    %     ScintData.EventASCTime{i} = EventASCTime;
    ScintData.GASCSort{i} = GASCSort;
    ScintData.BASCSort{i} = BASCSort;
    ScintData.RASCSort{i} = RASCSort;
    ScintData.GASCprnbtw{i} = GASCprnbtw;
    ScintData.BASCprnbtw{i} = BASCprnbtw;
    ScintData.RASCprnbtw{i} = RASCprnbtw;
    ScintData.GASCazel{i} = GASCazel;
    ScintData.RASCazel{i} = RASCazel;
    ScintData.BASCazel{i} = BASCazel;
    ScintData.GTimeSort{i} = GTimeSort;
    ScintData.BTimeSort{i} = BTimeSort;
    ScintData.RTimeSort{i} = RTimeSort;
end
end