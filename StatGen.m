function [Stats,StatsISR,ScintData] = StatGen(ScintData,NumScintEvents,SheetName)
% Generate statistics for event types and all events, compare ASI vs PFISR
% output: var Stats, ResultBoth/SameStrict/SameLoose column in ScintData
n = length(ScintData);%can't loop through each sheet within function as before since comparing types
ScintName = repmat("",n,1);
NumOriginal = zeros(n,1);%events from master scint list before cloud detection etc
NumCloudFree = zeros(n,1);
NumSatNear = zeros(n,1);
NumE_ASCO = zeros(n,1);%final numbers from ASC method during suitable events
NumF_ASCO = zeros(n,1);
NumE_ASCN = zeros(n,1);%final numbers from ASC method during suitable events
NumF_ASCN = zeros(n,1);
NumE_ISR_SatNear = zeros(n,1);%ISR designation ONLY of events where ASC designation made
NumF_ISR_SatNear = zeros(n,1);
NumOther_ISR_SatNear = zeros(n,1);
NumN_ISR_SatNear = zeros(n,1);
NumFiltered_ISR_SatNear = zeros(n,1);
NumResultBoth = zeros(n,1);
NumE_ASCBO = zeros(n,1);
NumF_ASCBO = zeros(n,1);
NumE_ASCBN = zeros(n,1);
NumF_ASCBN = zeros(n,1);
NumEEO = zeros(n,1);
NumEFO = zeros(n,1);
NumEOO = zeros(n,1);
NumFEO = zeros(n,1);
NumFFO = zeros(n,1);
NumFOO = zeros(n,1);
NumEEN = zeros(n,1);
NumEFN = zeros(n,1);
NumEON = zeros(n,1);
NumFEN = zeros(n,1);
NumFFN = zeros(n,1);
NumFON = zeros(n,1);
% separate into 2 tables:
% 'Stats' = table of statistics for only ASC method
% 'StatsISR' = table comparing final designations against ISR designations
Stats = table(ScintName,NumOriginal,NumCloudFree,NumSatNear,NumE_ASCO,NumF_ASCO,NumE_ASCN,NumF_ASCN,...
    NumE_ISR_SatNear,NumF_ISR_SatNear,NumOther_ISR_SatNear,NumN_ISR_SatNear);
StatsISR = table(ScintName,NumSatNear,NumN_ISR_SatNear,NumFiltered_ISR_SatNear,NumResultBoth,...
    NumE_ASCBN, NumE_ASCBO,NumE_ISR_SatNear,NumF_ASCBO, NumF_ASCBN,NumF_ISR_SatNear,NumOther_ISR_SatNear,...
    NumEEO,NumEFO,NumEOO,NumFEO,NumFFO,NumFOO, NumEEN,NumEFN,NumEON,NumFEN,NumFFN,NumFON);

