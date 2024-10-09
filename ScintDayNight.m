function [ScintRawData, ScintData, NumScintEvents] = ScintDayNight(ScintSpreadFileName, SheetName, SunDipCutoff, SheetNum)
% ScintData is table that returns results
ScintRawData = readtable(ScintSpreadFileName,'Sheet',SheetName{SheetNum}, 'ReadVariableNames', false);%crash here means file wrong name or not in MATLAB path
if isempty(ScintRawData)
    disp(strcat(SheetName{SheetNum},' is empty sheet.'));
    ScintData = [];
    NumScintEvents = 0;
    return
end
SheetName{SheetNum}
%     ScintData = removevars(ScintRawData,{'Case_','Frequency','ASC_E_F_','azimuth','elevation','v'});%old method, switched to adding desired as safer
%     VarList={'Year','DOY','Frequency','PRN','StartHH','StartMM','EndHH','EndMM','WeightedScintillationNumber','PFISR_E_F_','revisedPFISR'};
VarList = {'Year','DOY','Frequency','PRN','StartHH','StartMM','EndHH','EndMM','NumReceiversOperating', 'PFISR_E_F', 'PFISR_E_F_old'};
ScintRawData.Properties.VariableNames = VarList;
ScintData = ScintRawData(:,VarList);%choose only desired variables
NumScintEvents = height(ScintRawData); %number of scintillation events
disp(['NumScintEvents = ' num2str(NumScintEvents)]);
Category = strings(NumScintEvents,1);
CategoryLong = strings(NumScintEvents,1);
Notes = strings(NumScintEvents,1);
ScintData = addvars(ScintData,Category,CategoryLong,Notes);

ScintTimeStart = datetime(num2str(ScintData.Year),'InputFormat','yyyy')+days(ScintData.DOY-1)+hours(ScintData.StartHH)+minutes(ScintData.StartMM);%subtract 1 day since DOY 1 = start of year +0days
ScintTimeEnd = datetime(num2str(ScintData.Year),'InputFormat','yyyy')+days(ScintData.DOY-1)+hours(ScintData.EndHH)+minutes(ScintData.EndMM);
ScintTimeEnd(find(ScintTimeEnd < ScintTimeStart)) = ScintTimeEnd(find(ScintTimeEnd < ScintTimeStart)) + days(1);
ScintLength = ScintTimeEnd - ScintTimeStart;
ScintData = addvars(ScintData,ScintTimeStart,ScintTimeEnd,ScintLength);

%% debugg to check loops
%     ScintData.ScintTimeStart(1) = datetime(num2str(2015),'InputFormat','yyyy')+days(75)+hours(4)+minutes(35);
%     ScintData.ScintTimeEnd(2) = datetime(num2str(2015),'InputFormat','yyyy')+days(75)+hours(23)+minutes(35);
%     ScintData.ScintTimeStart(3) = datetime(num2str(2015),'InputFormat','yyyy')+days(75)+hours(4)+minutes(35);
%     ScintData.ScintTimeEnd(3) = datetime(num2str(2015),'InputFormat','yyyy')+days(75)+hours(23)+minutes(35);

%     calculate dip angle for start&end of each scintillation
location.longitude = -147.45; %negative = W
location.latitude = 65.12; %positive = N
location.altitude = 497; %meters

