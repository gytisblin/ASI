function [ScintData] = ResultCompareMagLOS(ScintData,NumScintEvents)
% counters
rE = 0;%debugg counters added to ScintData, number of each ASC category through that row
rF = 0;
rN = NumScintEvents;
Ecounter = 0;%number of ASC timestamp E/F for each event
Fcounter = 0;

ASI_BEFO = cell(NumScintEvents,1);
ASI_BEFN = cell(NumScintEvents,1);
runningE = cell(NumScintEvents,1);
runningF = cell(NumScintEvents,1);
runningN = cell(NumScintEvents,1);
prnbtwavg = cell(NumScintEvents,1);
ScintData = addvars(ScintData,ASI_BEFO, ASI_BEFN, prnbtwavg);

for i=1:NumScintEvents%loop each event
    %     i
    prnbtw = ScintData.prnbtw{i};
    allprnbtw = cell2mat(prnbtw);
    if ~isempty(allprnbtw)
        avgprnbtw = sum(allprnbtw)/length(allprnbtw);
        ScintData.prnbtwavg(i) = num2cell(avgprnbtw);
    end
    %designate ASC E/F based on majority F vs. (E OR D)
    if ~isempty(ScintData.BEFcatO{i})
        Ecounter = 0;
        Fcounter = 0;
        for f=1:length(ScintData.BEFcatO{i})
            if strcmp(ScintData.BEFcatO{i}(f),"F")
                Fcounter = Fcounter+1;
            elseif strcmp(ScintData.BEFcatO{i}(f),"E")
                Ecounter = Ecounter+1;
            elseif strcmp(ScintData.BEFcatO{i}(f),"D")
                Ecounter = Ecounter+1;
            elseif strcmp(ScintData.BEFcatO{i}(f),"-")
                %do nothing
            else
                error('Error in BEFcat. Values should only be F/E/D/-')
            end
        end
        if (Ecounter || Fcounter) %ie only designate if either are nonzero
            if (Ecounter > Fcounter)
                ScintData.ASI_BEFO{i} = "E";
                rE = rE+1;
                rN = rN-1;
            else
                ScintData.ASI_BEFO{i} = "F";
                rF = rF+1;
                rN = rN-1;
            end
        else
            ScintData.ASI_BEFO{i} = "N";
        end
        
        if((rE+rF+rN)~=NumScintEvents)%should not trigger
            S
            i
            rE
            rF
            rN
            NumScintEvents
            error('Error in running counter of final ASI event classifications. E+F+remaining MUST= TotalNumScintEvents.')
        end
        %         ScintData.runningE{i}=rE;
        %         ScintData.runningF{i}=rF;
        %         ScintData.runningN{i}=rN;
    else
        ScintData.ASI_BEFO{i} = "N";
    end
    if ~isempty(ScintData.BEFcatN{i})
        Ecounter = 0;
        Fcounter = 0;
        for f=1:length(ScintData.BEFcatN{i})
            if strcmp(ScintData.BEFcatN{i}(f),"F")
                Fcounter = Fcounter+1;
            elseif strcmp(ScintData.BEFcatN{i}(f),"E")
                Ecounter = Ecounter+1;
            elseif strcmp(ScintData.BEFcatN{i}(f),"D")
                Ecounter = Ecounter+1;
            elseif strcmp(ScintData.BEFcatN{i}(f),"-")
                %do nothing
            else
                error('Error in BEFcat. Values should only be F/E/D/-')
            end
        end
        if (Ecounter || Fcounter) %ie only designate if either are nonzero
            if (Ecounter > Fcounter)
                ScintData.ASI_BEFN{i} = "E";
                rE = rE+1;
                rN = rN-1;
            else
                ScintData.ASI_BEFN{i} = "F";
                rF = rF+1;
                rN = rN-1;
            end
        else
            ScintData.ASI_BEFN{i} = "N";
        end
        
        if((rE+rF+rN)~=NumScintEvents)%should not trigger
            S
            i
            rE
            rF
            rN
            NumScintEvents
            error('Error in running counter of final ASI event classifications. E+F+remaining MUST= TotalNumScintEvents.')
        end
        %         ScintData.runningE{i}=rE;
        %         ScintData.runningF{i}=rF;
        %         ScintData.runningN{i}=rN;
    else
        ScintData.ASI_BEFN{i} = "N";
    end
end
end