function [ASCScintList, ASCScintListSorted, ASCScintDays] = ASCCombine(ScintData,NumScintEvents)
% goes through each cell of ScintData, builds list of ASC files during scint events ASCScintList
% also ASCScintListSorted same list but divided into cells for each day
% ASCScintDays index of ASCScintListSorted
ASCScintList = string.empty;%preallocate
ASCScintDays = string.empty;
ASCScintListSorted = {};
Date = datetime;
c = 0;
for S=1:length(ScintData) %loop through each sheet(S)
    S
    if ~isempty(ScintData{S})%only deal with nonempty types
        %each event is necessarily the same day
        for i=1:NumScintEvents(S)%loop each event
            if ~isempty(ScintData{S}.TableImageIndex{i})
                i;
                %get date in format used by FTP server for folders
                Date = datestr(ScintData{S}.ScintTimeStart(i),'yyyymmdd');
                c = find(ASCScintDays == Date);
                if isempty(c)%create new cell, add all ASC to both lists
                    ASCScintList = [ASCScintList ScintData{S}.EventASCFiles{i}];
                    ASCScintDays = [ASCScintDays Date];
                    ASCScintListSorted{length(ASCScintDays)} = ScintData{S}.EventASCFiles{i};
                else %add NEW files to existing days
                    %                [K,ia,ib] = intersect(ASCScintList, ScintData{S}.EventASCFiles{i});
                    ASCScintList = unique([ASCScintList ScintData{S}.EventASCFiles{i}]);
                    ASCScintListSorted{c} = unique([ASCScintListSorted{c} ScintData{S}.EventASCFiles{i}]);
                end
            end
        end
    end
end
%now sort lists (simpler to do at end)
ASCScintList = sort(ASCScintList);
[ASCScintDays,I] = sort(ASCScintDays);%I stores index to reorder ASCScintListSorted with
ASCScintListSorted = ASCScintListSorted(I);
end