DipStart = zeros(NumScintEvents,1);%preallocate
DipEnd = zeros(NumScintEvents,1);
NightStart = NaT(NumScintEvents,1);
NightEnd = NaT(NumScintEvents,1);
for i=1:NumScintEvents
    %         find dip angle both start and end
    ds = datestr(ScintData.ScintTimeStart(i))
    de = datestr(ScintData.ScintTimeEnd(i));
    tempPosition = sun_position_sdb(ds, location);
    DipStart(i) = tempPosition.zenith;
    tempPosition = sun_position_sdb(de, location);
    DipEnd(i) = tempPosition.zenith;
    %         now check if both start & end within cutoff
    %         (zenith >= 90 + anglebelowhorizon)
    if((DipStart(i)>=90+SunDipCutoff) && (DipEnd(i)>=90+SunDipCutoff))%both start&end within cutoff, entire scint time good
        ScintData.CategoryLong(i) = strcat(CategoryLong(i),"-N-");
        NightStart(i) = ScintData.ScintTimeStart(i);
        NightEnd(i) = ScintData.ScintTimeEnd(i);
    elseif(DipStart(i)>=90+SunDipCutoff) %ie only start within cutoff, go minute by minute to find endpoint
        %             disp(strcat('i=',num2str(i),' start=',datestr(ScintData.ScintTimeStart(i)),' end=',datestr(ScintData.ScintTimeEnd(i))))
        tempTime = ScintData.ScintTimeStart(i);
        while (tempTime<ScintData.ScintTimeEnd(i))
            tempTime = tempTime + minutes(1);
            tempPosition = sun_position_sdb(datestr(tempTime), location);
            tempZenith = tempPosition.zenith;
            if(tempZenith<90+SunDipCutoff)
                tempTime = tempTime - minutes(1);%set previous minute as end point
                %                     disp(['///HIT-END found ',datestr(tempTime),'///']);
                break;
            end
        end
        if (tempTime==ScintData.ScintTimeEnd(i))
            error('End of night-time not found');
        end
        NightStart(i) = ScintData.ScintTimeStart(i);
        NightEnd(i) = tempTime;
        ScintData.CategoryLong(i) = strcat(CategoryLong(i),"-PD-");
        ScintData.Notes(i) = strcat(ScintData.Notes(i),"-sunlight free until ",datestr(tempTime,'HH:MM:SS'),"-");
    elseif(DipEnd(i)>=90+SunDipCutoff) %ie only end within cutoff, go minute by minute to find startpoint
        %             disp(strcat('i=',num2str(i),' start=',datestr(ScintData.ScintTimeStart(i)),' end=',datestr(ScintData.ScintTimeEnd(i))))
        tempTime = ScintData.ScintTimeEnd(i);
        while (tempTime>ScintData.ScintTimeStart(i))
            tempTime = tempTime - minutes(1);
            tempPosition = sun_position_sdb(datestr(tempTime), location);
            tempZenith = tempPosition.zenith;
            %                 if i==147
            %                     disp('//////i=147//////');
            %                     tempTime
            %                     a=0;
            %                     a=tempZenith;
            %                     disp(strcat('tempZenith=',num2str(a)))
            %                 end
            if(tempZenith<90+SunDipCutoff)
                tempTime = tempTime + minutes(1);%set previous minute as end point
                %                     disp(['///HIT-START found ',datestr(tempTime),'///']);
                break;
            end
        end
        if (tempTime==ScintData.ScintTimeStart(i))
            %                 DipStart(i)%debug stuff
            %                 DipEnd(i)
            %                 tempTime
            error('Start of night-time not found');
        end
        NightStart(i) = tempTime;
        NightEnd(i) = ScintData.ScintTimeEnd(i);
        ScintData.CategoryLong(i) = strcat(CategoryLong(i),"-PD-");
        ScintData.Notes(i) = strcat(ScintData.Notes(i),"-sunlight free after ",datestr(tempTime,'HH:MM:SS'),"-");
    else %scan minute-by-minute
        tempTime = ScintData.ScintTimeStart(i) + minutes(1);
        tempStart = NaT;
        tempEnd = NaT;
        while (tempTime<ScintData.ScintTimeEnd(i))
            tempPosition = sun_position_sdb(datestr(tempTime), location);
            tempZenith = tempPosition.zenith;
            if((tempZenith>=90+SunDipCutoff) && isnat(tempStart))
                tempStart = tempTime;
            end
            if((tempZenith<90+SunDipCutoff) && ~isnat(tempStart))
                tempEnd = tempTime - minutes(1);%ie previous minute was good, use as endpoint
                break %no need to keep looping
            end
            tempTime = tempTime + minutes(1);
        end
        
        if(isnat(tempStart) && isnat(tempEnd))
            ScintData.CategoryLong(i) = strcat(CategoryLong(i),"-D-");
            ScintData.Category(i) = "-D-";
        elseif(~isnat(tempStart) && ~isnat(tempEnd))
            NightStart(i) = tempStart;
            NightEnd(i) = tempEnd;
            ScintData.CategoryLong(i) = strcat(CategoryLong(i),"-PD-");
            ScintData.Notes(i) = strcat(ScintData.Notes(i),"-sunlight free after ",datestr(tempStart,'HH:MM:SS')," until ",datestr(tempEnd,'HH:MM:SS'),"-");
        else
            error('Error in loop scanning for sunlight free times during scintillation event.')
        end
    end
end
ScintData = addvars(ScintData,DipStart,DipEnd,NightStart,NightEnd);
end