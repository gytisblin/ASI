% Script for spectral analysis of a GBR sequence of ASI images
% GBRFITSname = nx1 string array of names
function [prnazel, prnbtw, prnxpix, prnypix, gbrkr, rbratio_original, rbratio_avg, EFcat_original, EFcat_new, timestamp, EFcat_NewGPS, rbratio_NewGPS] =...
      	Imagerun(prnbtw, prnazel, ASCBias, MappedIndex, GoodIndex, xcart, ycart, zcart,...
      	CloseBIndex, CloseBScreen, bxpix, bypix, bf_azel, GBRFITSname, PRN, RBRatio_Thresh)


GreenFilename = GBRFITSname(1); %GBR order
BlueFilename = GBRFITSname(2);
RedFilename = GBRFITSname(3);
AzCal = fitsread('PKR_DASC_0558_20150213_Az.FIT');
ElCal = fitsread('PKR_DASC_0558_20150213_El.FIT');
% TargetFile = {GreenFilename;BlueFilename;RedFilename};
% TargetFile(1) = ASCFileList(1,GreenFilename);%column vector GBR order
% TargetFile(2) = ASCFileList(2,BlueFilename);
% TargetFile(3) = ASCFileList(3,RedFilename);
% ASCPlotter(TargetFile, 3)
% ASCPlotter10Deg(TargetFile, 4)

% fitsdisp(RedFilename,'Mode','full')
% FITSInfo = fitsinfo(RedFilename)
FITSFilename = GBRFITSname;
FITSData(1,:,:) = fitsread(GreenFilename); %GBR order
FITSData(2,:,:) = fitsread(BlueFilename);
FITSData(3,:,:) = fitsread(RedFilename);
% ASCPlotterAll(FITSData,FITSFilename,'counts', 0, 1, 5)

% % DarkTimes / Bias calculation
% DarkGreenFilename = 'PKR_DASC_0558_20140103_044807.677.FITS';
% DarkBlueFilename = 'PKR_DASC_0428_20140103_044811.911.FITS';
% DarkRedFilename = 'PKR_DASC_0630_20140103_044815.536.FITS';
% % DarkFilename = {DarkGreenFilename;DarkBlueFilename;DarkRedFilename};
% DarkData(1,:,:) = fitsread(DarkGreenFilename); %GBR order
% DarkData(2,:,:) = fitsread(DarkBlueFilename);
% DarkData(3,:,:) = fitsread(DarkRedFilename);
% % ASCPlotterAll(DarkData,DarkFilename,'counts', 0, 1, 6)
%
% % 12x12 bottom-right corner region (501:512,501:512) averaged, used as bias
% BiasRegion = DarkData(:,501:512,501:512);
% ASCBias = mean(BiasRegion, [2 3]);%

% k-Rayleigh = FreqCalib(from Don Hampton) * (FITS-Background)/(exposure time*1000)
ASCCal = [70; 105; 27]; %Rayleighs/count (for 1s exposure) GBR
t_exp = [1; 1; 1.5]; %seconds exposure, GBR (ie red=1.5s)
ASCRayData = repmat(ASCCal,1,512,512).*(FITSData - repmat(ASCBias,1,512,512)) ./ (1000*repmat(t_exp,1,512,512));
% DarkRayData = repmat(ASCCal,1,512,512).*(DarkData - repmat(ASCBias,1,512,512)) ./ (1000*repmat(t_exp,1,512,512));
% % ASCPlotterAll(ASCRayData,FITSFilename,'k-Rayleighs', 0, 1, 7)
% ASCPlotterAll(DarkRayData,FITSFilename,'k-Rayleighs', 0, 1, 8)

% 3 ratios - (R/B),(G/B),(R/G)
% set low elevations to 1 to prevent finding ratios of dark regions (noise)
% ElMapFileName = 'PKR_DASC_0558_20150213_El.FIT';
% ElData = fitsread(ElMapFileName);
% MappedIndex = find(~ElData); %linear indices of zero elevation pixels
ASCRay10Data = ASCRayData;
for i=1:3
	temp = squeeze(ASCRay10Data(i,:,:));
	temp(MappedIndex) = 1;
	ASCRay10Data(i,:,:) = temp;
end
RBData = ASCRay10Data(3,:,:)./ASCRay10Data(2,:,:);
GBData = ASCRay10Data(1,:,:)./ASCRay10Data(2,:,:);
RGData = ASCRay10Data(3,:,:)./ASCRay10Data(1,:,:);
RatioData = [RBData;GBData;RGData];
RBFilename = [FITSFilename(3) FITSFilename(2)];
GBFilename = [FITSFilename(1) FITSFilename(2)];
RGFilename = [FITSFilename(3) FITSFilename(1)];
RatioFilename = [RBFilename;GBFilename;RGFilename];

BData = ASCRay10Data(2,:,:);
GData = ASCRay10Data(1,:,:);
RData = ASCRay10Data(3,:,:);

% ASCPlotterAll(RatioData,RatioFilename,'ratio', 1, 1, 9)
%
% snaptime = datetime(2015,03,18,08,06,17);
% snapazel1 = dazel_list(25,snaptime)
% snapazel2 = dazel_list(29,snaptime)
% snapazel3 = dazel_list(31,snaptime)

% bf_azel = [205.7 77.5];

% anglesnap1 = btwazel(bf_azel,snapazel1)
% anglesnap2 = btwazel(bf_azel,snapazel2)
% anglesnap3 = btwazel(bf_azel,snapazel3)

% TEST = dazel_list(23,datetime(2015,10,07,06,20,00))
% ANGLECLOSE = btwazel(bf_azel,TEST)
% TEST2 = dazel_list(30,datetime(2014,11,16,09,20,00))
% ANGLECLOSE = btwazel(bf_azel,TEST2)
%
% TESTCLOSE = dazel_list(1,datetime(2014,11,16,01,00,00))
% ANGLECLOSE = btwazel(bf_azel,TESTCLOSE)
%
% TESTCLOSEF = dazel_list(1,datetime(2014,11,16,01,15,00))
% ANGLECLOSEF = btwazel(bf_azel,TESTCLOSEF)

% find angle between all points on ASC grid to find nearest pixel to LOS
% AzMapFileName = 'PKR_DASC_0558_20150213_Az.FIT';
% AzData = fitsread(AzMapFileName);
% GoodIndex = find(ElData);
% ElMapFileName = 'PKR_DASC_0558_20150213_El.FIT';
% ElData = fitsread(ElMapFileName);
% create xyz grid for pixels
% ascazel(1,:,:) = permute(AzData,[3 1 2]);%[2x512x512] [az=1/el=2 by X by Y]
% ascazel(2,:,:) = permute(ElData,[3 1 2]);
% ascxyz = zeros(3,512,512);%[3x512x512] [x=1/y=2/z=3 by X by Y]
% xcart = zeros(512,512);%transform back to this from linear
% ycart = zeros(512,512);
% zcart = zeros(512,512);
% AzDataLin = AzData(:);
% ElDataLin = ElData(:);
% dummyones = ones(512,512);
% [xcart(GoodIndex) ycart(GoodIndex) zcart(GoodIndex)]  = ...
% 	sph2cart(deg2rad(AzData(GoodIndex)),deg2rad(ElData(GoodIndex)),dummyones(GoodIndex));
%
% % now from xyz of full asc find map of angle between it and bf_azel
% bf_anglebtw = 30*ones(512,512);%initialize greater than cutoff
%
% bf_anglebtw(GoodIndex) = btwazel_xyzmap(bf_azel,xcart(GoodIndex),ycart(GoodIndex),zcart(GoodIndex));
% % figure(10);imagesc(bf_anglebtw);
%
% CloseBIndex = find(bf_anglebtw<=25);
% CloseBScreen = zeros(512,512);
% CloseBScreen(CloseBIndex) = 1;
% % figure(11);imagesc(CloseBScreen);
%
% % find closest pixel x,y to bf, ie minimize anglebtw AFTER screen
% ScreenAngle = CloseBScreen.*bf_anglebtw;
% figure(12);imagesc(ScreenAngle);
%
% [bxpix,bypix,minangle] = minanglefind(ScreenAngle, CloseBIndex);
% figure(12);hold on;
% plot(bypix,bxpix,'xr')


