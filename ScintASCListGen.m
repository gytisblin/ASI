function [ScintData] = ScintASCListGen(ScintData, NumScintEvents, ASCDays, ASCFileListSortedTime, ASCFileListSorted)
% checks scint event list (for single event type/table passed with
% ScintData) against directory of ASC files on Alaska server (ASCDays as
% datetime for dates corresponding to cells of ASCFileListSorted)

% first get HHMMSS timestamp for start/end of each scint event (same format
% as ASCFileListSortedTime)
StartTimeNum = str2double(convertCharsToStrings(cellstr(datestr(ScintData.ScintTimeStart,'HHMMSS'))));
EndTimeNum = str2double(convertCharsToStrings(cellstr(datestr(ScintData.ScintTimeEnd,'HHMMSS'))));
TableImageIndex = cell(NumScintEvents,1);
EventASCFiles = cell(NumScintEvents,1);
ASCInterval = cell(NumScintEvents,1);
ScintData = addvars(ScintData,StartTimeNum,EndTimeNum,TableImageIndex,EventASCFiles,ASCInterval);

% compare StartTimeNum/EndTime +/-1min to ASC times to generate list for
% each scint event
ASCDayIndex = 0;%preallocate
ASCImageIndex = 0;
StartNum = 0;
EndNum = 0;
for i=1:NumScintEvents
    %     i
    %     first check if ASC exists for that day, if not flag
    ASCDayIndex = find(ASCDays==dateshift(ScintData.ScintTimeStart(i), 'start', 'day'));
    if isempty(ASCDayIndex)
        ScintData.Category(i) = strcat(ScintData.Category(i),'-NASC-');
        ScintData.CategoryLong(i) = strcat(ScintData.CategoryLong(i),'-NASC-');
    else
        StartNum = ScintData.StartTimeNum(i) - 100; %ie minus 1 min
        EndNum = ScintData.EndTimeNum(i) + 100;
        %now find matches within correct ASC day cell/folder
        %times must be after start (minus 1 min) and before end (plus 1 min)
        ASCImageIndex = find((ASCFileListSortedTime{ASCDayIndex}>=StartNum) &...
            (ASCFileListSortedTime{ASCDayIndex}<=EndNum));
        ScintData.TableImageIndex{i} = ASCImageIndex;
        ScintData.EventASCFiles{i} = ASCFileListSorted{ASCDayIndex}(ScintData.TableImageIndex{i});
        
        if isempty(ScintData.TableImageIndex{i})
            ScintData.Category(i) = strcat(ScintData.Category(i),'-NASC-');
            ScintData.CategoryLong(i) = strcat(ScintData.CategoryLong(i),'-NASC-');
        else %determine ASC coverage
            %find first and last ASC time
            FirstASC = min(ASCFileListSortedTime{ASCDayIndex}(ScintData.TableImageIndex{i}));
            LastASC = max(ASCFileListSortedTime{ASCDayIndex}(ScintData.TableImageIndex{i}));
            
            FirstASCTime = dateshift(ScintData.ScintTimeStart(i),'start','day')+hours(floor(FirstASC/10000))+minutes(rem(floor(FirstASC/100),100))+seconds(rem(FirstASC,100));
            LastASCTime = dateshift(ScintData.ScintTimeStart(i),'start','day')+hours(floor(LastASC/10000))+minutes(rem(floor(LastASC/100),100))+seconds(rem(LastASC,100));
            ScintData.ASCInterval{i} = [FirstASCTime LastASCTime];
            
            %compare to determine if partial/full ASC coverage
            if ((FirstASCTime-ScintData.ScintTimeStart(i))<=0 && (LastASCTime-ScintData.ScintTimeEnd(i))>=0)
                %full ASC during scint
                ScintData.CategoryLong(i) = strcat(ScintData.CategoryLong(i),'-ASC-');
            elseif ((FirstASCTime-ScintData.ScintTimeStart(i))>0 && (LastASCTime-ScintData.ScintTimeEnd(i))>=0)
                %no ASC at start
                ScintData.Category(i) = strcat(ScintData.Category(i),'-PASC-');
                ScintData.CategoryLong(i) = strcat(ScintData.CategoryLong(i),'-PASC-');
                ScintData.Notes(i) = strcat(ScintData.Notes(i),"-ASC only from ",datestr(ScintData.ASCInterval{i}(1),'HH:MM:SS'));
            elseif ((FirstASCTime-ScintData.ScintTimeStart(i))<=0 && (LastASCTime-ScintData.ScintTimeEnd(i))<0)
                %no ASC at end
                ScintData.Category(i) = strcat(ScintData.Category(i),'-PASC-');
                ScintData.CategoryLong(i) = strcat(ScintData.CategoryLong(i),'-PASC-');
                ScintData.Notes(i) = strcat(ScintData.Notes(i),"-ASC only until ",datestr(ScintData.ASCInterval{i}(2),'HH:MM:SS'));
            elseif ((FirstASCTime-ScintData.ScintTimeStart(i))>0 && (LastASCTime-ScintData.ScintTimeEnd(i))<0)
                ScintData.Category(i) = strcat(ScintData.Category(i),'-PASC-');
                ScintData.CategoryLong(i) = strcat(ScintData.CategoryLong(i),'-PASC-');
                ScintData.Notes(i) = strcat(ScintData.Notes(i),"-keogram only from ",datestr(ScintData.ASCInterval{i}(1),'HH:MM:SS')," until ",datestr(datestr(ScintData.ASCInterval{i}(2)),'HH:MM:SS'));
                %no ASC at start and end (only during middle of scint time)
            elseif ((FirstASCTime-ScintData.ScintTimeEnd(i))>0 || (LastASCTime-ScintData.ScintTimeStart(i))<0)
                %no ASC during scintillation, since previously looking for
                %+/-1min from scint times could occur (ie only ASC 1 min
                %before scint times but not during~)
                %clear relevant fields since no ASC during scint times
                ScintData.TableImageIndex{i} = [];
                ScintData.EventASCFiles{i} = [];
                ScintData.ASCInterval{i} = [];
                ScintData.Category(i) = strcat(ScintData.Category(i),'-NASC-');
                ScintData.CategoryLong(i) = strcat(ScintData.CategoryLong(i),'-NASC-');
            else
                %logic error, should not happen
                error('Logic error in loop comparing ASC and scintillation times');
            end
        end
    end
end
end