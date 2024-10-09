function [ScintData] = ScintKeogramCompare(ScintData,NightFileNames,NightCutoffTimes,NumScintEvents,NumNightFiles,NTimeList,Ncv_FFC,CVGreenCutoff,CVRedCutoff, NAvgIntensityFFC, AvgIntGreenCutoff)
% add KeogStart & KeogEndTime to ScintData table (that bound the
% scintillation event times)
% if no keog files present or partial categorize as so
if isempty(ScintData)
    disp('Empty sheet.');
    ScintData = [];
    return
end
KeogStart = NaT(NumScintEvents,1);%lots of preallocating
KeogEnd = NaT(NumScintEvents,1);
KeogStartIndex = NaN(NumScintEvents,1);
KeogEndIndex = NaN(NumScintEvents,1);
KeogDateNum = NaN(NumScintEvents,1);
tempCVGreen= cell(NumScintEvents,1);
tempCVRed= cell(NumScintEvents,1);
CloudFree = cell(NumScintEvents,1);
AuroraPresent = cell(NumScintEvents,1);
AuroraBoolean = cell(NumScintEvents,1);
AuroraPresentIndex = cell(NumScintEvents,1);
MinAuroraBoolean = NaN(NumScintEvents,1);
CloudFreeIndex = cell(NumScintEvents,1);
CloudFreeInterval = cell(NumScintEvents,1);
CloudFreeIntervalIndex = cell(NumScintEvents,1);
NumCloudFreeMsmts = NaN(NumScintEvents,1);
NumCloudFreeIntervals = NaN(NumScintEvents,1);
LongestInterval = strings(NumScintEvents,1);
AuroraBoolean = cell(NumScintEvents,1);
LongestIntervalLength = duration(nan(NumScintEvents,3));
ScintData = addvars(ScintData,KeogStart,KeogEnd,KeogStartIndex,KeogEndIndex,KeogDateNum,tempCVGreen,tempCVRed,CloudFree,CloudFreeIndex,...
    CloudFreeInterval,CloudFreeIntervalIndex,NumCloudFreeMsmts,NumCloudFreeIntervals,LongestInterval,LongestIntervalLength, AuroraBoolean, AuroraPresent, AuroraPresentIndex, MinAuroraBoolean);

