function [ASCScintListDCF, ASCScintListSortedDCF, ASCScintDaysDCF] = ASCCombine(ScintData,NumScintEvents)
% goes through each cell of ScintData, builds list of ASC files during scint events ASCScintList
% also ASCScintListSorted same list but divided into cells for each day
% ASCScintDays index of ASCScintListSorted
ASCScintList = string.empty;%preallocate
ASCScintDays = string.empty;
ASCScintListSorted = {};
ASCScintListCF = string.empty;
ASCScintDaysCF = string.empty;
ASCScintListSortedCF = {};
ASCScintListDCF = string.empty;
ASCScintDaysDCF = string.empty;
ASCScintListSortedDCF = {};
Date = datetime;
c = 0;
cf = 0;
dcf = 0;
for S=1:length(ScintData) %loop through each sheet(S)
    S
    if ~isempty(ScintData{S})%only deal with nonempty types
        %each event is necessarily the same day
        for i=1:NumScintEvents(S)%loop each event
            if ~isempty(ScintData{S}.TableImageIndex{i})
                i;
                %get date in format used by FTP server for folders
                Date = datestr(ScintData{S}.ScintTimeStart(i),'yyyymmdd');
                if Date == '20140925'
                    disp('pause');
                end
                c = find(ASCScintDays == Date);
                cf = find(ASCScintDaysCF == Date);
                dcf = find(ASCScintDaysDCF == Date);
                if isempty(c)%create new cell, add all ASC to both lists
                    ASCScintList = [ASCScintList ScintData{S}.EventASCFiles{i}];
                    ASCScintDays = [ASCScintDays Date];
                    ASCScintListSorted{length(ASCScintDays)} = ScintData{S}.EventASCFiles{i};
                else %add NEW files to existing days
                    %                [K,ia,ib] = intersect(ASCScintList, ScintData{S}.EventASCFiles{i});
                    ASCScintList = unique([ASCScintList ScintData{S}.EventASCFiles{i}]);
                    ASCScintListSorted{c} = unique([ASCScintListSorted{c} ScintData{S}.EventASCFiles{i}]);
                end
                if ~isempty(ScintData{S}.CloudFreeInterval{i})
                    if isempty(cf)%create new cell, add all ASC to both lists
                        ASCScintLisCF = [ASCScintListCF ScintData{S}.EventASCFiles{i}];
                        ASCScintDaysCF = [ASCScintDaysCF Date];
                        ASCScintListSortedCF{length(ASCScintDaysCF)} = ScintData{S}.EventASCFiles{i};
                    else %add NEW files to existing days
                        %                [K,ia,ib] = intersect(ASCScintList, ScintData{S}.EventASCFiles{i});
                        ASCScintListCF = unique([ASCScintListCF ScintData{S}.EventASCFiles{i}]);
                        ASCScintListSortedCF{cf} = unique([ASCScintListSortedCF{cf} ScintData{S}.EventASCFiles{i}]);
                    end
                    prnang = ScintData{S}.prnbtw{i};
                    eventfiles = ScintData{S}.EventASCFiles{i};
                    for k = 1:size(ScintData{S}.EventASCFiles{i}, 2)
                        dcf = find(ASCScintDaysDCF == Date);
                        prnang1 = prnang{k};
                        if prnang1 <= 25
                            if isempty(dcf)%create new cell, add all ASC to both lists
                                ASCScintListDCF = [ASCScintListDCF eventfiles(k)];
                                ASCScintDaysDCF = [ASCScintDaysDCF Date];
                                ASCScintListSortedDCF{length(ASCScintDaysDCF)} = eventfiles(k);
                            else %add NEW files to existing days
                                %                [K,ia,ib] = intersect(ASCScintList, ScintData{S}.EventASCFiles{i});
                                ASCScintListDCF = unique([ASCScintListDCF eventfiles(k)]);
                                ASCScintListSortedDCF{dcf} = unique([ASCScintListSortedDCF{dcf} eventfiles(k)]);
                            end
                        end
                    end
                end
            end
        end
    end
end
%now sort lists (simpler to do at end)
ASCScintList = sort(ASCScintList);
[ASCScintDays,I] = sort(ASCScintDays);%I stores index to reorder ASCScintListSorted with
ASCScintListSorted = ASCScintListSorted(I);

ASCScintListDCF = sort(ASCScintListDCF);
[ASCScintDaysDCF,I] = sort(ASCScintDaysDCF);%I stores index to reorder ASCScintListSorted with
ASCScintListSortedDCF = ASCScintListSortedDCF(I);
end