% for i=1:length(GBRFITSname)
% only care about blue timing i=2
	i=2;
	TempTimeStr = GBRFITSname(i);
	TempTimeStr = strtok(TempTimeStr,'.'); %part before .###.FITS
	TempStrParts = split(TempTimeStr,'_');%1xNimagesx5 array, (1,N,5)=HHMMSS for each image
	casetimestring = (strcat(TempStrParts(4),TempStrParts(5)));
    % end
    casetimestr=datevec(casetimestring,'yyyymmddHHMMSS');
%     testtime = datetime(2015, 3, 18, 8, 6, 17);
    casetime = datetime(casetimestr);
    timestamp = casetime;
    
    % % overlay ASI with PRN, BF locations
    tempdata = squeeze(RBData);
    % % find prn locations
    % % this case prn 25,29,31
    % casetime = datetime(2015,03,18,08,06,17)
disp([PRN casetimestr]);  %debug
% prnazel = dazel_list(PRN,casetime);
% az = prnazel(1); el = prnazel(2);
% prnbtw = btwazel(bf_azel,prnazel);

% % find angles
prn_anglebtw = 30*ones(512,512);%initialize greater than cutoff
% find best pixel
prn_anglebtw(GoodIndex) = btwazel_xyzmap(prnazel,xcart(GoodIndex),ycart(GoodIndex),zcart(GoodIndex));
% % if min is less than 30 in restricted view, then spectral pixel is min
% figure(13);imagesc(prn_anglebtw);
[prnxpix,prnypix,prnminGRID] = minanglefind(prn_anglebtw, GoodIndex);
% figure(13);hold on;
% plot(prnypix,prnxpix,'rx','LineWidth',3,'MarkerEdgeColor','r','MarkerSize',10)
% plot(bypix,bxpix,'go','LineWidth',3,'MarkerEdgeColor','g','MarkerSize',10)

gbrkr = ASCRay10Data(:,prnxpix,prnypix);
gbrkr = gbrkr';
% testtime = datetime(2015, 3, 18, 8, 6, 17);
rbratio_all = zeros(9,1);
rbratio_all(1) = RBData(1,prnxpix,prnypix);
rbratio_all(2) = RBData(1,prnxpix-1,prnypix+1);
rbratio_all(3) = RBData(1,prnxpix,prnypix+1);
rbratio_all(4) = RBData(1,prnxpix+1,prnypix+1);
rbratio_all(5) = RBData(1,prnxpix-1,prnypix);
rbratio_all(6) = RBData(1,prnxpix+1,prnypix);
rbratio_all(7) = RBData(1,prnxpix-1,prnypix-1);
rbratio_all(8) = RBData(1,prnxpix,prnypix-1);
rbratio_all(9) = RBData(1,prnxpix+1,prnypix-1);
rbratio_avg = sum(rbratio_all)/numel(rbratio_all);
rbratio_original = rbratio_all(1);
% DiffAz = abs(AzCal - prnazel(k, j, 1));
% DiffEl = abs(ElCal - prnazel(k, j, 2));
% Diff = DiffAz + DiffEl;
% [prnypix2, prnxpix2] = find(Diff == min(min(Diff)));
% rbratio_NewGPS = RBData(1, prnypix2, prnxpix2);

% if casetime == testtime
%     disp('pause');
%     load('asi03182015_data.mat');
%     if PRN_s(1) == 0
%         ti = 1;
%     elseif PRN_s(2) == 0
%         ti = 2;
%     else
%         ti = 3;
%     end
%     PRN_s(ti) = PRN;
%     RData_s{ti} = RData;
%     GData_s{ti} = GData;
%     BData_s{ti} = BData;
%     catetime_s{ti} = casetime;
%     prnazel_s{ti} = prnazel;
%     prnxpix_s(ti) = prnxpix;
%     prnypix_s(ti) = prnypix;
%     bxpix_s(ti) = bxpix;
%     bypix_s(ti) = bypix;
%     save('asi03182015_data.mat', 'PRN_s', 'RData_s', 'BData_s', 'GData_s', 'catetime_s', 'prnazel_s', 'prnxpix_s', 'prnypix_s', 'bxpix_s', 'bypix_s')
%     
% end
% if casetime == testtime
%     rbratio_original
%     f = figure;
%     prnxpixx = [prnxpix+1 prnxpix+1 prnxpix+1 prnxpix prnxpix prnxpix prnxpix-1 prnxpix-1 prnxpix-1];
%     prnypixx = [prnypix+1 prnypix-1 prnypix prnypix+1 prnypix-1 prnypix prnypix+1 prnypix-1 prnypix];
%     prn_anglebtw(prnxpixx, prnypixx) = 1000;
%     
%     imagesc(prn_anglebtw);
%     hold on;
%     scatter(prnypix, prnxpix, 'red', 'filled');
%     colorbar;
%     title('Angle Between PRN azel and other pixels on the ASI');
%     
%     f1 = figure;
%     imagesc(squeeze(RBData));
% %     hold on;
%     disp('pause');
% end


% test = squeeze(RBData);
% % neg_ind = find(test < 0);
% one_ind = find(test == 1);
% test(neg_ind) = 0;
% % test(one_ind) = 0;
% f1 = figure; figure(f1);
% test = flip(test);
% imagesc(test);
% hold on
% colorbar; caxis([0 0.9]);
% title(['RBData ' num2str(casetimestr)]);
% scatter(bxpix, bypix, 20, 'go', 'LineWidth', 2);
% scatter(prnxpix, prnypix, 20, 'mx', 'LineWidth', 2)

% 
% f2 = figure; figure(f2);
% GData = ASCRay10Data(1,:,:);
% neg_ind = find(GData<0); GData(neg_ind) = 0; %GData = flip(GData);
% GData = squeeze(GData);
% imagesc(GData);
% colorbar;
% title(['GData ' num2str(casetimestr)]);
% 
% f3 = figure; figure(f3);
% RData = ASCRay10Data(3,:,:);
% RData = squeeze(RData);
% neg_ind = find(RData<0); RData(neg_ind) = 0; %RData = flip(RData);
% imagesc(RData);
% colorbar;
% title(['RData ' num2str(casetimestr)]);
% 
% f4 = figure; figure(f4);
% BData = ASCRay10Data(2,:,:);
% BData = squeeze(BData);
% neg_ind = find(BData<0); BData(neg_ind) = 0; %BData = flip(BData);
% imagesc(BData);
% colorbar;
% title(['BData ' num2str(casetimestr)]);
% 
% close(f1); close(f2); close(f3); close(f4);