%first check that each scint event overlaps with keogram times, then find
%exact keogram times/indexs just before+after start+end
%fill in keogstart/keogend time
for i = 1:NumScintEvents
    %loop through each night keogram
    for j=1:NumNightFiles %j tracks keogram NC files by index
        if ((ScintData.ScintTimeEnd(i)<NightCutoffTimes(j,1)) || (ScintData.ScintTimeStart(i)>NightCutoffTimes(j,2)))%no overlap for date, keep looping
            %pop out of loop
        elseif ((ScintData.ScintTimeStart(i)>NightCutoffTimes(j,1)) && (ScintData.ScintTimeEnd(i)<NightCutoffTimes(j,2)))%complete overlap, scint event shorter than keog file
            ScintData.KeogDateNum(i) = j;
            %find keog timestamps & index just before and after scint start/end
            %vast majority of scint events are this
            tempTimeList = NTimeList{j};
            ScintData.KeogStart(i) = max(tempTimeList(tempTimeList<ScintData.ScintTimeStart(i)));
            ScintData.KeogEnd(i) = min(tempTimeList(tempTimeList>ScintData.ScintTimeEnd(i)));
            ScintData.KeogStartIndex(i) = find(tempTimeList==ScintData.KeogStart(i));
            ScintData.KeogEndIndex(i) = find(tempTimeList==ScintData.KeogEnd(i));
            ScintData.CategoryLong(i) = strcat(ScintData.CategoryLong(i),'-K-');
            break
        elseif ((ScintData.ScintTimeStart(i)<NightCutoffTimes(j,1)) && (ScintData.ScintTimeEnd(i)>NightCutoffTimes(j,2)))%complete overlap, scint event longer than keog file
            ScintData.KeogDateNum(i) = j;
            %find keog timestamps and index for domain of keog
            tempTimeList = NTimeList{j};
            ScintData.KeogStart(i) = tempTimeList(1);
            ScintData.KeogEnd(i) = tempTimeList(end);
            ScintData.KeogStartIndex(i) = 1;
            ScintData.KeogEndIndex(i) = length(tempTimeList);
            ScintData.Category(i) = strcat(ScintData.Category(i),'-PK-');
            ScintData.CategoryLong(i) = strcat(ScintData.CategoryLong(i),'-PK-');
            ScintData.Notes(i) = strcat(ScintData.Notes(i),"-keogram only from ",datestr(ScintData.KeogStart(i),'HH:MM:SS')," until ",datestr(ScintData.KeogEnd(i),'HH:MM:SS'));
            break
        elseif ((ScintData.ScintTimeStart(i)<NightCutoffTimes(j,1)) && (ScintData.ScintTimeEnd(i)<NightCutoffTimes(j,2)))%partial overlap, scint event before keog file
            ScintData.KeogDateNum(i) = j;
            %find keog timestamps from start of keog to just after scint end
            tempTimeList = NTimeList{j};
            ScintData.KeogStart(i) = tempTimeList(1);
            ScintData.KeogEnd(i) = min(tempTimeList(tempTimeList>ScintData.ScintTimeEnd(i)));
            ScintData.KeogStartIndex(i) = 1;
            ScintData.KeogEndIndex(i) = find(tempTimeList==ScintData.KeogEnd(i));
            ScintData.Category(i) = strcat(ScintData.Category(i),'-PK-');
            ScintData.CategoryLong(i) = strcat(ScintData.CategoryLong(i),'-PK-');
            ScintData.Notes(i) = strcat(ScintData.Notes(i),"-keogram only from ",datestr(ScintData.KeogStart(i),'HH:MM:SS'));
            break
        elseif ((ScintData.ScintTimeStart(i)>NightCutoffTimes(j,1)) && (ScintData.ScintTimeEnd(i)>NightCutoffTimes(j,2)))%partial overlap, scint event after keog file
            ScintData.KeogDateNum(i) = j;
            %find keog timestamps from just before scint start to keog end
            tempTimeList = NTimeList{j};
            ScintData.KeogStart(i) = max(tempTimeList(tempTimeList<ScintData.ScintTimeStart(i)));
            ScintData.KeogEnd(i) = tempTimeList(end);
            ScintData.KeogStartIndex(i) = find(tempTimeList==ScintData.KeogStart(i));
            ScintData.KeogEndIndex(i) = length(tempTimeList);
            ScintData.Category(i) = strcat(ScintData.Category(i),'-PK-');
            ScintData.CategoryLong(i) = strcat(ScintData.CategoryLong(i),'-PK-');
            ScintData.Notes(i) = strcat(ScintData.Notes(i),"-keogram only until ",datestr(ScintData.KeogEnd(i),'HH:MM:SS'));
            break
        else %logic error, should not happen
            i
            j
            scinttimestart=ScintData.ScintTimeStart(i)
            scinttimeend=ScintData.ScintTimeEnd(i)
            NightCutoffTimesj1=NightCutoffTimes(j,1)
            NightCutoffTimesj2=NightCutoffTimes(j,2)
            error('Logic error in loop comparing keogram and scintillation times');
        end
    end
    %add no keogram category if not found, otherwise find timestamps where
    %CV (cloud detection metric) above threshold
    if isnan(ScintData.KeogDateNum(i))
        ScintData.Category(i) = strcat(ScintData.Category(i),'-NK-');
        ScintData.CategoryLong(i) = strcat(ScintData.CategoryLong(i),'-NK-');
    else
        i
        a=ScintData.KeogDateNum(i)%index of keogram file
        %find segments/timestamps where above thresholds
        %first check green (ch4) threshold, then red (ch5)
        tempCVGreen = Ncv_FFC{ScintData.KeogDateNum(i)}(4,(ScintData.KeogStartIndex(i):ScintData.KeogEndIndex(i)));
        tempAvgIntGreen = NAvgIntensityFFC{ScintData.KeogDateNum(i)}(4, (ScintData.KeogStartIndex(i):ScintData.KeogEndIndex(i)));
        tempCVRed = Ncv_FFC{ScintData.KeogDateNum(i)}(5,(ScintData.KeogStartIndex(i):ScintData.KeogEndIndex(i)));
        ScintData.tempCVGreen{i}=tempCVGreen;
        ScintData.tempCVRed{i}=tempCVRed;
