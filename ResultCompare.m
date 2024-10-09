function [ScintData] = ResultCompare(ScintData,NumScintEvents)
% counters
rEO = 0;%debugg counters added to ScintData, number of each ASC category through that row
rFO = 0;
rNO = NumScintEvents;
rEN = 0;%debugg counters added to ScintData, number of each ASC category through that row
rFN = 0;
rNN = NumScintEvents;
Ecounter = 0;%number of ASC timestamp E/F for each event
Fcounter = 0;

ASI_EFO = cell(NumScintEvents,1);
ASI_EF = cell(NumScintEvents,1);
runningE = cell(NumScintEvents,1);
runningF = cell(NumScintEvents,1);
runningN = cell(NumScintEvents,1);
ScintData = addvars(ScintData,ASI_EFO,ASI_EF,runningE,runningF,runningN);

for i=1:NumScintEvents%loop each event
    i
    %designate ASC E/F based on majority F vs. (E OR D)
    if ~isempty(ScintData.EFcat_original{i})
        EcounterO = 0;
        FcounterO = 0;
        EcounterN = 0;
        FcounterN = 0;
        for f=1:length(ScintData.EFcat_original{i})
            EFO = ScintData.EFcat_original{i};
            EFN = ScintData.EFcat_new{i};
            if strcmp(EFO(f),"F")
                FcounterO = FcounterO+1;
            elseif strcmp(EFO(f),"E")
                EcounterO = EcounterO+1;
            elseif strcmp(EFO(f),"D")
                EcounterO = EcounterO+1;
            elseif strcmp(EFO(f),"-")
                %do nothing
            else
                error('Error in ASI_EF. Values should only be F/E/D/-')
            end
            
            if strcmp(EFN(f),"F")
                FcounterN = FcounterN+1;
            elseif strcmp(EFN(f),"E")
                EcounterN = EcounterN+1;
            elseif strcmp(EFN(f),"D")
                EcounterN = EcounterN+1;
            elseif strcmp(EFN(f),"-")
                %do nothing
            else
                error('Error in ASI_EF. Values should only be F/E/D/-')
            end
        end
        if (EcounterO || FcounterO) %ie only designate if either are nonzero
            if (EcounterO > FcounterO)
                ScintData.ASI_EFO{i} = "E";
                rEO = rEO+1;
                rNO = rNO-1;
            else
                ScintData.ASI_EFO{i} = "F";
                rFO = rFO+1;
                rNO = rNO-1;
            end
        else
            ScintData.ASI_EFO{i} = "N";
        end
        
        if (EcounterN || FcounterN) %ie only designate if either are nonzero
            if (EcounterN > FcounterN)
                ScintData.ASI_EF{i} = "E";
                rEN = rEN+1;
                rNN = rNN-1;
            else
                ScintData.ASI_EF{i} = "F";
                rFN = rFN+1;
                rNN = rNN-1;
            end
        else
            ScintData.ASI_EF{i} = "N";
        end
        
        if((rEO+rFO+rNO)~=NumScintEvents)%should not trigger
            S
            i
            rEO
            rFO
            rNO;
            NumScintEvents
            error('Error in running counter of final ASI event classifications. E+F+remaining MUST= TotalNumScintEvents.')
        end
        ScintData.runningE{i}=rEO;
        ScintData.runningF{i}=rFO;
        ScintData.runningN{i}=rNO;
    else
        ScintData.ASI_EFO{i} = "N";
        ScintData.ASI_EF{i} = "N";
    end
end
end