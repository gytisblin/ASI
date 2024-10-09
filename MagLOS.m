function [ScintData] = MagLOS(ScintData,NumScintEvents,ASCBias,bxpix,bypix)
% fill in ASI data for scintillating triplet data
% everything returned for each image EXCEPT EFcat
BgbrkrN = cell(NumScintEvents,1);
BrbratioN = cell(NumScintEvents,1);
BEFcatN = cell(NumScintEvents,1);
BgbrkrO = cell(NumScintEvents,1);
BrbratioO = cell(NumScintEvents,1);
BEFcatO = cell(NumScintEvents,1);
ScintData = addvars(ScintData,BgbrkrO,BrbratioO,BEFcatO,BgbrkrN,BrbratioN,BEFcatN);

for i=1:NumScintEvents%min([NumScintEvents 3])
    BgbrkrO = [];
    BrbratioO = [];
    BEFcatO = string.empty;
    BgbrkrN = [];
    BrbratioN = [];
    BEFcatN = string.empty;
    
    %only check MagLOS if already have ASC result, since bad PRNs already
    %checked for it
    if ~strcmp(ScintData.EFcat_original{i},"N")
        if ~strcmp(ScintData.EFcat_original{i},"-")
            TripletASC = ScintData.TripletASC{i};
            for n=1:size(TripletASC,1) %n is number of triplets/snapshots
                i
                n
                if i ~= 647
                    if n ~= 55
                        GBRFITSname = TripletASC(n,:)';
                        if exist(GBRFITSname(1)) && exist(GBRFITSname(2)) && exist(GBRFITSname(3))
                            %T~ variables are temps to append to list
                            [TBgbrkr, TBrbratio, TBEFcat] = ImagerunB(ASCBias, bxpix, bypix, GBRFITSname);
                            BgbrkrO = [BgbrkrO; TBgbrkr];
                            BrbratioO = [BrbratioO; TBrbratio];
                            %ignore time n if no regular E/F categorization (ie sat far
                            %from B), which are blank "-"
                            try
                                if ~strcmp(ScintData.EFcat_original{i}(n),"-")
                                    BEFcatO = [BEFcatO; TBEFcat];
                                else
                                    BEFcatO = [BEFcatO; "-"];
                                end
                            catch
                                disp('pause');
                            end
                        else
                            disp('Does not exist');
                        end
                    end
                end
            end
        else
            BgbrkrO = [];
            BrbratioO = [];
            BEFcatO = string.empty;
        end
    end
    if ~strcmp(ScintData.EFcat_new{i},"N")
        if ~strcmp(ScintData.EFcat_new{i},"-")
            TripletASC = ScintData.TripletASC{i};
            for n=1:size(TripletASC,1) %n is number of triplets/snapshots
                i
                n
                if i ~= 647
                    if n ~= 55
                        GBRFITSname = TripletASC(n,:)';
                        %T~ variables are temps to append to list
                        [TBgbrkr, TBrbratio, TBEFcat] = ImagerunB(ASCBias, bxpix, bypix, GBRFITSname);
                        BgbrkrN = [BgbrkrN; TBgbrkr];
                        BrbratioN = [BrbratioN; TBrbratio];
                        %ignore time n if no regular E/F categorization (ie sat far
                        %from B), which are blank "-"
                        try
                            if ~strcmp(ScintData.EFcat_new{i}(n),"-")
                                BEFcatN = [BEFcatN; TBEFcat];
                            else
                                BEFcatN = [BEFcatN; "-"];
                            end
                        catch
                            disp('pause');
                        end
                    end
                end
            end
        else
            BgbrkrN = [];
            BrbratioN = [];
            BEFcatN = string.empty;
        end
    end
    
    ScintData.BgbrkrN{i} = BgbrkrN;
    ScintData.BrbratioN{i} = BrbratioN;
    ScintData.BEFcatN{i} = BEFcatN;
    ScintData.BgbrkrO{i} = BgbrkrO;
    ScintData.BrbratioO{i} = BrbratioO;
    ScintData.BEFcatO{i} = BEFcatO;
    
end
end