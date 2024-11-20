function [YangRawData, YangData, NumOverlapEvents] = YangLoad(ScintSpreadFileName, SheetName)
% ScintData is table that returns results
YangRawData = readtable(ScintSpreadFileName,'Sheet',SheetName);%crash here means file wrong name or not in MATLAB path
NumOverlapEvents = height(YangRawData); %number of scintillation events
%     remove events where v_m_s > 2000m/s (unrealistic speeds)
YangData = YangRawData((YangRawData.v_m_s_ < 2000),:);

%     find end time from time passed since start
YangTimeStart = datetime(num2str(YangData.Year),'InputFormat','yyyy')+days(YangData.DOY-1)+hours(floor(YangData.UT_t0_hhmm_/100))+minutes(rem(YangData.UT_t0_hhmm_,100));%subtract 1 day since DOY 1 = start of year +0days
YangTimeEnd = YangTimeStart + minutes(YangData.DeltaT_min_);
YangData = addvars(YangData,YangTimeStart,YangTimeEnd);
end