% save('data_201424.mat', 'RBData', 'bxpix', 'bypix', 'prnxpix', 'prnypix', 'PRN');



% ASCPlotterCase1(Case1Data,'St. Patricks Day Storm - March 18, 2015 08:06:17 UTC','630nm / 428nm ratio', 1, 1, 15,...
% 	prnxpix, prnypix, bxpix, bypix)

EFcat_original = "-";%string.empty;
EFcat_new = "-";
EFcat_NewGPS = "-";
rbratio_NewGPS = NaN;

if (prnbtw<=25)
	EFcat_original = ratio2layer(rbratio_original);
    EFcat_new = ratio2layer(rbratio_avg);
%     EFcat_NewGPS = ratio2layer(rbratio_NewGPS);
end

end

function [layer] = ratio2layer(ratio)
% IN/OUT: nx1 vector
layer=strings(length(ratio),1);
layer(find(ratio>0.5))="F";
layer(find(ratio<=0.5))="E";
layer(find(ratio<0.06))="D";
end

function [xpixel,ypixel,minangle] = minanglefind(anglemat, CloseBIndex)
linview = anglemat(CloseBIndex);
[minangle, Itemp] = min(linview,[],'linear');
[xpixel,ypixel,] = find(anglemat==minangle);
end

function [anglebtw] = btwazel_xyzmap(azeld1,xcart,ycart,zcart)
% IN
% azeld1 = 1x2 [azimuth elevation] degree
% xcart,ycart,zcart = nx1 vectors of cartesian vector coords
% OUT
% anglebtw = nx1 degree angle between azel1 & azel2 unit vectors
azel1=azeld1*pi/180;
[xyz1(1) xyz1(2) xyz1(3)] = sph2cart(azel1(1),azel1(2),1);
% create repeating array equal in size to xcart, etc
% xyz1 = xyz1';
xyz1 = (repmat(xyz1,length(xcart),1))';
xyz2 = [xcart ycart zcart]';
% [xyz2(1) xyz2(2) xyz2(3)] = sph2cart(azel2(1),azel2(2),1);
% xyz1
% xyz2
anglebtw = acosd(dot(xyz1,xyz2) ./ (vecnorm(xyz1).*vecnorm(xyz2))); %1xn
anglebtw = anglebtw'; %nx1
end

function [anglebtw] = btwazel_xyz(azeld1,xyz2)
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

function ASCPlotterCase1(FITSData, TitleStr, ColorbName, Trim10Flag, ScaleFlag, FigNum,...
	prnx1, prny1, bx, by)
% Function to plot 3 separate channel ASC images
% (only plots, no calculations)
% Blue/Green/RedData etc are CALIBRATED values to plot (Rayleighs)
% FITSData = GBR by default (channel,row,column)
% ColorbName = name of colorbar, ie units plotting
% Trim10Flag = 1, set elevations<10 to 0 (circular frame)
% ScaleFlag = 1, scale min and max of plot to cutoffs (for visibility)
% FigNum figure number to plot on

ElMapFileName = 'PKR_DASC_0558_20150213_El.FIT';
ElData = fitsread(ElMapFileName);
MappedIndex = find(~ElData); %linear indices of zero elevation pixels

lowerCutoff = .01; %lower and upper percentile (1.0=max)to scale graphs to
upperCutoff = .995;
figure(FigNum);   

% for k=1:3
% 	ChannelData = squeeze(FITSData(k,:,:));
	ChannelData = FITSData;
	if(Trim10Flag)
    	ChannelData(MappedIndex) = 0;
	end
%   find min and max to scale to defined by cutoffs
%   sort FITSData, then find value at min/max postion, rounding postion
%   index up/down
	if(ScaleFlag)
    	TempData = ChannelData(:);
    	sortData = sort(TempData(TempData>0));
    	minIndex = ceil(lowerCutoff*length(sortData));
    	maxIndex = floor(upperCutoff*length(sortData));
    	ScaleMax = [sortData(minIndex) sortData(maxIndex)]; %[min max]
	else
    	ScaleMax = [min(ChannelData) max(ChannelData)]; %[min max]
	end
% 	SingleName= {'-CH4 558nm Green';'-CH1 428nm Blue';'-CH5 630nm Red'};
% 	RatioName = {'-CH5 630nm Red'   '-CH1 428nm Blue';...
%              	'-CH4 558nm Green' '-CH1 428nm Blue';...
%              	'-CH5 630nm Red'   '-CH4 558nm Green'};
    
% 	extract timestamp from filenames
% 	for i=1:size(FITSFilename,2)%to handle ratio graphs with 2 filenames
%     	TempDateStr = FITSFilename{k,i};
%     	TempDateStr = strtok(TempDateStr,'.'); %part before .###.FITS
%     	TempStrParts = strsplit(TempDateStr,'_');%1x5 cell, 3=ch wavelength###, 4=yyyymmdd, 5=HHMMSS
%     	Date = datetime(datevec(strcat(TempStrParts{4},'/',TempStrParts{5}), 'yyyymmdd/HHMMSS'));
%     	if(size(FITSFilename,2)==1)
%         	TitleStr((2*i -1):(2*i)) = {FITSFilename{k,i}; strcat(datestr(Date),SingleName{k})};
%     	elseif(size(FITSFilename,2)==2)
%         	TitleStr((2*i -1):(2*i)) = {FITSFilename{k,i}; strcat(datestr(Date),RatioName{k,i})};
%     	else
%         	error('error in FITFilename dimensions');
%     	end
% 	end
% 	subplot(1,3,k);
	imagesc(ChannelData, ScaleMax);hold on;
% 	prnx1, prny1, prnx2, prny2, prnx3, prny3, bx, by)
	plot(prny1,prnx1,'+m','LineWidth',3,'MarkerEdgeColor','m','MarkerSize',10)
% 	plot(prny2,prnx2,'^m','LineWidth',3,'MarkerEdgeColor','m','MarkerSize',10)
% 	plot(prny3,prnx3,'rx','LineWidth',3,'MarkerEdgeColor','r','MarkerSize',10)
	plot(by,bx,'go','LineWidth',3,'MarkerEdgeColor','g','MarkerSize',10)
% 	legend('PRN25','PRN29','PRN31','B Line');
	colorbar;
	title(TitleStr, 'Interpreter', 'none','FontSize',16);
% 	t=title;
% 	t.FontSize=20;
	h = colorbar;
	h.FontSize = 15;
	ylabel(h,ColorbName);
set(gca,'xtick',[])
set(gca,'xticklabel',[])
set(gca,'ytick',[])
set(gca,'yticklabel',[])
% end
set(gcf, 'Position',  [100, 0, 760, 600])

end %end function

function ASCPlotterAll(FITSData, FITSFilename, ColorbName, Trim10Flag, ScaleFlag, FigNum)
% Function to plot 3 separate channel ASC images
% (only plots, no calculations)
% Blue/Green/RedData etc are CALIBRATED values to plot (Rayleighs)
% FITSData = GBR by default (channel,row,column)
% ColorbName = name of colorbar, ie units plotting
% Trim10Flag = 1, set elevations<10 to 0 (circular frame)
% ScaleFlag = 1, scale min and max of plot to cutoffs (for visibility)
% FigNum figure number to plot on

ElMapFileName = 'PKR_DASC_0558_20150213_El.FIT';
ElData = fitsread(ElMapFileName);
MappedIndex = find(~ElData); %linear indices of zero elevation pixels

