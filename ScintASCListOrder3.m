function [ScintData] = ScintASCListOrder3(ScintData, NumScintEvents)
% construct triplet ordered nx3 FITS and datetime arrays for each
% scintillation, ie complete triplet found within cloud free intervals
% and acceptable delays between images
% B - G < 6s
% R - G < 12s

TripletASC = cell(NumScintEvents,1);
TripletTime = cell(NumScintEvents,1);
Tripletprnbtw = cell(NumScintEvents,1);
Tripletazel = cell(NumScintEvents, 1);
ScintData = addvars(ScintData,TripletASC,TripletTime, Tripletprnbtw, Tripletazel);

g=0;
b=0;
r=0;
bgood=0;
rgood=0;

GASCSort = string.empty;
BASCSort = string.empty;
RASCSort = string.empty;
GASCprnbtw = [];
BASCprnbtw = [];
RASCprnbtw = [];
GTimeSort = datetime.empty;
BTimeSort = datetime.empty;
RTimeSort = datetime.empty;

TempTripletASC = ["" "" ""];
TempTripletTime = [NaT NaT NaT];

for i=1:NumScintEvents%min([NumScintEvents 1494])
    %     i=1
    TripletASC = string.empty;
    TripletTime = datetime.empty;
    Tripletazel = [];
    Tripletprnbtw = [];
    
    if((~isempty(ScintData.GASCSort{i}))&&(~isempty(ScintData.BASCSort{i}))...
            &&(~isempty(ScintData.RASCSort{i})))
        
        g=1;
        b=1;
        r=1;
        TempTripletASC = ["" "" ""];
        TempTripletTime = [NaT NaT NaT];
        TempTripletprnbtw = [0 0];
        TempTripletazel = [0 0];
        
        GASCSort = ScintData.GASCSort{i};
        BASCSort = ScintData.BASCSort{i};
        RASCSort = ScintData.RASCSort{i};
        GASCprnbtw = ScintData.GASCprnbtw{i};
        RASCprnbtw = ScintData.RASCprnbtw{i};
        BASCprnbtw = ScintData.BASCprnbtw{i};
        GASCazel = ScintData.GASCazel{i};
        BASCazel = ScintData.BASCazel{i};
        RASCazel = ScintData.RASCazel{i};
        GTimeSort = ScintData.GTimeSort{i};
        BTimeSort = ScintData.BTimeSort{i};
        RTimeSort = ScintData.RTimeSort{i};
        gmax=length(GASCSort);
        bmax=length(BASCSort);
        rmax=length(RASCSort);
        
        i
        while(g<=gmax)
            bgood=0;
            rgood=0;
            %first tick b/r until after g
            while((b<bmax) && (BTimeSort(b) < GTimeSort(g)))
                b=b+1
            end
            if((BTimeSort(b)>GTimeSort(g))&&(BTimeSort(b)<=(GTimeSort(g)+seconds(6))))
                bgood = 1
            end
            
            while((r<rmax) && (RTimeSort(r) < GTimeSort(g)))
                r=r+1
            end
            if((RTimeSort(r)>GTimeSort(g))&&(RTimeSort(r)<=(GTimeSort(g)+seconds(12))))
                rgood = 1
            end
            
            if (bgood && rgood)
                TempTripletASC = [GASCSort(g) BASCSort(b) RASCSort(r)]
                TempTripletTime = [GTimeSort(g) BTimeSort(b) RTimeSort(r)]
                TempTripletprnbtw = [GASCprnbtw(g) BASCprnbtw(b) RASCprnbtw(r)];
                TempTripletazel = [GASCazel(g,:) BASCazel(b,:) RASCazel(r,:)];
                TripletASC = [TripletASC; TempTripletASC];
                TripletTime = [TripletTime; TempTripletTime];
                Tripletprnbtw = [Tripletprnbtw; TempTripletprnbtw];
                Tripletazel = [Tripletazel; TempTripletazel];
            end
            
            g=g+1
        end
    end
    
    ScintData.TripletASC{i} = TripletASC;
    ScintData.TripletTime{i} = TripletTime;
    ScintData.Tripletprnbtw{i} = Tripletprnbtw;
    ScintData.Tripletazel{i} = Tripletazel;
end
end