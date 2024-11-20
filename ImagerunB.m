% Script for spectral analysis of a GBR sequence of ASI images
% in direction of given pixel - magnetic field LOS
% GBRFITSname = nx1 string array of names (Green,Blue,Red)
function [Bgbrkr, Brbratio, BEFcat] = ImagerunB(ASCBias, bxpix, bypix, GBRFITSname)

GreenFilename = GBRFITSname(1); %GBR order
BlueFilename = GBRFITSname(2);
RedFilename = GBRFITSname(3);
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
t_exp = [1; 1; 1.5]; %seconds exposure, GBR (ie red=1.5s, others 1s)
% output calibrated 
ASCRayData = repmat(ASCCal,1,512,512).*(FITSData - repmat(ASCBias,1,512,512)) ./ (1000*repmat(t_exp,1,512,512));
Bgbrkr = ASCRayData(:,bxpix,bypix);
Bgbrkr = Bgbrkr';
Brbratio = Bgbrkr(3)/Bgbrkr(2);

BEFcat = "-";%string.empty;
BEFcat = ratio2layer(Brbratio);

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
%     ChannelData = squeeze(FITSData(k,:,:));
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
%     SingleName= {'-CH4 558nm Green';'-CH1 428nm Blue';'-CH5 630nm Red'};
%     RatioName = {'-CH5 630nm Red'   '-CH1 428nm Blue';...
%                  '-CH4 558nm Green' '-CH1 428nm Blue';...
%                  '-CH5 630nm Red'   '-CH4 558nm Green'};
    
%     extract timestamp from filenames
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
    imagesc(ChannelData, ScaleMax);hold on;
%     prnx1, prny1, prnx2, prny2, prnx3, prny3, bx, by)
    plot(prny1,prnx1,'+m','LineWidth',3,'MarkerEdgeColor','m','MarkerSize',10)
%     plot(prny2,prnx2,'^m','LineWidth',3,'MarkerEdgeColor','m','MarkerSize',10)
%     plot(prny3,prnx3,'rx','LineWidth',3,'MarkerEdgeColor','r','MarkerSize',10)
    plot(by,bx,'go','LineWidth',3,'MarkerEdgeColor','g','MarkerSize',10)
%     legend('PRN25','PRN29','PRN31','B Line');
    colorbar;
    title(TitleStr, 'Interpreter', 'none','FontSize',16);
%     t=title;
%     t.FontSize=20;
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
    
%     extract timestamp from filenames
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
    
%     extract timestamp from filename
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
%     subplot(2,2,k);
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
%     FITSData(MappedIndex) = 0; %set pixels below 10deg elevation->0
    
%     extract timestamp from filename
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