lowerCutoff = .01; %lower and upper percentile (1.0=max)to scale graphs to
upperCutoff = .995;
figure(FigNum);   

for k=1:3
	ChannelData = squeeze(FITSData(k,:,:));
	if(Trim10Flag)
    	ChannelData(MappedIndex) = 0;
	end
%   find min and max to scale to defined by cutoffs
%   sort FITSData, then find value at min/max postion, rounding postion
%   index up/down
	if(ScaleFlag)
    	TempData = ChannelData(:);
    	sortData = sort(TempData(TempData>0));
    	minIndex = ceil(lowerCutoff*length(sortData));
    	maxIndex = floor(upperCutoff*length(sortData));
    	ScaleMax = [sortData(minIndex) sortData(maxIndex)]; %[min max]
	else
    	ScaleMax = [min(ChannelData) max(ChannelData)]; %[min max]
	end
	SingleName= {'-CH4 558nm Green';'-CH1 428nm Blue';'-CH5 630nm Red'};
	RatioName = {'-CH5 630nm Red'   '-CH1 428nm Blue';...
             	'-CH4 558nm Green' '-CH1 428nm Blue';...
             	'-CH5 630nm Red'   '-CH4 558nm Green'};
    
% 	extract timestamp from filenames
	for i=1:size(FITSFilename,2)%to handle ratio graphs with 2 filenames
    	TempDateStr = FITSFilename{k,i};
    	TempDateStr = strtok(TempDateStr,'.'); %part before .###.FITS
    	TempStrParts = strsplit(TempDateStr,'_');%1x5 cell, 3=ch wavelength###, 4=yyyymmdd, 5=HHMMSS
    	Date = datetime(datevec(strcat(TempStrParts{4},'/',TempStrParts{5}), 'yyyymmdd/HHMMSS'));
    	if(size(FITSFilename,2)==1)
        	TitleStr((2*i -1):(2*i)) = {FITSFilename{k,i}; strcat(datestr(Date),SingleName{k})};
    	elseif(size(FITSFilename,2)==2)
        	TitleStr((2*i -1):(2*i)) = {FITSFilename{k,i}; strcat(datestr(Date),RatioName{k,i})};
    	else
        	error('error in FITFilename dimensions');
    	end
	end
	subplot(1,3,k);
	imagesc(ChannelData, ScaleMax);
	colorbar;
	title(TitleStr, 'Interpreter', 'none');
	h = colorbar;
	ylabel(h,ColorbName);
end
set(gcf, 'Position',  [100, 0, 1800, 450])

end %end function

function ASCPlotter(FITSFilename, FigNum)
% Function to plot 3 separate channel ASC images (from same time)
% cell~FITSFileName {ch1(purp) ch4(gr) ch5(red)}
% FigNum is figure number to plot on

lowerCutoff = .01; %lower and upper percentile (1.0=max)to scale graphs to
upperCutoff = .995;
figure(FigNum);   

FITSFilename

for k=1:3
	FITSData = fitsread(FITSFilename{k});
%   find min and max to scale to defined by cutoffs
%   sort FITSData, then find value at min/max postion, rounding postion
%   index up/down
	sortData = sort(FITSData(:));
	minIndex = ceil(lowerCutoff*length(sortData));
	maxIndex = floor(upperCutoff*length(sortData));
	ScaleMax = [sortData(minIndex) sortData(maxIndex)]; %[min max]
    
% 	extract timestamp from filename
	TempDateStr = FITSFilename{k};
	TempDateStr = strtok(TempDateStr,'.'); %part before .###.FITS
	TempStrParts = strsplit(TempDateStr,'_');%1x5 cell, 3=ch wavelength###, 4=yyyymmdd, 5=HHMMSS
	Date = datetime(datevec(strcat(TempStrParts{4},'/',TempStrParts{5}), 'yyyymmdd/HHMMSS'));

	if (k==1)
    	TitleStr = {FITSFilename{k}; strcat(datestr(Date),'-CH4 558nm Green')};
	elseif (k==2)
    	TitleStr = {FITSFilename{k}; strcat(datestr(Date),'-CH1 428nm Blue')};
	elseif (k==3)
    	TitleStr = {FITSFilename{k}; strcat(datestr(Date),'-CH5 630nm Red')};
	end
    
	subplot(1,3,k);
% 	subplot(2,2,k);
	imagesc(FITSData, ScaleMax);
	colorbar;
	title(TitleStr, 'Interpreter', 'none');
end
set(gcf, 'Position',  [100, 0, 1800, 450])

end %end function

function ASCPlotter10Deg(FITSFilename, FigNum)
% Function to plot 3 separate channel ASC images (from same time)
% cell~FITSFileName {ch1(purp) ch4(gr) ch5(red)}
% FigNum is figure number to plot on

ElMapFileName = 'PKR_DASC_0558_20150213_El.FIT';
ElData = fitsread(ElMapFileName);
MappedIndex = find(~ElData); %linear indices of zero elevation pixels

lowerCutoff = .005; %lower and upper percentile (1.0=max)to scale graphs to
upperCutoff = .995;
figure(FigNum);   

FITSFilename

for k=1:3
	FITSData = fitsread(FITSFilename{k});
%   find min and max to scale to defined by cutoffs
%   sort FITSData, then find value at min/max postion, rounding postion
%   index up/down
	FITSData(MappedIndex) = 0; %set pixels below 10deg elevation->0

	TempData = FITSData(:);
	sortData = sort(TempData(TempData>0));
	minIndex = ceil(lowerCutoff*length(sortData));
	maxIndex = floor(upperCutoff*length(sortData));
	ScaleMax = [sortData(minIndex) sortData(maxIndex)]; %[min max]
% 	FITSData(MappedIndex) = 0; %set pixels below 10deg elevation->0
    
% 	extract timestamp from filename
	TempDateStr = FITSFilename{k};
	TempDateStr = strtok(TempDateStr,'.'); %part before .###.FITS
	TempStrParts = strsplit(TempDateStr,'_');%1x5 cell, 3=ch wavelength###, 4=yyyymmdd, 5=HHMMSS
	Date = datetime(datevec(strcat(TempStrParts{4},'/',TempStrParts{5}), 'yyyymmdd/HHMMSS'));

	if (k==1)
    	TitleStr = {FITSFilename{k}; strcat(datestr(Date),'-CH4 558nm Green')};
	elseif (k==2)
    	TitleStr = {FITSFilename{k}; strcat(datestr(Date),'-CH1 428nm Blue')};
	elseif (k==3)
    	TitleStr = {FITSFilename{k}; strcat(datestr(Date),'-CH5 630nm Red')};
	end
    
	subplot(1,3,k);
	imagesc(FITSData, ScaleMax);
	colorbar;
	title(TitleStr, 'Interpreter', 'none');
end
set(gcf, 'Position',  [100, 0, 1800, 450])
end