%          CloudFreeBoolean = (tempCVGreen >= CVGreenCutoff) | ((tempCVGreen < CVGreenCutoff) & (tempCVRed >= CVRedCutoff)); %Using red and green 
         CloudFreeBoolean = (tempCVGreen >= CVGreenCutoff); %Using Green CV only
        AuroraBoolean = (tempAvgIntGreen > AvgIntGreenCutoff);
        ScintData.AuroraBoolean{i} = AuroraBoolean;
        darksky = [];
        if min(AuroraBoolean) == 1 %Darksky calculations
            ScintData.CategoryLong(i) = strcat(ScintData.CategoryLong(i),'-LSKY-'); %Light Sky, aurora Present
            darksky = 'no';
        elseif min(AuroraBoolean) == 0
            if sum(AuroraBoolean) == 0
                ScintData.CategoryLong(i) = strcat(ScintData.CategoryLong(i),'-DSKY-'); %Dark Sky, no aurora present
                ScintData.Category(i) = strcat(ScintData.Category(i),'-DSKY-');
                darksky = 'yes';
            elseif sum(AuroraBoolean) ~= 0
                ScintData.CategoryLong(i) = strcat(ScintData.CategoryLong(i),'-PSKY-'); %Partial light/dark sky, there are some instances with and without aurora
                darksky = 'no';
            end
            
        end
        %         ScintData.CloudFree{i} = ((tempCVGreen >= CVGreenCutoff) | ((tempCVGreen < CVGreenCutoff) & (tempCVRed >= CVRedCutoff)));
        %         b=ScintData.KeogStartIndex(i) + find(CloudFreeBoolean) - 1
        %         NotDarkBoolean =
        if strcmp(darksky, 'no') %Dark sky calc
            CloudFreeBoolean = (CloudFreeBoolean+AuroraBoolean) == 2;