for S=1:length(SheetName) %loop through each sheet(S)
    %     Stats.ScintName(S) = SheetName{S};
    ScintName(S) = SheetName{S};
    Stats.ScintName(S) = ScintName(S);
    StatsISR.ScintName(S) = ScintName(S);
    
    if ~isempty(ScintData{S})%check sheet not empty
        Stats.NumOriginal(S) = NumScintEvents(S);
        CloudFree = 0;%moving counters
        SatNear = 0;
        EO = 0;%ASC counters
        FO = 0;
        EN = 0;
        FN = 0;
        EISR = 0;
        FISR = 0;
        OtherISR = 0;
        NISR = 0;
        FilteredISR = 0;
        E_ASCBO = 0; %E_ASCB/FB counters for ASC E/F events with both ASC/ISR
        F_ASCBO = 0;
        E_ASCBN = 0; %E_ASCB/FB counters for ASC E/F events with both ASC/ISR
        F_ASCBN = 0;
        ResultBothCounterOriginal = 0;
        SameStrictCounter = 0;%tick+1 when events are categorized eaxactly
        %the same ASV vs PFISR, counting T/I PFISR as not the same
        SameLooseCounter = 0;%same, but count T/I events as matching either
        %E/F ASC
        
        %Permutation counter for results ASC vs PFISR: E/F and E/F/Other
        EEO = 0;
        EFO = 0;
        EOO = 0;
        FEO = 0;
        FFO = 0;
        FOO = 0;
        EEN = 0;
        EFN = 0;
        EON = 0;
        FEN = 0;
        FFN = 0;
        FON = 0;
        AEO = 0;
        AFO = 0;
        AEN = 0;
        AFN = 0;
        
        ResultBothOriginal = cell(NumScintEvents(S),1);
        SameStrictOriginal = cell(NumScintEvents(S),1);
        SameLooseOriginal = cell(NumScintEvents(S),1);
        ResultBoth = cell(NumScintEvents(S),1);
        Same = cell(NumScintEvents(S),1);
        SameLoose = cell(NumScintEvents(S),1);
        temp = ScintData{S}; %have to have these 3 lines otherwise empty column added
        temp = addvars(temp,ResultBothOriginal, SameStrictOriginal, SameLooseOriginal, ResultBoth, Same, SameLoose);
        ScintData{S} = temp;
        
        for i=1:NumScintEvents(S)%loop each event
            S
            i 
            if ~isempty(ScintData{S}.CloudFreeInterval{i})
                CloudFree = CloudFree+1;
            end
            %judge satnear as true if A prnbtw <=25, tick SatNear
            if ~isempty(ScintData{S}.prnbtw{i})%loop through timestamps of B-PRN angle
                for f=1:length(ScintData{S}.prnbtw{i})
                    try
                        if (ScintData{S}.prnbtw{i}{f}<=25)
                            SatNear = SatNear+1;
                            break %stop counting if the satellite is near B at least once
                        end
                    catch
                        if (ScintData{S}.prnbtw{i}(f)<=25)
                            SatNear = SatNear+1;
                            break %stop counting if the satellite is near B at least once
                        end
                    end
                end
            end
            %             prnbtwavg = mean(ScintData{S}.prnbtw{i}(:));
            %             if mean(ScintData{S}.prnbtw{i}(:))<=prnbtw_lim1 && mean(ScintData{S}.prnbtw{i}(:))>=prnbtw_lim2
            
            %tick E/F based on ASI event designation
            if strcmp(ScintData{S}.ASI_EFO{i},"E")
                AEO = AEO+1;
            elseif strcmp(ScintData{S}.ASI_EFO{i},"F")
                AFO = AFO+1;
            elseif strcmp(ScintData{S}.ASI_EFO{i},"N")
                %do nothing
            else
                error('Error in ASI_EF. Values should only be E/F/N')
            end
            
            if strcmp(ScintData{S}.ASI_EF{i},"E")
                AEN = AEN+1;
            elseif strcmp(ScintData{S}.ASI_EF{i},"F")
                AFN = AFN+1;
            elseif strcmp(ScintData{S}.ASI_EF{i},"N")
                %do nothing
            else
                error('Error in ASI_EF. Values should only be E/F/N')
            end
            %compare ASI designated events with PFISR (only care when ASI
            %designation made)
            %For updated spreadsheet E=1 F=2 T=3 I=4 N=5 6=NLP 7=NAC
            PFISR_num = ScintData{S}.PFISR_E_F(i); %PHISR Designation  E=1 F=2 T=3 I=4 N=5 6=NLP 7=NAC
            if PFISR_num == 1
                PFISR_des = "E";
            elseif PFISR_num == 2
                PFISR_des = "F";
            elseif PFISR_num == 3
                PFISR_des = "T";
            elseif PFISR_num == 4
                PFISR_des = "I";
            elseif PFISR_num == 5
                PFISR_des = "N";
            elseif PFISR_num == 6
                PFISR_des = "NLP";
            elseif PFISR_num == 7
                PFISR_des = "NAC";
            elseif PFISR_num == 8
                PFISR_des = "FACLP";
            elseif PFISR_num == 9
                PFISR_des = "FLP";
            elseif PFISR_num == 10
                PFISR_des = "FAC";
                
            else
                errorvalue = ScintData{S}.PFISR_E_F(i)
                error('Error in PFISR_E_F. Values should only be 1/2/3/4/5/6/7')
            end
            if (strcmp(ScintData{S}.ASI_EFO{i},"E")||strcmp(ScintData{S}.ASI_EFO{i},"F"))
                if strcmp(PFISR_des, "E") %E
                    EISR = EISR+1;
                elseif strcmp(PFISR_des, "F") %F
                    FISR = FISR+1;
                elseif (strcmp(PFISR_des, "T") || strcmp(PFISR_des, "I")) %T and I
                    OtherISR = OtherISR+1;
                elseif (strcmp(PFISR_des, "N")|| strcmp(PFISR_des, "NLP") || strcmp(PFISR_des, "NAC")) %N, NLP, NAC
                    NISR = NISR+1;
                elseif (strcmp(PFISR_des, "FAC") ||strcmp(PFISR_des, "FLP") || strcmp(PFISR_des, "FACLP")) %ISR was filtered out
                    FilteredISR = FilteredISR+1;
                else
                    errorvalue = PFISR_des
                    error('Error in revisedPFISR. Values should only be E/F/T/I/N/NLP/NAC/FAC/FLP/FACLP')
                end
                %then check ISR doesn't have missing data, add column
                if (strcmp(PFISR_des, "E") || strcmp(PFISR_des, "F")...
                        || strcmp(PFISR_des, "T") || strcmp(PFISR_des, "I"))
                    
                    ScintData{S}.ResultBothOriginal{i} = "Y";
                    ResultBothCounterOriginal = ResultBothCounterOriginal+1;
                    
                    %tick counters for ASCB, and permutation counters
                    %EE,EF...
                    switch ScintData{S}.ASI_EFO{i}
                        case "E"
                            E_ASCBo = E_ASCBO+1;
                            switch PFISR_des
                                case "E"
                                    EEO = EEO+1;
                                case "F"
                                    EFO = EFO+1;
                                case "T"
                                    EOO = EOO+1;
                                case "I"
                                    EOO = EOO+1;
                                otherwise
                                    error("Error in ScintData{S}.revisedPFISR{i}");
                            end
                        case "F"
                            F_ASCBO = F_ASCBO+1;
                            switch PFISR_des
                                case "E"
                                    FEO = FEO+1;
                                case "F"
                                    FFO = FFO+1;
                                case "T"
                                    FOO = FOO+1;
                                case "I"
                                    FOO = FOO+1;
                                otherwise
                                    error("Error in ScintData{S}.revisedPFISR{i}");
                            end
                        otherwise
                            error("Error in ScintData{S}.ASI_EF{i}");
                    end
                    
                    %SameStrict- compare if ASI and ISR designation the same, or if
                    %ambiguous ISR result (I/T)
                    if (strcmp(PFISR_des,ScintData{S}.ASI_EFO{i}))
                        ScintData{S}.SameStrictOriginal{i} = "Y";
                    else
                        ScintData{S}.SameStrictOriginal{i} = "N";
                    end
                    %SameLoose- compare if ASI and ISR designation the same,
                    %or if ambiguous ISR result (I/T)
                    if (strcmp(PFISR_des,ScintData{S}.ASI_EFO{i})...
                            ||strcmp(PFISR_des,"T")||strcmp(PFISR_des,"I"))
                        ScintData{S}.SameLooseOriginal{i} = "Y";
                    else
                        ScintData{S}.SameLooseOriginal{i} = "N";
                    end
                else %missing radar data
                    ScintData{S}.ResultBothOriginal{i} = "N";
                end
                
            end
            if (strcmp(ScintData{S}.ASI_EF{i},"E")||strcmp(ScintData{S}.ASI_EF{i},"F"))
                %then check ISR doesn't have missing data, add column
                if (strcmp(PFISR_des, "E") || strcmp(PFISR_des, "F")...
                        || strcmp(PFISR_des, "T") || strcmp(PFISR_des, "I"))
                    
                    ScintData{S}.ResultBoth{i} = "Y";
                    switch ScintData{S}.ASI_EF{i}
                        case "E"
                            E_ASCBN = E_ASCBN+1;
                            switch PFISR_des
                                case "E"
                                    EEN = EEN+1;
                                case "F"
                                    EFN = EFN+1;
                                case "T"
                                    EON = EON+1;
                                case "I"
                                    EON = EON+1;
                                otherwise
                                    error("Error in ScintData{S}.revisedPFISR{i}");
                            end
                        case "F"
                            F_ASCBN = F_ASCBN+1;
                            switch PFISR_des
                                case "E"
                                    FEN = FEN+1;
                                case "F"
                                    FFN = FFN+1;
                                case "T"
                                    FON = FON+1;
                                case "I"
                                    FON = FON+1;
                                otherwise
                                    error("Error in ScintData{S}.revisedPFISR{i}");
                            end
                        otherwise
                            error("Error in ScintData{S}.ASI_EF{i}");
                    end
                    
                    %SameStrict- compare if ASI and ISR designation the same, or if
                    %ambiguous ISR result (I/T)
                    if (strcmp(PFISR_des,ScintData{S}.ASI_EF{i}))
                        ScintData{S}.Same{i} = "Y";
                    else
                        ScintData{S}.Same{i} = "N";
                    end
                    %SameLoose- compare if ASI and ISR designation the same,
                    %or if ambiguous ISR result (I/T)
                    if (strcmp(PFISR_des,ScintData{S}.ASI_EF{i})...
                            ||strcmp(PFISR_des,"T")||strcmp(PFISR_des,"I"))
                        ScintData{S}.SameLoose{i} = "Y";
                    else
                        ScintData{S}.SameLoose{i} = "N";
                    end
                else %missing radar data
                    ScintData{S}.ResultBoth{i} = "N";
                end
                
            end
            
        end
        SatNear = AEO+AFO;
        Stats.NumCloudFree(S) = CloudFree;
        Stats.NumSatNear(S) = SatNear;
        Stats.NumE_ASCO(S) = AEO;
        Stats.NumF_ASCO(S) = AFO;
        Stats.NumE_ASCN(S) = AEN;
        Stats.NumF_ASCN(S) = AFN;
        Stats.NumE_ISR_SatNear(S) = EISR;
        Stats.NumF_ISR_SatNear(S) = FISR;
        Stats.NumOther_ISR_SatNear(S) = OtherISR;
        Stats.NumN_ISR_SatNear(S) = NISR;
        StatsISR.NumSatNear(S) = SatNear;
        StatsISR.NumE_ISR_SatNear(S) = EISR;
        StatsISR.NumF_ISR_SatNear(S) = FISR;
        StatsISR.NumOther_ISR_SatNear(S) = OtherISR;
        StatsISR.NumN_ISR_SatNear(S) = NISR;
        StatsISR.NumFiltered_ISR_SatNear(S) = FilteredISR;
        StatsISR.NumResultBoth(S) = ResultBothCounterOriginal;
        StatsISR.NumE_ASCBO(S) = E_ASCBO;
        StatsISR.NumF_ASCBO(S) = F_ASCBO;
        StatsISR.NumE_ASCBN(S) = E_ASCBN;
        StatsISR.NumF_ASCBN(S) = F_ASCBN;
        StatsISR.NumEEO(S) = EEO;
        StatsISR.NumEFO(S) = EFO;
        StatsISR.NumEOO(S) = EOO;
        StatsISR.NumFEO(S) = FEO;
        StatsISR.NumFFO(S) = FFO;
        StatsISR.NumFOO(S) = FOO;
        StatsISR.NumEEN(S) = EEN;
        StatsISR.NumEFN(S) = EFN;
        StatsISR.NumEON(S) = EON;
        StatsISR.NumFEN(S) = FEN;
        StatsISR.NumFFN(S) = FFN;
        StatsISR.NumFON(S) = FON;
    end
end

%calc sums across all year/frequencies
SumStats = num2cell(sum(Stats{:,2:end},1));
SumStatsRow = {'Sum All',SumStats{:}};
Stats = [Stats; SumStatsRow];%catenate row

SumStatsISR = num2cell(sum(StatsISR{:,2:end},1));
SumStatsISRRow = {'Sum All',SumStatsISR{:}};
StatsISR = [StatsISR; SumStatsISRRow];%catenate row
end