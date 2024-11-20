function [StatsB,StatsBISR,ScintData,HistGBR,HistRBratio] = StatGen2(ScintData,NumScintEvents,SheetName)
%same as StatGen() except calced for MagLOS
% Generate statistics for event types and all events, compare ASI vs PFISR
% output: var Stats, ResultBoth/SameStrict/SameLoose column in ScintData
n = length(ScintData);%can't loop through each sheet within function as before since comparing types
ScintName = repmat("",n,1);
NumOriginal = zeros(n,1);%events from master scint list before cloud detection etc
NumCloudFree = zeros(n,1);
NumSatNear = zeros(n,1);
NumE_ASC = zeros(n,1);%final numbers from ASC method during suitable events
NumF_ASC = zeros(n,1);
NumE_ISR_SatNear = zeros(n,1);%ISR designation ONLY of events where ASC designation made
NumF_ISR_SatNear = zeros(n,1);
NumOther_ISR_SatNear = zeros(n,1);
NumN_ISR_SatNear = zeros(n,1);
NumResultBoth = zeros(n,1);
NumE_ASCB = zeros(n,1);
NumF_ASCB = zeros(n,1);
NumEE = zeros(n,1);
NumEF = zeros(n,1);
NumEO = zeros(n,1);
NumFE = zeros(n,1);
NumFF = zeros(n,1);
NumFO = zeros(n,1);
% separate into 2 tables:
% 'Stats' = table of statistics for only ASC method
% 'StatsISR' = table comparing final designations against ISR designations
StatsB = table(ScintName,NumOriginal,NumCloudFree,NumSatNear,NumE_ASC,NumF_ASC,...
    NumE_ISR_SatNear,NumF_ISR_SatNear,NumOther_ISR_SatNear,NumN_ISR_SatNear);
StatsBISR = table(ScintName,NumSatNear,NumN_ISR_SatNear,NumResultBoth,...
    NumE_ASCB,NumE_ISR_SatNear,NumF_ASCB,NumF_ISR_SatNear,NumOther_ISR_SatNear,...
    NumEE,NumEF,NumEO,NumFE,NumFF,NumFO);

%Histogram stats, append to for every timestamp where E/F assigned
HistGBR = [];
HistRBratio = [];

