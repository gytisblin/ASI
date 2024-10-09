%Gets the ang;e beween the PRN satellite and the magnetic zenith
function [ScintData] = PRNAnglebtw(ScintData, NumScintEvents, data_dir)
bf_azel = [205.7 77.5];
prnazel = cell(NumScintEvents,1);
prnbtw = cell(NumScintEvents,1);
ScintData = addvars(ScintData, prnazel, prnbtw);

for i = 1:NumScintEvents
    PRN = ScintData.PRN(i);
    prnazel = [];
    prnbtw = [];
    
    if ~isempty(ScintData.CloudFreeInterval{i})
        i
        y = ScintData.Year(i);
        doy = ScintData.DOY(i);
        [yy mm dd HH MM] = datevec(datenum(y,1,doy));
        eventfiles = ScintData.EventASCFiles{i};
        prnazel = cell(size(eventfiles, 2), 2);
        prnbtw = cell(size(eventfiles));
        for j = 1:size(eventfiles, 2)
            disp(j);
            eventfile = convertStringsToChars(eventfiles(j));
            HH = eventfile(end-14:end-13);
            MM = eventfile(end-12:end-11);
            SS = eventfile(end-10:end-9);
            mm_zero = ''; dd_zero = '';
            if mm < 10
                mm_zero = '0';
            end
            if dd < 10
                dd_zero = '0';
            end
            casetimestring = [num2str(yy) mm_zero num2str(mm) dd_zero num2str(dd) HH MM SS];
            casetimestr = datevec(casetimestring,'yyyymmddHHMMSS');
            casetime = datetime(casetimestr);
            try
                prnazel{j} = dazel_list(PRN,casetime, data_dir);
                prnbtw{j} = btwazel(bf_azel,prnazel{j});
            catch
                prnazel{j} = [];
                prnbtw{j} = [];
            end
        end
    end
    ScintData.prnazel{i} = prnazel;
    ScintData.prnbtw{i} = prnbtw;
end

end

%% Functions
function [anglebtw] = btwazel(azeld1,azeld2)
% IN
% azeld1,azeld2 = 1x2 [azimuth elevation] degree
% OUT
% anglebtw = degree angle between azel1 & azel2 unit vectors
azel1=azeld1*pi/180;
azel2=azeld2*pi/180;
[xyz1(1) xyz1(2) xyz1(3)] = sph2cart(azel1(1),azel1(2),1);
[xyz2(1) xyz2(2) xyz2(3)] = sph2cart(azel2(1),azel2(2),1);
% xyz1
% xyz2
anglebtw = acosd(dot(xyz1,xyz2) / (norm(xyz1)*norm(xyz2)));
end