function [YangScintData] = YangCompare(YangData, ScintData)
% generate table (YangScintData) of events from ScintData during periods
% from Yang's Table, that are E layer according to PFISR
YangScintData = [];
if isempty(ScintData)
    return
end

for i=1:height(YangData)% loop through each event on YangData
    for j=1:height(ScintData)%loop though every scint event
        disp(['i=',num2str(i),' j=',num2str(j)]);
        
        %check for overlapping conditions, and E layer event
        if (strcmp(ScintData.revisedPFISR(j),'E') && (YangData.YangTimeStart(i)<=ScintData.ScintTimeEnd(j)) && (ScintData.ScintTimeStart(j)<=YangData.YangTimeEnd(i)))
            if isempty(YangScintData)%special case first element
                YangScintData = ScintData(j,:);
            else
                YangScintData = [YangScintData; ScintData(j,:)];%add new row to end
            end
        end
    end
end
end