for S=1:length(ScintData)%length(SheetName) %loop through each sheet(S)
    %     Stats.ScintName(S) = SheetName{S};
    ScintName(S) = SheetName{S};
    StatsB.ScintName(S) = ScintName(S);
    StatsBISR.ScintName(S) = ScintName(S);
    
    if ~isempty(ScintData{S})%check sheet not empty
        StatsB.NumOriginal(S) = NumScintEvents(S);
        CloudFree = 0;%moving counters
        SatNear = 0;
        EO = 0;%ASC counters
        FO = 0;
        EN = 0;%ASC counters
        FN = 0;
        EISRO = 0;
        FISRO = 0;
        EISRN = 0;
        FISRN = 0;
        OtherISRO = 0;
        OtherISRN = 0;
        NISRO = 0;
        NISRN = 0;
        E_ASCBO = 0; %E_ASCB/FB counters for ASC E/F events with both ASC/ISR
        F_ASCBO = 0;
        E_ASCBN = 0; %E_ASCB/FB counters for ASC E/F events with both ASC/ISR
        F_ASCBN = 0;
        ResultBothCounterO = 0;
        SameStrictCounterO = 0;%tick+1 when events are categorized eaxactly
        %the same ASV vs PFISR, counting T/I PFISR as not the same
        SameLooseCounterO = 0;%same, but count T/I events as matching either
        %E/F ASC
        ResultBothCounterN = 0;
        SameStrictCounterN = 0;%tick+1 when events are categorized eaxactly
        %the same ASV vs PFISR, counting T/I PFISR as not the same
        SameLooseCounterN = 0;%same, but count T/I events as matching either
        %E/F ASC
        
        %Permutation counter for results ASC vs PFISR: E/F and E/F/Other
        EE_O = 0;
        EF_O = 0;
        EO_O = 0;
        FE_O = 0;
        FF_O = 0;
        FO_O = 0;
        EE_N = 0;
        EF_N = 0;
        EO_N = 0;
        FE_N = 0;
        FF_N = 0;
        FO_N = 0;
        
        ResultBothB_O = cell(NumScintEvents(S),1);
        SameStrictB_O = cell(NumScintEvents(S),1);
        SameLooseB_O = cell(NumScintEvents(S),1);
        ResultBothB_N = cell(NumScintEvents(S),1);
        SameStrictB_N = cell(NumScintEvents(S),1);
        SameLooseB_N = cell(NumScintEvents(S),1);
        temp = ScintData{S}; %have to have these 3 lines otherwise empty column added
        temp = addvars(temp,ResultBothB_O,SameStrictB_O,SameLooseB_O,ResultBothB_N,SameStrictB_N,SameLooseB_N);
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
                    if (ScintData{S}.prnbtw{i}{f}<=25)
                        SatNear = SatNear+1;
                        break %stop counting if the satellite is near B at least once
                    end
                end
            end
            %tick E/F based on ASI event designation
            if strcmp(ScintData{S}.ASI_BEFO{i},"E")
                EO = EO+1;
            elseif strcmp(ScintData{S}.ASI_BEFO{i},"F")
                FO = FO+1;
            elseif strcmp(ScintData{S}.ASI_BEFO{i},"N")
                %do nothing
            else
                error('Error in ASI_BEF. Values should only be E/F/N')
            end
            
            if strcmp(ScintData{S}.ASI_BEFN{i},"E")
                EN = EN+1;
            elseif strcmp(ScintData{S}.ASI_BEFN{i},"F")
                FN = FN+1;
            elseif strcmp(ScintData{S}.ASI_BEFN{i},"N")
                %do nothing
            else
                error('Error in ASI_BEF. Values should only be E/F/N')
            end
            %compare ASI designated events with PFISR (only care when ASI
            %designation made)
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
            else
                errorvalue = ScintData{S}.PFISR_E_F(i)
                error('Error in PFISR_E_F. Values should only be 1/2/3/4/5/6/7')
            end
            if (strcmp(ScintData{S}.ASI_BEFO{i},"E")||strcmp(ScintData{S}.ASI_BEFO{i},"F"))
                if strcmp(PFISR_des,"E")
                    EISRO = EISRO+1;
                elseif strcmp(PFISR_des,"F")
                    FISRO = FISRO+1;
                elseif (strcmp(PFISR_des,"T")||strcmp(PFISR_des,"I"))
                    OtherISRO = OtherISRO+1;
                elseif (strcmp(PFISR_des,"N")||strcmp(PFISR_des,"NLP")||strcmp(PFISR_des,"NAC"))
                    NISRO = NISRO+1;
                else
                    errorvalue = PFISR_des
                    error('Error in revisedPFISR. Values should only be E/F/T/I/N/NLP/NAC')
                end
                %then check ISR doesn't have missing data, add column
                if (strcmp(PFISR_des,"E")||strcmp(PFISR_des,"F")...
                        ||strcmp(PFISR_des,"T")||strcmp(PFISR_des,"I"))
                    
                    ScintData{S}.ResultBothB_O{i} = "Y";
                    ResultBothCounterO = ResultBothCounterO+1;
                    
                    %tick counters for ASCB, and permutation counters
                    %EE,EF...
                    switch ScintData{S}.ASI_BEFO{i}
                        case "E"
                            E_ASCBO = E_ASCBO+1;
                            switch PFISR_des
                                case "E"
                                    EE_O = EE_O+1;
                                case "F"
                                    EF_O = EF_O+1;
                                case "T"
                                    EO_O = EO_O+1;
                                case "I"
                                    EO_O = EO_O+1;
                                otherwise
                                    error("Error in ScintData{S}.revisedPFISR{i}");
                            end
                        case "F"
                            F_ASCBO = F_ASCBO+1;
                            switch PFISR_des
                                case "E"
                                    FE_O = FE_O+1;
                                case "F"
                                    FF_O = FF_O+1;
                                case "T"
                                    FO_O = FO_O+1;
                                case "I"
                                    FO_O = FO_O+1;
                                otherwise
                                    error("Error in ScintData{S}.revisedPFISR{i}");
                            end
                        otherwise
                            error("Error in ScintData{S}.ASI_BEF{i}");
                    end
                    
                    %SameStrict- compare if ASI and ISR designation the same, or if
                    %ambiguous ISR result (I/T)
                    if (strcmp(PFISR_des,ScintData{S}.ASI_BEFO{i}))
                        ScintData{S}.SameStrictB_O{i} = "Y";
                    else
                        ScintData{S}.SameStrictB_O{i} = "N";
                    end
                    %SameLoose- compare if ASI and ISR designation the same,
                    %or if ambiguous ISR result (I/T)
                    if (strcmp(PFISR_des,ScintData{S}.ASI_BEFO{i})...
                            ||strcmp(PFISR_des,"T")||strcmp(PFISR_des,"I"))
                        ScintData{S}.SameLooseB_O{i} = "Y";
                    else
                        ScintData{S}.SameLooseB_O{i} = "N";
                    end
                else %missing radar data
                    ScintData{S}.ResultBothB_O{i} = "N";
                end
                
                %construct Histogram stats
                %                 TripletASC = ScintData.TripletASC{i};
                for n=1:length(ScintData{S}.EFcat_original{i})
                    n
                    if ~strcmp(ScintData{S}.EFcat_original{i}(n),"-")
                        HistGBR = [HistGBR; ScintData{S}.gbrkr{i}(n,:)];
                        HistRBratio = [HistRBratio; ScintData{S}.rbratio{i}(n)];
                    end
                end
                
            end
            if (strcmp(ScintData{S}.ASI_BEFN{i},"E")||strcmp(ScintData{S}.ASI_BEFN{i},"F"))
                if strcmp(PFISR_des,"E")
                    EISRN = EISRN+1;
                elseif strcmp(PFISR_des,"F")
                    FISRN = FISRN+1;
                elseif (strcmp(PFISR_des,"T")||strcmp(PFISR_des,"I"))
                    OtherISRN = OtherISRN+1;
                elseif (strcmp(PFISR_des,"N")||strcmp(PFISR_des,"NLP")||strcmp(PFISR_des,"NAC"))
                    NISRN = NISRN+1;
                else
                    errorvalue = PFISR_des
                    error('Error in revisedPFISR. Values should only be E/F/T/I/N/NLP/NAC')
                end
                %then check ISR doesn't have missing data, add column
                if (strcmp(PFISR_des,"E")||strcmp(PFISR_des,"F")...
                        ||strcmp(PFISR_des,"T")||strcmp(PFISR_des,"I"))
                    
                    ScintData{S}.ResultBothB_N{i} = "Y";
                    ResultBothCounterN = ResultBothCounterN+1;
                    
                    %tick counters for ASCB, and permutation counters
                    %EE,EF...
                    switch ScintData{S}.ASI_BEFN{i}
                        case "E"
                            E_ASCBN = E_ASCBN+1;
                            switch PFISR_des
                                case "E"
                                    EE_N = EE_N+1;
                                case "F"
                                    EF_N = EF_N+1;
                                case "T"
                                    EO_N = EO_N+1;
                                case "I"
                                    EO_N = EO_N+1;
                                otherwise
                                    error("Error in ScintData{S}.revisedPFISR{i}");
                            end
                        case "F"
                            F_ASCBN = F_ASCBN+1;
                            switch PFISR_des
                                case "E"
                                    FE_N = FE_N+1;
                                case "F"
                                    FF_N = FF_N+1;
                                case "T"
                                    FO_N = FO_N+1;
                                case "I"
                                    FO_N = FO_N+1;
                                otherwise
                                    error("Error in ScintData{S}.revisedPFISR{i}");
                            end
                        otherwise
                            error("Error in ScintData{S}.ASI_BEF{i}");
                    end
                    
                    %SameStrict- compare if ASI and ISR designation the same, or if
                    %ambiguous ISR result (I/T)
                    if (strcmp(PFISR_des,ScintData{S}.ASI_BEFN{i}))
                        ScintData{S}.SameStrictB_N{i} = "Y";
                    else
                        ScintData{S}.SameStrictB_N{i} = "N";
                    end
                    %SameLoose- compare if ASI and ISR designation the same,
                    %or if ambiguous ISR result (I/T)
                    if (strcmp(PFISR_des,ScintData{S}.ASI_BEFN{i})...
                            ||strcmp(PFISR_des,"T")||strcmp(PFISR_des,"I"))
                        ScintData{S}.SameLooseB_N{i} = "Y";
                    else
                        ScintData{S}.SameLooseB_N{i} = "N";
                    end
                else %missing radar data
                    ScintData{S}.ResultBothB_N{i} = "N";
                end
                
                %construct Histogram stats
                %                 TripletASC = ScintData.TripletASC{i};
                
            end
        end
        
        StatsB.NumCloudFree(S) = CloudFree;
        StatsB.NumSatNear(S) = SatNear;
        StatsB.NumE_ASC(S) = EO;
        StatsB.NumF_ASC(S) = FO;
        StatsB.NumE_ISR_SatNear(S) = EISRO;
        StatsB.NumF_ISR_SatNear(S) = FISRO;
        StatsB.NumOther_ISR_SatNear(S) = OtherISRO;
        StatsB.NumN_ISR_SatNear(S) = NISRO;
        StatsB.NumE_ASC(S) = EN;
        StatsB.NumF_ASC(S) = FN;
        StatsB.NumE_ISR_SatNear(S) = EISRN;
        StatsB.NumF_ISR_SatNear(S) = FISRN;
        StatsB.NumOther_ISR_SatNear(S) = OtherISRN;
        StatsB.NumN_ISR_SatNear(S) = NISRN;
        StatsBISR.NumSatNear(S) = SatNear;
        StatsBISR.NumE_ISR_SatNear(S) = EISRO;
        StatsBISR.NumF_ISR_SatNear(S) = FISRO;
        StatsBISR.NumOther_ISR_SatNear(S) = OtherISRO;
        StatsBISR.NumN_ISR_SatNear(S) = NISRO;
        StatsBISR.NumResultBoth(S) = ResultBothCounterO;
        StatsBISR.NumE_ASCB(S) = E_ASCBO;
        StatsBISR.NumF_ASCB(S) = F_ASCBO;
        StatsBISR.NumEE(S) = EE_O;
        StatsBISR.NumEF(S) = EF_O;
        StatsBISR.NumEO(S) = EO_O;
        StatsBISR.NumFE(S) = FE_O;
        StatsBISR.NumFF(S) = FF_O;
        StatsBISR.NumFO(S) = FO_O;
        StatsBISR.NumE_ISR_SatNear(S) = EISRN;
        StatsBISR.NumF_ISR_SatNear(S) = FISRN;
        StatsBISR.NumOther_ISR_SatNear(S) = OtherISRN;
        StatsBISR.NumN_ISR_SatNear(S) = NISRN;
        StatsBISR.NumResultBoth(S) = ResultBothCounterN;
        StatsBISR.NumE_ASCB(S) = E_ASCBN;
        StatsBISR.NumF_ASCB(S) = F_ASCBN;
        StatsBISR.NumEE(S) = EE_N;
        StatsBISR.NumEF(S) = EF_N;
        StatsBISR.NumEO(S) = EO_N;
        StatsBISR.NumFE(S) = FE_N;
        StatsBISR.NumFF(S) = FF_N;
        StatsBISR.NumFO(S) = FO_N;
    end
end

%calc sums across all year/frequencies
SumStats = num2cell(sum(StatsB{:,2:end},1));
SumStatsRow = {'Sum All',SumStats{:}};
StatsB = [StatsB; SumStatsRow];%catenate row

SumStatsISR = num2cell(sum(StatsBISR{:,2:end},1));
SumStatsISRRow = {'Sum All',SumStatsISR{:}};
StatsBISR = [StatsBISR; SumStatsISRRow];%catenate row
end