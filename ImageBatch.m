function [ScintData] = ImageBatch(ScintData, NumScintEvents, ASCBias,...
    MappedIndex, GoodIndex, xcart, ycart, zcart,...
    CloseBIndex, CloseBScreen, bxpix, bypix, bf_azel, RBRatio_Thresh)
% fill in ASI data for scintillating triplet data
% everything returned for each image EXCEPT EFcat

prnxpix = cell(NumScintEvents,1);
prnypix = cell(NumScintEvents,1);
gbrkr = cell(NumScintEvents,1);
rbratio = cell(NumScintEvents,1);
rbratio_NewGPS = rbratio;
EFcat_original = cell(NumScintEvents,1);
EFcat_new = cell(NumScintEvents,1);
EFcat_NewGPS = EFcat_new;
timestamps = cell(NumScintEvents,1);
StartAz = cell(NumScintEvents,1);
StartEl = StartAz;
EndAz = cell(NumScintEvents,1);
EndEl = EndAz;
% prnazel = cell(NumScintEvents,1);
% prnbtw = cell(NumScintEvents,1);
ScintData = addvars(ScintData,prnxpix,prnypix,gbrkr,rbratio,EFcat_original, EFcat_new, timestamps, StartAz, StartEl, EndAz, EndEl, EFcat_NewGPS, rbratio_NewGPS); %, prnazel, prnbtw);
%
% ind0 = [31, 32, 45, 409]; %AuroraBoolean was 0
% TestI = [193 194 198];
%     check = i == ind0;
%     if max(check) == 1
%         disp('pause');
%     end
%     i = 19;
for i = 1:NumScintEvents
    i
    %     if(i==20)
    %         error('stop');
    %     end
    PRN = ScintData.PRN(i);%%%PRN 30 IS BAD, OTHERS BAD SOMETIMES (16 Feb2014)
    %     prnazel = [];
    %     prnbtw = [];
    prnxpix = [];
    prnypix = [];
    gbrkr = [];
    prnazel = [];
    prnbtw = [];
    rbratio_original = [];
    rbratio_new = [];
    EFcat_original = string.empty;
    EFcat_new = string.empty;
    EFcat_NewGPS = string.empty;
    timestamps = NaT(0);
    %     prn = []; az= []; el = []; timelist = [];
    
    if(~isempty(ScintData.TripletASC{i}))
        %not sure how to check satellite health right now, use generic
        %error handling as workaround
        
        %         prnazel = ScintData.prnazel{i};
        %         prnbtw = ScintData.prnbtw{i};
        TripletASC = ScintData.TripletASC{i};
        Tripletprnbtw = ScintData.Tripletprnbtw{i};
        Tripletazel = ScintData.Tripletazel{i};
        %             Green_Data = zeros(512, 512, size(TripletASC,1));
        %             Red_Data = Green_Data;
        %             Blue_Data = Green_Data;
        %             prn = zeros(size(TripletASC,1), 1);
        %             az = prn; el = prn;
        ScintData.StartAz{i} = Tripletazel(1, 3);
        ScintData.StartEl{i} = Tripletazel(1, 4);
        ScintData.EndAz{i} = Tripletazel(end, 3);
        ScintData.EndEl{i} = Tripletazel(end, 4);
        for n=1:size(TripletASC,1) %n is number of triplets/snapshots
            i
            prnbtw = Tripletprnbtw(n, 2);
            prnazel = Tripletazel(n, 3:4);
            %                 n = 19
            GBRFITSname = TripletASC(n,:)'
            try
                %T~ variables are temps to append to list
                [Tprnazel, Tprnbtw, Tprnxpix, Tprnypix, Tgbrkr, Trbratio_original, Trbratio_new, TEFcat_original, TEFcat_new, timestamp,TEFcat_NewGPS, Trbratio_NewGPS] = ...
                    Imagerun(prnbtw, prnazel, ASCBias, MappedIndex, GoodIndex, xcart, ycart, zcart,...
                    CloseBIndex, CloseBScreen, bxpix, bypix, bf_azel, GBRFITSname, PRN, RBRatio_Thresh); %Script for spectral analysis of a GBR sequence of ASI images
                %                 EFcat_t1(end+1) = TEFcat;
                %                 EFcat_t2(end+1) = TEFcatO;
                %                 disp(["Original EF = " TEFcat " New EF = " TEFcatO ]);
                %, RData, GData, BData, prn1, AZ1, EL1
                %                     prnazel = [prnazel; Tprnazel];
                %                     prnbtw = [prnbtw; Tprnbtw];
                prnxpix = [prnxpix; Tprnxpix];
                prnypix = [prnypix; Tprnypix];
                gbrkr = [gbrkr; Tgbrkr];
                rbratio_original = [rbratio_original; Trbratio_original];
                rbratio_new = [rbratio_new; Trbratio_new];
                EFcat_original = [EFcat_original; TEFcat_original];
                EFcat_NewGPS = [EFcat_NewGPS; TEFcat_NewGPS];
                rbratio_NewGPS = [rbratio_NewGPS; Trbratio_NewGPS];
                EFcat_new = [EFcat_new; TEFcat_new];
                timestamps(end+1) = timestamp;
            catch
                prnxpix = [prnxpix; NaN];
                prnypix = [prnypix; NaN];
                gbrkr = [gbrkr; [NaN NaN NaN]];
                rbratio_original = [rbratio_original; NaN];
                rbratio_NewGPS = [rbratio_NewGPS; NaN];
                rbratio_new = [rbratio_new; NaN];
                EFcat_original = [EFcat_original; '-'];
                EFcat_NewGPS = [EFcat_NewGPS; '-'];
                EFcat_new = [EFcat_new; '-'];
                timestamps(end+1) = NaT;
            end
        end
        %                 avgGData = avgGData+TGData;
        %                 avgRData = avgRData+TRData;
        %                 avgBData = avgBData+TBData;
        %                 Green_Data(:,:,n) = GData;
        %                 Blue_Data(:,:,n) = BData;
        %                 Red_Data(:,:,n) = RData;
        %                 prn(end+1) = prn1; az(end+1) = AZ1; el(end+1) = EL1; timelist(end+1) = TIME;
        %                 ScintData.prnxpix{i} = [ScintData.prnxpix{i} prnxpix];
        %                 ScintData.prnypix{i} = [ScintData.prnypix{i} prnypix];
        
    end
    %             prnazel = [];
    %             prnbtw = [];
    %             prnxpix = [];
    %             prnypix = [];
    %             gbrkr = [];
    %             rbratio = [];
    %             timestamps = [];
    %             EFcat_original = string.empty;
    %             EFcat_new = string.empty;
    %     EFcat_t2 = EFcat_t2';
    ScintData.prnazel{i} = prnazel;
    ScintData.prnbtw{i} = prnbtw;
    ScintData.prnxpix{i} = prnxpix;
    ScintData.prnypix{i} = prnypix;
    ScintData.gbrkr{i} = gbrkr;
    ScintData.rbratio{i} = rbratio_original;
    ScintData.EFcat_original{i} = EFcat_original;
    ScintData.EFcat_new{i} = EFcat_new;
    ScintData.EFcat_NewGPS{i} = EFcat_NewGPS;
    ScintData.rbraito_NewGPS{i} = rbratio_NewGPS;
    ScintData.timestamps{i} = timestamps;
    %     ScintData.EFcatO{i} = EFcat;
    
    disp('end');
end