% %CloudFree means Cloud Free and Aurora Present DKAR SKY
            ScintData.CloudFreeIndex{i} = ScintData.KeogStartIndex(i) + find(CloudFreeBoolean) - 1;%index of detected cloud-free times
            ScintData.AuroraPresentIndex{i} = ScintData.KeogStartIndex(i) + find(AuroraBoolean) -1;%index of detected Aurora Present times
            ScintData.MinAuroraBoolean(i) = min(AuroraBoolean); %if 0 then there is at least one point where its considered bark time
            tempTimeList = NTimeList{j};
            ScintData.CloudFree{i} = tempTimeList(CloudFreeBoolean);
            ScintData.AuroraPresent{i} = tempTimeList(AuroraBoolean);
            %find periods when cloud free conditions next to each other
            if i==35
                tempCVGreen
                tempCVRed
                CloudFreeBoolean
                ScintData.CloudFreeIndex{i}
            end
            if(length(ScintData.CloudFreeIndex{i})>1)
                p = ScintData.CloudFreeIndex{i}(find(diff(ScintData.CloudFreeIndex{i})==1));%flags cloud free indices  next to each other
                if ~isempty(p)%p is empty if all cloud free times are non-adjacent (ie no continuous periods 2 or more cloud free)
                    q = p + 1;
                    disp(['p=',num2str(p),' q=',num2str(q)])
                    interval = [p(1) q(1)];%start and end indices of cloudfree interval, only tracks current interval
                    for j=1:(length(p)-1)
                        if (q(j) ~= p(j+1))%nonconsecutive numbers, save interval to list then make new one
                            interval = [interval(1) q(j)];
                            ScintData.CloudFreeIntervalIndex{i} = [ScintData.CloudFreeIntervalIndex{i}; interval];
                            interval = [p(j+1) q(j+1)];
                        end
                    end
                    %save last interval to list, special case when empty list
                    if (isempty(ScintData.CloudFreeIntervalIndex{i}))
                        ScintData.CloudFreeIntervalIndex{i} = [interval(1) q(end)];
                        ScintData.CloudFreeInterval{i} = tempTimeList(ScintData.CloudFreeIntervalIndex{i});
                        %                 pretranspose = ScintData.CloudFreeInterval{i}
                        %                 posttranspose = ScintData.CloudFreeInterval{i}'
                        ScintData.CloudFreeInterval{i} = ScintData.CloudFreeInterval{i}';%have to transpose to be uniform
                    else
                        ScintData.CloudFreeIntervalIndex{i} = [ScintData.CloudFreeIntervalIndex{i}; interval];
                        ScintData.CloudFreeInterval{i} = tempTimeList(ScintData.CloudFreeIntervalIndex{i});
                    end
                end
            end
            %assign timestamps to cloudfree intervals
            %         ScintData.CloudFreeInterval{i} = tempTimeList(ScintData.CloudFreeIntervalIndex{i});
            %category stuff/notes
            if isempty(ScintData.CloudFreeIntervalIndex{i})%no cloudfree periods
                ScintData.Category(i) = strcat(ScintData.Category(i),'-C-');
                ScintData.CategoryLong(i) = strcat(ScintData.CategoryLong(i),'-C-');
            elseif((ScintData.CloudFreeIntervalIndex{i}(1,1)==ScintData.KeogStartIndex(i))&&(ScintData.CloudFreeIntervalIndex{i}(end,2)==ScintData.KeogEndIndex(i)))
                %entirelly cloudfree - first/last cloudfree index equals those for scinttime keog
                %             ScintData.Category(i) = strcat(ScintData.Category(i),'-CF-');
                ScintData.Category(i) = strcat(ScintData.Category(i),'-CF-');
                ScintData.CategoryLong(i) = strcat(ScintData.CategoryLong(i),'-CF-');
            else %partial clouds
                ScintData.Category(i) = strcat(ScintData.Category(i),'-PC-');
                ScintData.CategoryLong(i) = strcat(ScintData.CategoryLong(i),'-PC-');
                ScintData.Notes(i) = strcat(ScintData.Notes(i),"-cloud free intervals");
                for j=1:size(ScintData.CloudFreeInterval{i},1)
                    ScintData.Notes(i) = strcat(ScintData.Notes(i)," ",datestr(ScintData.CloudFreeInterval{i}(j,1),'HH:MM:SS')," to ",datestr(ScintData.CloudFreeInterval{i}(j,2),'HH:MM:SS'),",");
                end
                ScintData.Notes(i) = strcat(ScintData.Notes(i),"-");
            end
            ScintData.NumCloudFreeMsmts(i) = length(ScintData.CloudFreeIndex{i});
            ScintData.NumCloudFreeIntervals(i) = size(ScintData.CloudFreeIntervalIndex{i},1);
            %loop through to find longest interval
            if ~isempty(ScintData.CloudFreeInterval{i})%only evaluate if values
                IntervalLengths = ScintData.CloudFreeInterval{i}(:,2)-ScintData.CloudFreeInterval{i}(:,1);
                [ScintData.LongestIntervalLength(i),Index] = max(IntervalLengths);
                ScintData.LongestInterval(i) = strcat(datestr(ScintData.CloudFreeInterval{i}(Index,1),'HH:MM:SS'),"-",datestr(ScintData.CloudFreeInterval{i}(Index,2),'HH:MM:SS'));
            end
        end %Dark sky
    end
end
end