%%Changed
% % Script for spectral analysis of a GBR sequence of ASI images
% % GBRFITSname = nx1 string array of names
% function [prnazel, prnbtw, prnxpix, prnypix, gbrkr, rbratio, EFcat, EFcatO] =...
%           Imagerun(ASCBias, MappedIndex, GoodIndex, xcart, ycart, zcart,...
%           CloseBIndex, CloseBScreen, bxpix, bypix, bf_azel, GBRFITSname, PRN)
% 
% 
% GreenFilename = GBRFITSname(1); %GBR order
% BlueFilename = GBRFITSname(2);
% RedFilename = GBRFITSname(3);
% % TargetFile = {GreenFilename;BlueFilename;RedFilename};
% % TargetFile(1) = ASCFileList(1,GreenFilename);%column vector GBR order
% % TargetFile(2) = ASCFileList(2,BlueFilename);
% % TargetFile(3) = ASCFileList(3,RedFilename);
% % ASCPlotter(TargetFile, 3)
% % ASCPlotter10Deg(TargetFile, 4)
% 
% % fitsdisp(RedFilename,'Mode','full')
% % FITSInfo = fitsinfo(RedFilename)
% FITSFilename = GBRFITSname;
% FITSData(1,:,:) = fitsread(GreenFilename); %GBR order
% FITSData(2,:,:) = fitsread(BlueFilename);
% FITSData(3,:,:) = fitsread(RedFilename);
% % ASCPlotterAll(FITSData,FITSFilename,'counts', 0, 1, 5)
% 
% % % DarkTimes / Bias calculation
% % DarkGreenFilename = 'PKR_DASC_0558_20140103_044807.677.FITS';
% % DarkBlueFilename = 'PKR_DASC_0428_20140103_044811.911.FITS';
% % DarkRedFilename = 'PKR_DASC_0630_20140103_044815.536.FITS';
% % % DarkFilename = {DarkGreenFilename;DarkBlueFilename;DarkRedFilename};
% % DarkData(1,:,:) = fitsread(DarkGreenFilename); %GBR order
% % DarkData(2,:,:) = fitsread(DarkBlueFilename);
% % DarkData(3,:,:) = fitsread(DarkRedFilename);
% % % ASCPlotterAll(DarkData,DarkFilename,'counts', 0, 1, 6)
% % 
% % % 12x12 bottom-right corner region (501:512,501:512) averaged, used as bias
% % BiasRegion = DarkData(:,501:512,501:512);
% % ASCBias = mean(BiasRegion, [2 3]);%
% 
% % k-Rayleigh = FreqCalib(from Don Hampton) * (FITS-Background)/(exposure time*1000)
% ASCCal = [70; 105; 27]; %Rayleighs/count (for 1s exposure) GBR
% t_exp = [1; 1; 1.5]; %seconds exposure, GBR (ie red=1.5s)
% ASCRayData = repmat(ASCCal,1,512,512).*(FITSData - repmat(ASCBias,1,512,512)) ./ (1000*repmat(t_exp,1,512,512));
% % DarkRayData = repmat(ASCCal,1,512,512).*(DarkData - repmat(ASCBias,1,512,512)) ./ (1000*repmat(t_exp,1,512,512));
% % % ASCPlotterAll(ASCRayData,FITSFilename,'k-Rayleighs', 0, 1, 7)
% % ASCPlotterAll(DarkRayData,FITSFilename,'k-Rayleighs', 0, 1, 8)
% 
% % 3 ratios - (R/B),(G/B),(R/G)
% % set low elevations to 1 to prevent finding ratios of dark regions (noise)
% % ElMapFileName = 'PKR_DASC_0558_20150213_El.FIT';
% % ElData = fitsread(ElMapFileName);
% % MappedIndex = find(~ElData); %linear indices of zero elevation pixels
% ASCRay10Data = ASCRayData;
% for i=1:3
%     temp = squeeze(ASCRay10Data(i,:,:));
%     temp(MappedIndex) = 1;
%     ASCRay10Data(i,:,:) = temp;
% end
% RBData = ASCRay10Data(3,:,:)./ASCRay10Data(2,:,:);
% GBData = ASCRay10Data(1,:,:)./ASCRay10Data(2,:,:);
% RGData = ASCRay10Data(3,:,:)./ASCRay10Data(1,:,:);
% RatioData = [RBData;GBData;RGData];
% RBFilename = [FITSFilename(3) FITSFilename(2)];
% GBFilename = [FITSFilename(1) FITSFilename(2)];
% RGFilename = [FITSFilename(3) FITSFilename(1)];
% RatioFilename = [RBFilename;GBFilename;RGFilename];
% % ASCPlotterAll(RatioData,RatioFilename,'ratio', 1, 1, 9)
% % 
% % snaptime = datetime(2015,03,18,08,06,17);
% % snapazel1 = dazel_list(25,snaptime)
% % snapazel2 = dazel_list(29,snaptime)
% % snapazel3 = dazel_list(31,snaptime)
% 
% % bf_azel = [205.7 77.5];
% 
% % anglesnap1 = btwazel(bf_azel,snapazel1)
% % anglesnap2 = btwazel(bf_azel,snapazel2)
% % anglesnap3 = btwazel(bf_azel,snapazel3)
% 
% % TEST = dazel_list(23,datetime(2015,10,07,06,20,00))
% % ANGLECLOSE = btwazel(bf_azel,TEST)
% % TEST2 = dazel_list(30,datetime(2014,11,16,09,20,00))
% % ANGLECLOSE = btwazel(bf_azel,TEST2)
% % 
% % TESTCLOSE = dazel_list(1,datetime(2014,11,16,01,00,00))
% % ANGLECLOSE = btwazel(bf_azel,TESTCLOSE)
% % 
% % TESTCLOSEF = dazel_list(1,datetime(2014,11,16,01,15,00))
% % ANGLECLOSEF = btwazel(bf_azel,TESTCLOSEF)
% 
% % find angle between all points on ASC grid to find nearest pixel to LOS
% % AzMapFileName = 'PKR_DASC_0558_20150213_Az.FIT';
% % AzData = fitsread(AzMapFileName);
% % GoodIndex = find(ElData);
% % ElMapFileName = 'PKR_DASC_0558_20150213_El.FIT';
% % ElData = fitsread(ElMapFileName);
% % create xyz grid for pixels
% % ascazel(1,:,:) = permute(AzData,[3 1 2]);%[2x512x512] [az=1/el=2 by X by Y]
% % ascazel(2,:,:) = permute(ElData,[3 1 2]);
% % ascxyz = zeros(3,512,512);%[3x512x512] [x=1/y=2/z=3 by X by Y]
% % xcart = zeros(512,512);%transform back to this from linear
% % ycart = zeros(512,512);
% % zcart = zeros(512,512);
% % AzDataLin = AzData(:);
% % ElDataLin = ElData(:);
% % dummyones = ones(512,512);
% % [xcart(GoodIndex) ycart(GoodIndex) zcart(GoodIndex)]  = ...
% %     sph2cart(deg2rad(AzData(GoodIndex)),deg2rad(ElData(GoodIndex)),dummyones(GoodIndex));
% % 
% % % now from xyz of full asc find map of angle between it and bf_azel
% % bf_anglebtw = 30*ones(512,512);%initialize greater than cutoff
% % 
% % bf_anglebtw(GoodIndex) = btwazel_xyzmap(bf_azel,xcart(GoodIndex),ycart(GoodIndex),zcart(GoodIndex));
% % % figure(10);imagesc(bf_anglebtw);
% % 
% % CloseBIndex = find(bf_anglebtw<=25);
% % CloseBScreen = zeros(512,512);
% % CloseBScreen(CloseBIndex) = 1;
% % % figure(11);imagesc(CloseBScreen);
% % 
% % find closest pixel x,y to bf, ie minimize anglebtw AFTER screen
% % ScreenAngle = CloseBScreen.*bf_anglebtw;
% % figure(12);imagesc(ScreenAngle);
% % 
% % [bxpix,bypix,minangle] = minanglefind(ScreenAngle, CloseBIndex);
% % figure(12);hold on;
% % plot(bypix,bxpix,'xr')
% 
% 
% % for i=1:length(GBRFITSname)
% % only care about blue timing i=2
%     i=2;
%     TempTimeStr = GBRFITSname(i);
%     TempTimeStr = strtok(TempTimeStr,'.'); %part before .###.FITS
%     TempStrParts = split(TempTimeStr,'_');%1xNimagesx5 array, (1,N,5)=HHMMSS for each image
%     casetimestring = (strcat(TempStrParts(4),TempStrParts(5)));
% % end
% casetimestr=datevec(casetimestring,'yyyymmddHHMMSS');
% casetime = datetime(casetimestr);
% 
% % % overlay ASI with PRN, BF locations
% tempdata = squeeze(RBData);
% % % find prn locations
% % % this case prn 25,29,31
% % casetime = datetime(2015,03,18,08,06,17)
% disp([PRN casetimestr]);  %debug
% [prnazel] = dazel_list(PRN,casetime);
% prnbtw = btwazel(bf_azel,prnazel);
% % % find angles
% prn_anglebtw = 30*ones(512,512);%initialize greater than cutoff
% % test11_anglebtw = 30*ones(512,512);
% % test12_anglebtw = 30*ones(512,512);
% % test51_anglebtw = 30*ones(512,512);
% % test52_anglebtw = 30*ones(512,512);
% % test101_anglebtw = 30*ones(512,512);
% % test102_anglebtw = 30*ones(512,512);
% % test501_anglebtw = 30*ones(512,512);
% % test502_anglebtw = 30*ones(512,512);
% % find best pixel
% prn_anglebtw(GoodIndex) = btwazel_xyzmap(prnazel,xcart(GoodIndex),ycart(GoodIndex),zcart(GoodIndex));
% % % if min is less than 30 in restricted view, then spectral pixel is min
% % figure(13);imagesc(prn_anglebtw);
% [prnxpix,prnypix,prnminGRID] = minanglefind(prn_anglebtw, GoodIndex);
% % [test11_px, test11_py, testminGRID] = minanglefind(test11_anglebtw, GoodIndex);
% % [test12_px, test12_py, testminGRID] = minanglefind(test12_anglebtw, GoodIndex);
% % [test51_px, test51_py, testminGRID] = minanglefind(test51_anglebtw, GoodIndex);
% % [test52_px, test52_py, testminGRID] = minanglefind(test52_anglebtw, GoodIndex);
% % [test101_px, test101_py, testminGRID] = minanglefind(test101_anglebtw, GoodIndex);
% % [test102_px, test102_py, testminGRID] = minanglefind(test102_anglebtw, GoodIndex);
% % [test501_px, test501_py, testminGRID] = minanglefind(test501_anglebtw, GoodIndex);
% % [test502_px, test502_py, testminGRID] = minanglefind(test502_anglebtw, GoodIndex);
% % disp(["x pixel: " num2str(prnxpix) " " num2str(test11_px) " " num2str(test12_px) " " num2str(test51_px) " " num2str(test52_px) " " num2str(test101_px) " " num2str(test102_px) " " num2str(test501_px) " " num2str(test502_px)]);
% % disp(["y pixel: " num2str(prnypix) " " num2str(test11_py) " " num2str(test12_py) " " num2str(test51_py) " " num2str(test52_py) " " num2str(test101_py) " " num2str(test102_py) " " num2str(test501_py) " " num2str(test502_py)]);% figure(13);hold on;
% % plot(prnypix,prnxpix,'rx','LineWidth',3,'MarkerEdgeColor','r','MarkerSize',10)
% % plot(bypix,bxpix,'go','LineWidth',3,'MarkerEdgeColor','g','MarkerSize',10)
% p1 = [prnxpix-1 prnypix+1];
% p2 = [prnxpix, prnypix+1];
% p3 = [prnxpix+1 prnypix+1];
% p4 = [prnxpix-1 prnypix];
% p5 = [prnxpix+1 prnypix];
% p6 = [prnxpix-1 prnypix-1];
% p7 = [prnxpix prnypix-1]; 
% p8 = [prnxpix+1 prnypix-1];
% 
% gbrkr = ASCRay10Data(:,prnxpix,prnypix);
% gbrkr1 = (ASCRay10Data(:, p1(1), p1(2)))';
% gbrkr2 = (ASCRay10Data(:, p2(1), p2(2)))';
% gbrkr3 = (ASCRay10Data(:, p3(1), p3(2)))';
% gbrkr4 = (ASCRay10Data(:, p4(1), p4(2)))';
% gbrkr5 = (ASCRay10Data(:, p5(1), p5(2)))';
% gbrkr6 = (ASCRay10Data(:, p6(1), p6(2)))';
% gbrkr7 = (ASCRay10Data(:, p7(1), p7(2)))';
% 
% gbrkr = gbrkr';
% % rbratio_test = [RBData(1,prnxpix-1,prnypix+1), RBData(1,prnxpix,prnypix+1), RBData(1,prnxpix+1,prnypix+1), ...
% %     RBData(1,prnxpix-1,prnypix), RBData(1,prnxpix,prnypix), RBData(1,prnxpix+1,prnypix), RBData(1,prnxpix-1,prnypix-1), ...
% %     RBData(1,prnxpix,prnypix-1), RBData(1,prnxpix+1,prnypix-1)];
% 
% rbratio = RBData(1,prnxpix,prnypix);
% rbratio1 = RBData(1,p1(1),p1(2));
% rbratio2 = RBData(1,p2(1),p2(2));
% rbratio3 = RBData(1,p3(1),p3(2));
% rbratio4 = RBData(1,p4(1),p4(2));
% rbratio5 = RBData(1,p5(1),p5(2));
% rbratio6 = RBData(1,p6(1),p6(2));
% rbratio7 = RBData(1,p7(1),p7(2));
% rbratio8 = RBData(1,p8(1),p8(2));
% rbratioT = (rbratio+rbratio1+rbratio2+rbratio3+rbratio4+rbratio5+rbratio6+rbratio7+rbratio8)/9
% 
% Case1Data=squeeze(RBData);
% % ASCPlotterCase1(Case1Data,'St. Patricks Day Storm - March 18, 2015 08:06:17 UTC','630nm / 428nm ratio', 1, 1, 15,...
% %     prnxpix, prnypix, bxpix, bypix)
% 
% EFcatO = "-";%string.empty;
% EFcat = "-";
% if (prnbtw<=25)
%     EFcat = ratio2layer(rbratio);
%     EFcatO = ratio2layer(rbratioT);
%     
% end
% % EFcat
% 
% end
% 
% function [layer] = ratio2layer(ratio)
% % IN/OUT: nx1 vector
% layer=strings(length(ratio),1);
% layer(find(ratio>0.5))="F";
% layer(find(ratio<=0.5))="E";
% layer(find(ratio<0.06))="D";
% end
% 
% function [xpixel,ypixel,minangle] = minanglefind(anglemat, CloseBIndex)
% linview = anglemat(CloseBIndex);
% [minangle, Itemp] = min(linview,[],'linear');
% [xpixel,ypixel,] = find(anglemat==minangle);
% end
% 
% function [anglebtw] = btwazel_xyzmap(azeld1,xcart,ycart,zcart)
% % IN
% % azeld1 = 1x2 [azimuth elevation] degree
% % xcart,ycart,zcart = nx1 vectors of cartesian vector coords
% % OUT
% % anglebtw = nx1 degree angle between azel1 & azel2 unit vectors
% azel1=azeld1*pi/180;
% [xyz1(1) xyz1(2) xyz1(3)] = sph2cart(azel1(1),azel1(2),1);
% % create repeating array equal in size to xcart, etc
% % xyz1 = xyz1';
% xyz1 = (repmat(xyz1,length(xcart),1))';
% xyz2 = [xcart ycart zcart]';
% % [xyz2(1) xyz2(2) xyz2(3)] = sph2cart(azel2(1),azel2(2),1);
% % xyz1
% % xyz2
% anglebtw = acosd(dot(xyz1,xyz2) ./ (vecnorm(xyz1).*vecnorm(xyz2))); %1xn
% anglebtw = anglebtw'; %nx1
% end
% 
% function [anglebtw] = btwazel_xyz(azeld1,xyz2)
% % IN
% % azeld1,azeld2 = 1x2 [azimuth elevation] degree
% % OUT
% % anglebtw = degree angle between azel1 & azel2 unit vectors
% azel1=azeld1*pi/180;
% azel2=azeld2*pi/180;
% [xyz1(1) xyz1(2) xyz1(3)] = sph2cart(azel1(1),azel1(2),1);
% [xyz2(1) xyz2(2) xyz2(3)] = sph2cart(azel2(1),azel2(2),1);
% % xyz1
% % xyz2
% anglebtw = acosd(dot(xyz1,xyz2) / (norm(xyz1)*norm(xyz2)));
% end
% 
% function [anglebtw] = btwazel(azeld1,azeld2)
% % IN
% % azeld1,azeld2 = 1x2 [azimuth elevation] degree
% % OUT
% % anglebtw = degree angle between azel1 & azel2 unit vectors
% azel1=azeld1*pi/180;
% azel2=azeld2*pi/180;
% [xyz1(1) xyz1(2) xyz1(3)] = sph2cart(azel1(1),azel1(2),1);
% [xyz2(1) xyz2(2) xyz2(3)] = sph2cart(azel2(1),azel2(2),1);
% % xyz1
% % xyz2
% anglebtw = acosd(dot(xyz1,xyz2) / (norm(xyz1)*norm(xyz2)));
% end
% 
% function ASCPlotterCase1(FITSData, TitleStr, ColorbName, Trim10Flag, ScaleFlag, FigNum,...
%     prnx1, prny1, bx, by)
% % Function to plot 3 separate channel ASC images
% % (only plots, no calculations)
% % Blue/Green/RedData etc are CALIBRATED values to plot (Rayleighs)
% % FITSData = GBR by default (channel,row,column)
% % ColorbName = name of colorbar, ie units plotting
% % Trim10Flag = 1, set elevations<10 to 0 (circular frame)
% % ScaleFlag = 1, scale min and max of plot to cutoffs (for visibility)
% % FigNum figure number to plot on
% 
% ElMapFileName = 'PKR_DASC_0558_20150213_El.FIT';
% ElData = fitsread(ElMapFileName);
% MappedIndex = find(~ElData); %linear indices of zero elevation pixels
% 
% lowerCutoff = .01; %lower and upper percentile (1.0=max)to scale graphs to
% upperCutoff = .995;
% figure(FigNum);   
% 
% % for k=1:3
% %     ChannelData = squeeze(FITSData(k,:,:));
%     ChannelData = FITSData;
%     if(Trim10Flag)
%         ChannelData(MappedIndex) = 0;
%     end
% %   find min and max to scale to defined by cutoffs
% %   sort FITSData, then find value at min/max postion, rounding postion
% %   index up/down
%     if(ScaleFlag)
%         TempData = ChannelData(:);
%         sortData = sort(TempData(TempData>0));
%         minIndex = ceil(lowerCutoff*length(sortData));
%         maxIndex = floor(upperCutoff*length(sortData));
%         ScaleMax = [sortData(minIndex) sortData(maxIndex)]; %[min max]
%     else
%         ScaleMax = [min(ChannelData) max(ChannelData)]; %[min max]
%     end
% %     SingleName= {'-CH4 558nm Green';'-CH1 428nm Blue';'-CH5 630nm Red'};
% %     RatioName = {'-CH5 630nm Red'   '-CH1 428nm Blue';...
% %                  '-CH4 558nm Green' '-CH1 428nm Blue';...
% %                  '-CH5 630nm Red'   '-CH4 558nm Green'};
%     
% %     extract timestamp from filenames
% %     for i=1:size(FITSFilename,2)%to handle ratio graphs with 2 filenames
% %         TempDateStr = FITSFilename{k,i};
% %         TempDateStr = strtok(TempDateStr,'.'); %part before .###.FITS
% %         TempStrParts = strsplit(TempDateStr,'_');%1x5 cell, 3=ch wavelength###, 4=yyyymmdd, 5=HHMMSS
% %         Date = datetime(datevec(strcat(TempStrParts{4},'/',TempStrParts{5}), 'yyyymmdd/HHMMSS'));
% %         if(size(FITSFilename,2)==1)
% %             TitleStr((2*i -1):(2*i)) = {FITSFilename{k,i}; strcat(datestr(Date),SingleName{k})};
% %         elseif(size(FITSFilename,2)==2)
% %             TitleStr((2*i -1):(2*i)) = {FITSFilename{k,i}; strcat(datestr(Date),RatioName{k,i})};
% %         else
% %             error('error in FITFilename dimensions');
% %         end
% %     end
% %     subplot(1,3,k);
%     imagesc(ChannelData, ScaleMax);hold on;
% %     prnx1, prny1, prnx2, prny2, prnx3, prny3, bx, by)
%     plot(prny1,prnx1,'+m','LineWidth',3,'MarkerEdgeColor','m','MarkerSize',10)
% %     plot(prny2,prnx2,'^m','LineWidth',3,'MarkerEdgeColor','m','MarkerSize',10)
% %     plot(prny3,prnx3,'rx','LineWidth',3,'MarkerEdgeColor','r','MarkerSize',10)
%     plot(by,bx,'go','LineWidth',3,'MarkerEdgeColor','g','MarkerSize',10)
% %     legend('PRN25','PRN29','PRN31','B Line');
%     colorbar;
%     title(TitleStr, 'Interpreter', 'none','FontSize',16);
% %     t=title;
% %     t.FontSize=20;
%     h = colorbar;
%     h.FontSize = 15;
%     ylabel(h,ColorbName);
% set(gca,'xtick',[])
% set(gca,'xticklabel',[])
% set(gca,'ytick',[])
% set(gca,'yticklabel',[])
% % end
% set(gcf, 'Position',  [100, 0, 760, 600])
% 
% end %end function
% 
% function ASCPlotterAll(FITSData, FITSFilename, ColorbName, Trim10Flag, ScaleFlag, FigNum)
% % Function to plot 3 separate channel ASC images
% % (only plots, no calculations)
% % Blue/Green/RedData etc are CALIBRATED values to plot (Rayleighs)
% % FITSData = GBR by default (channel,row,column)
% % ColorbName = name of colorbar, ie units plotting
% % Trim10Flag = 1, set elevations<10 to 0 (circular frame)
% % ScaleFlag = 1, scale min and max of plot to cutoffs (for visibility)
% % FigNum figure number to plot on
% 
% ElMapFileName = 'PKR_DASC_0558_20150213_El.FIT';
% ElData = fitsread(ElMapFileName);
% MappedIndex = find(~ElData); %linear indices of zero elevation pixels
% 
% lowerCutoff = .01; %lower and upper percentile (1.0=max)to scale graphs to
% upperCutoff = .995;
% figure(FigNum);   
% 
% for k=1:3
%     ChannelData = squeeze(FITSData(k,:,:));
%     if(Trim10Flag)
%         ChannelData(MappedIndex) = 0;
%     end
% %   find min and max to scale to defined by cutoffs
% %   sort FITSData, then find value at min/max postion, rounding postion
% %   index up/down
%     if(ScaleFlag)
%         TempData = ChannelData(:);
%         sortData = sort(TempData(TempData>0));
%         minIndex = ceil(lowerCutoff*length(sortData));
%         maxIndex = floor(upperCutoff*length(sortData));
%         ScaleMax = [sortData(minIndex) sortData(maxIndex)]; %[min max]
%     else
%         ScaleMax = [min(ChannelData) max(ChannelData)]; %[min max]
%     end
%     SingleName= {'-CH4 558nm Green';'-CH1 428nm Blue';'-CH5 630nm Red'};
%     RatioName = {'-CH5 630nm Red'   '-CH1 428nm Blue';...
%                  '-CH4 558nm Green' '-CH1 428nm Blue';...
%                  '-CH5 630nm Red'   '-CH4 558nm Green'};
%     
% %     extract timestamp from filenames
%     for i=1:size(FITSFilename,2)%to handle ratio graphs with 2 filenames
%         TempDateStr = FITSFilename{k,i};
%         TempDateStr = strtok(TempDateStr,'.'); %part before .###.FITS
%         TempStrParts = strsplit(TempDateStr,'_');%1x5 cell, 3=ch wavelength###, 4=yyyymmdd, 5=HHMMSS
%         Date = datetime(datevec(strcat(TempStrParts{4},'/',TempStrParts{5}), 'yyyymmdd/HHMMSS'));
%         if(size(FITSFilename,2)==1)
%             TitleStr((2*i -1):(2*i)) = {FITSFilename{k,i}; strcat(datestr(Date),SingleName{k})};
%         elseif(size(FITSFilename,2)==2)
%             TitleStr((2*i -1):(2*i)) = {FITSFilename{k,i}; strcat(datestr(Date),RatioName{k,i})};
%         else
%             error('error in FITFilename dimensions');
%         end
%     end
%     subplot(1,3,k);
%     imagesc(ChannelData, ScaleMax);
%     colorbar;
%     title(TitleStr, 'Interpreter', 'none');
%     h = colorbar;
%     ylabel(h,ColorbName);
% end
% set(gcf, 'Position',  [100, 0, 1800, 450])
% 
% end %end function
% 
% function ASCPlotter(FITSFilename, FigNum)
% % Function to plot 3 separate channel ASC images (from same time)
% % cell~FITSFileName {ch1(purp) ch4(gr) ch5(red)}
% % FigNum is figure number to plot on
% 
% lowerCutoff = .01; %lower and upper percentile (1.0=max)to scale graphs to
% upperCutoff = .995;
% figure(FigNum);   
% 
% FITSFilename
% 
% for k=1:3
%     FITSData = fitsread(FITSFilename{k});
% %   find min and max to scale to defined by cutoffs
% %   sort FITSData, then find value at min/max postion, rounding postion
% %   index up/down
%     sortData = sort(FITSData(:));
%     minIndex = ceil(lowerCutoff*length(sortData));
%     maxIndex = floor(upperCutoff*length(sortData));
%     ScaleMax = [sortData(minIndex) sortData(maxIndex)]; %[min max]
%     
% %     extract timestamp from filename
%     TempDateStr = FITSFilename{k};
%     TempDateStr = strtok(TempDateStr,'.'); %part before .###.FITS
%     TempStrParts = strsplit(TempDateStr,'_');%1x5 cell, 3=ch wavelength###, 4=yyyymmdd, 5=HHMMSS
%     Date = datetime(datevec(strcat(TempStrParts{4},'/',TempStrParts{5}), 'yyyymmdd/HHMMSS'));
% 
%     if (k==1)
%         TitleStr = {FITSFilename{k}; strcat(datestr(Date),'-CH4 558nm Green')};
%     elseif (k==2)
%         TitleStr = {FITSFilename{k}; strcat(datestr(Date),'-CH1 428nm Blue')};
%     elseif (k==3)
%         TitleStr = {FITSFilename{k}; strcat(datestr(Date),'-CH5 630nm Red')};
%     end
%     
%     subplot(1,3,k);
% %     subplot(2,2,k);
%     imagesc(FITSData, ScaleMax);
%     colorbar;
%     title(TitleStr, 'Interpreter', 'none');
% end
% set(gcf, 'Position',  [100, 0, 1800, 450])
% 
% end %end function
% 
% function ASCPlotter10Deg(FITSFilename, FigNum)
% % Function to plot 3 separate channel ASC images (from same time)
% % cell~FITSFileName {ch1(purp) ch4(gr) ch5(red)}
% % FigNum is figure number to plot on
% 
% ElMapFileName = 'PKR_DASC_0558_20150213_El.FIT';
% ElData = fitsread(ElMapFileName);
% MappedIndex = find(~ElData); %linear indices of zero elevation pixels
% 
% lowerCutoff = .005; %lower and upper percentile (1.0=max)to scale graphs to
% upperCutoff = .995;
% figure(FigNum);   
% 
% FITSFilename
% 
% for k=1:3
%     FITSData = fitsread(FITSFilename{k});
% %   find min and max to scale to defined by cutoffs
% %   sort FITSData, then find value at min/max postion, rounding postion
% %   index up/down
%     FITSData(MappedIndex) = 0; %set pixels below 10deg elevation->0
% 
%     TempData = FITSData(:);
%     sortData = sort(TempData(TempData>0));
%     minIndex = ceil(lowerCutoff*length(sortData));
%     maxIndex = floor(upperCutoff*length(sortData));
%     ScaleMax = [sortData(minIndex) sortData(maxIndex)]; %[min max]
% %     FITSData(MappedIndex) = 0; %set pixels below 10deg elevation->0
%     
% %     extract timestamp from filename
%     TempDateStr = FITSFilename{k};
%     TempDateStr = strtok(TempDateStr,'.'); %part before .###.FITS
%     TempStrParts = strsplit(TempDateStr,'_');%1x5 cell, 3=ch wavelength###, 4=yyyymmdd, 5=HHMMSS
%     Date = datetime(datevec(strcat(TempStrParts{4},'/',TempStrParts{5}), 'yyyymmdd/HHMMSS'));
% 
%     if (k==1)
%         TitleStr = {FITSFilename{k}; strcat(datestr(Date),'-CH4 558nm Green')};
%     elseif (k==2)
%         TitleStr = {FITSFilename{k}; strcat(datestr(Date),'-CH1 428nm Blue')};
%     elseif (k==3)
%         TitleStr = {FITSFilename{k}; strcat(datestr(Date),'-CH5 630nm Red')};
%     end
%     
%     subplot(1,3,k);
%     imagesc(FITSData, ScaleMax);
%     colorbar;
%     title(TitleStr, 'Interpreter', 'none');
% end
% set(gcf, 'Position',  [100, 0, 1800, 450])
% end