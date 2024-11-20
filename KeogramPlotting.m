% Keogram Plotting Script
a = 0.7;
b = 1:6;
% Plotting Peak Intensity
f1 = figure; figure(f1);
f1.Position = [100 100 1000 800];
mincolor = 0; maxcolor = max(max(max(PeakIntensity(:,b,:))))*a;
for i = 1:size(b,2)
sub{i} = subplot(size(b,2),1,i);
imagesc(sub{i},squeeze(PeakIntensity(:,b(i),:)))
title([num2str(Wavelength(b(i))) ' nm']);
caxis(sub{i}, [mincolor, maxcolor]);
xt = get(sub{i}, 'XTick');
set(sub{i}, 'XTick', xt, 'XTickLabel', Time(xt));
end
h = axes(f1, 'visible', 'off');
h.Title.Visible = 'on';
h.XLabel.Visible = 'on';
h.YLabel.Visible = 'on';
ylabel(h, 'Elevation Angle[deg] 0 = Northern Horizon');
xlabel(h, 'Time Since Midnight UTC [s]');
title(h, [NCFilename(end-6:end-5) '-' NCFilename(end-4:end-3) '-' NCFilename(end-10:end-7) ' Peak Intensity'], 'Position', [.5 1.05 .5]);
c = colorbar(h, 'Position', [0.93 0.168 0.022 0.7]);
ylabel(c, 'Counts');
caxis(h, [mincolor, maxcolor]);
saveas(f1, ['PeakInt2' NCFilename(end-6:end-5) '-' NCFilename(end-4:end-3) '-' NCFilename(end-10:end-7) '.png'], 'png');

clear h c sub t

% subplot(3,1,2);
% imagesc(squeeze(PeakIntensity(:,4,:)))
% xlabel('Time Since Midnight UTC [s]');
% ylabel('Elevation Angle[deg] 0 = Northern Horizon');
% title('01-Jan-2014 Peak Intensity 557.7 nm Wavelength');
% h = colorbar;
% ylabel(h, 'Counts')
% 
% subplot(3,1,3);
% imagesc(squeeze(PeakIntensity(:,5,:)))
% xlabel('Time Since Midnight UTC [s]');
% title('01-Jan-2014 Peak Intensity 630 nm Wavelength');
% h = colorbar;
% ylabel(h, 'Counts')
% saveas(f1, 'PeakInt.png', 'png');

%Plotting Base Instensity
f2 = figure; figure(f2);
f2.Position = [100 100 1000 800];
mincolor = 0; maxcolor = max(max(max(BaseIntensity(:,b,:))))*a;
for i = 1:size(b,2)
sub{i} = subplot(size(b,2),1,i);
imagesc(sub{i},squeeze(BaseIntensity(:,b(i),:)))
title([num2str(Wavelength(b(i))) ' nm']);
caxis(sub{i}, [mincolor, maxcolor]);
xt = get(sub{i}, 'XTick');
set(sub{i}, 'XTick', xt, 'XTickLabel', Time(xt));
end
h = axes(f2, 'visible', 'off');
h.Title.Visible = 'on';
h.XLabel.Visible = 'on';
h.YLabel.Visible = 'on';
ylabel(h, 'Elevation Angle[deg] 0 = Northern Horizon');
xlabel(h, 'Time Since Midnight UTC [s]');
title(h, [NCFilename(end-6:end-5) '-' NCFilename(end-4:end-3) '-' NCFilename(end-10:end-7) ' Base Intensity'], 'Position', [.5 1.05 .5]);
c = colorbar(h, 'Position', [0.93 0.168 0.022 0.7]);
ylabel(c, 'Counts');
caxis(h, [mincolor, maxcolor]);
saveas(f2, ['Baseint2' NCFilename(end-6:end-5) '-' NCFilename(end-4:end-3) '-' NCFilename(end-10:end-7) '.png'], 'png');

clear h c sub t
% f2 = figure; figure(f2);
% subplot(3,1,1);
% imagesc(squeeze(BaseIntensity(:,1,:)))
% xlabel('Time Since Midnight UTC [s]');
% title('01-Jan-2014 Base Intensity 427.8 nm Wavelength');
% h = colorbar;
% ylabel(h, 'Counts')
% 
% subplot(3,1,2);
% imagesc(squeeze(BaseIntensity(:,4,:)))
% xlabel('Time Since Midnight UTC [s]');
% ylabel('Elevation Angle[deg] 0 = Northern Horizon');
% title('01-Jan-2014 Base Intensity 557.7 nm Wavelength');
% h = colorbar;
% ylabel(h, 'Counts')
% 
% subplot(3,1,3);
% imagesc(squeeze(BaseIntensity(:,5,:)))
% xlabel('Time Since Midnight UTC [s]');
% title('01-Jan-2014 Base Intensity 630 nm Wavelength');
% h = colorbar;
% ylabel(h, 'Counts')
% saveas(f2, 'baseint.png', 'png');

%Plotting Diff Instensity
f3 = figure; figure(f3);
f3.Position = [100 100 1000 800];
mincolor = 0; maxcolor = max(max(max(DiffIntensity(:,b,:))))*a;
for i = 1:size(b,2)
sub{i} = subplot(size(b,2),1,i);
imagesc(sub{i},squeeze(DiffIntensity(:,b(i),:)))
title([num2str(Wavelength(b(i))) ' nm']);
caxis(sub{i}, [mincolor, maxcolor]);
xt = get(sub{i}, 'XTick');
set(sub{i}, 'XTick', xt, 'XTickLabel', Time(xt));
end
h = axes(f3, 'visible', 'off');
h.Title.Visible = 'on';
h.XLabel.Visible = 'on';
h.YLabel.Visible = 'on';
ylabel(h, 'Elevation Angle[deg] 0 = Northern Horizon');
xlabel(h, 'Time Since Midnight UTC [s]');
title(h, [NCFilename(end-6:end-5) '-' NCFilename(end-4:end-3) '-' NCFilename(end-10:end-7) ' Diff Intensity'], 'Position', [.5 1.05 .5]);
c = colorbar(h, 'Position', [0.93 0.168 0.022 0.7]);
ylabel(c, 'Counts');
caxis(h, [mincolor, maxcolor]);
saveas(f3, ['Diffint2' NCFilename(end-6:end-5) '-' NCFilename(end-4:end-3) '-' NCFilename(end-10:end-7) '.png'], 'png');

clear h c sub t
% f3 = figure; figure(f3);
% subplot(3,1,1);
% imagesc(squeeze(DiffIntensity(:,1,:)))
% xlabel('Time Since Midnight UTC [s]');
% title('01-Jan-2014 Difference in Intensity 427.8 nm Wavelength');
% h = colorbar;
% ylabel(h, 'Counts')
% 
% subplot(3,1,2);
% imagesc(squeeze(DiffIntensity(:,4,:)))
% xlabel('Time Since Midnight UTC [s]');
% ylabel('Elevation Angle[deg] 0 = Northern Horizon');
% title('01-Jan-2014 Difference in Intensity 557.7 nm Wavelength');
% h = colorbar;
% ylabel(h, 'Counts')
% 
% subplot(3,1,3);
% imagesc(squeeze(DiffIntensity(:,5,:)))
% xlabel('Time Since Midnight UTC [s]');
% title('01-Jan-2014 Difference in Intensity 670 nm Wavelength');
% h = colorbar;
% ylabel(h, 'Counts')
% saveas(f3, 'diffint.png', 'png');

%Plotting Diff Instensity Short
f4 = figure; figure(f4);
f4.Position = [100 100 1000 800];
mincolor = 0; maxcolor = max(max(max(DiffShort(:,b,:))))*a;
for i = 1:size(b,2)
sub{i} = subplot(size(b,2),1,i);
imagesc(sub{i},squeeze(DiffShort(:,b(i),:)))
title([num2str(Wavelength(b(i))) ' nm']);
caxis(sub{i}, [mincolor, maxcolor]);
xt = get(sub{i}, 'XTick');
set(sub{i}, 'XTick', xt, 'XTickLabel', TimeSeconds(xt));
end
h = axes(f4, 'visible', 'off');
h.Title.Visible = 'on';
h.XLabel.Visible = 'on';
h.YLabel.Visible = 'on';
ylabel(h, 'Elevation Angle[deg] 0 = Northern Horizon');
xlabel(h, 'Time Since Midnight UTC [s]');
title(h, [NCFilename(end-6:end-5) '-' NCFilename(end-4:end-3) '-' NCFilename(end-10:end-7) ' Difference in Intensity Time Cut Off'], 'Position', [.5 1.05 .5]);
c = colorbar(h, 'Position', [0.93 0.168 0.022 0.7]);
ylabel(c, 'Counts');
caxis(h, [mincolor, maxcolor]);
saveas(f4, ['Diffshort2' NCFilename(end-6:end-5) '-' NCFilename(end-4:end-3) '-' NCFilename(end-10:end-7) '.png'], 'png');

clear h c sub t
% f4 = figure; figure(f4);
% subplot(3,1,1);
% imagesc(squeeze(DiffShort(:,1,:)))
% xlabel('Time Since Midnight UTC [s]');
% title('01-Jan-2014 Difference in Intensity 427.8 nm Wavelength Time Cutoff');
% h = colorbar;
% ylabel(h, 'Counts')
% 
% subplot(3,1,2);
% imagesc(squeeze(DiffShort(:,4,:)))
% xlabel('Time Since Midnight UTC [s]');
% ylabel('Elevation Angle[deg] 0 = Northern Horizon');
% title('01-Jan-2014 Difference in Intensity 557.7 nm Wavelength Time Cutoff');
% h = colorbar;
% ylabel(h, 'Counts')
% 
% subplot(3,1,3);
% imagesc(squeeze(DiffShort(:,5,:)))
% xlabel('Time Since Midnight UTC [s]');
% title('01-Jan-2014 Difference in Intensity 670 nm Wavelength Time Cutoff');
% h = colorbar;
% ylabel(h, 'Counts')
% saveas(f4, 'diffshortint.png');

%Plotting Calibration Intensity
f5 = figure; figure(f5);
f5.Position = [100 100 1000 800];
mincolor = 0; maxcolor = max(max(max(CalIntensity(:,b,:))))*a;
for i = 1:size(b,2)
sub{i} = subplot(size(b,2),1,i);
imagesc(sub{i},squeeze(CalIntensity(:,b(i),:)))
title([num2str(Wavelength(b(i))) ' nm']);
caxis(sub{i}, [mincolor, maxcolor]);
xt = get(sub{i}, 'XTick');
set(sub{i}, 'XTick', xt, 'XTickLabel', TimeSeconds(xt));
end
h = axes(f5, 'visible', 'off');
h.Title.Visible = 'on';
h.XLabel.Visible = 'on';
h.YLabel.Visible = 'on';
ylabel(h, 'Elevation Angle[deg] 0 = Northern Horizon');
xlabel(h, 'Time Since Midnight UTC [s]');
title(h, [NCFilename(end-6:end-5) '-' NCFilename(end-4:end-3) '-' NCFilename(end-10:end-7) ' Intensity'], 'Position', [.5 1.05 .5]);
c = colorbar(h, 'Position', [0.93 0.168 0.022 0.7]);
ylabel(c, 'Rayleighs');
caxis(h, [mincolor, maxcolor]);
saveas(f5, ['Calint2' NCFilename(end-6:end-5) '-' NCFilename(end-4:end-3) '-' NCFilename(end-10:end-7) '.png'], 'png');

clear h c sub t
% f5 = figure; figure(f5);
% subplot(3,1,1);
% imagesc(squeeze(CalIntensity(:,1,:)))
% xlabel('Time Since Midnight UTC [s]');
% title('01-Jan-2014 Calibrated Intensity 427.8 nm Wavelength Time Cutoff');
% h = colorbar;
% ylabel(h, 'Rayleighs')
% 
% subplot(3,1,2);
% imagesc(squeeze(CalIntensity(:,4,:)))
% xlabel('Time Since Midnight UTC [s]');
% ylabel('Elevation Angle[deg] 0 = Northern Horizon');
% title('01-Jan-2014 Calibrated intensity 557.7 nm Wavelength Time Cutoff');
% h = colorbar;
% ylabel(h, 'Rayleighs')
% 
% subplot(3,1,3);
% imagesc(squeeze(CalIntensity(:,5,:)))
% xlabel('Time Since Midnight UTC [s]');
% title('01-Jan-2014 Calibrated Intensity 670 nm Wavelength Time Cutoff');
% h = colorbar;
% ylabel(h, 'Rayleighs')
% saveas(f5, 'calint.png', 'png');

% average Intensity
% f6 = figure; figure(f6);
% f6.Position = [100 100 1000 800];
% mincolor = 0; maxcolor = max(max(max(AvgIntensity)))*a;
% for i = b
% sub{i} = subplot(1,size(b,2),i);
% imagesc(sub{i},squeeze(AvgIntensity(i,:)'))
% title([num2str(Wavelength(i)) ' nm']);
% caxis(sub{i}, [mincolor, maxcolor]);
% end
% h = axes(f6, 'visible', 'off');
% h.Title.Visible = 'on';
% h.XLabel.Visible = 'on';
% h.YLabel.Visible = 'on';
% ylabel(h, 'Elevation Angle[deg] 0 = Northern Horizon');
% xlabel(h, 'Averaged Over Time');
% title(h, '01-Jan-2014 Avgerage Intensity at each Elevation Angle over Time', 'Position', [.5 1.05 .5]);
% c = colorbar(h, 'Position', [0.93 0.168 0.022 0.7]);
% ylabel(c, 'Rayleighs');
% caxis(h, [mincolor, maxcolor]);
% saveas(f6, 'avgint2.png', 'png');
% 
% clear h c sub t
% f6 = figure; figure(f6);
% subplot(1,3,1);
% imagesc(AvgIntensity(1,:)')
% xlabel('One Time Point');
% ylabel('Elevation Angle[deg] 0 = Northern Horizon');
% h = colorbar; 
% ylabel(h, 'Rayleighs');
% title('427.8 nm');
% 
% subplot(1,3,2);
% imagesc(AvgIntensity(4,:)')
% xlabel('One Time Point');
% ylabel('Elevation Angle[deg] 0 = Northern Horizon');
% title('557.7 nm');
% h = colorbar;
% ylabel(h, 'Rayleighs')
% 
% subplot(1,3,3);
% imagesc(AvgIntensity(5,:)')
% xlabel('One Time Point');
% ylabel('Elevation Angle[deg] 0 = Northern Horizon');
% title('670 mm');
% h = colorbar;
% ylabel(h, 'Rayleighs')
% sgtitle('01-Jan-2014 Average Intensity')
% saveas(f6, 'avgint.png', 'png');

% Norm Intensity
% f7 = figure; figure(f7);
% f7.Position = [100 100 1000 800];
% mincolor = 0; maxcolor = max(max(max(NormIntensity)))*a;
% for i = 1:size(b,2)
% sub{i} = subplot(size(b,2),1,i);
% imagesc(sub{i},squeeze(NormIntensity(:,i,:)))
% title([num2str(Wavelength(i)) ' nm']);
% caxis(sub{i}, [mincolor, maxcolor]);
% xt = get(sub{i}, 'XTick');
% set(sub{i}, 'XTick', xt, 'XTickLabel', TimeSeconds);
% end
% h = axes(f7, 'visible', 'off');
% h.Title.Visible = 'on';
% h.XLabel.Visible = 'on';
% h.YLabel.Visible = 'on';
% ylabel(h, 'Elevation Angle[deg] 0 = Northern Horizon');
% xlabel(h, 'Time Since Midnight UTC [s]');
% title(h, '01-Jan-2014 Normalized [Calibrated/Average] Intensity', 'Position', [.5 1.05 .5]);
% c = colorbar(h, 'Position', [0.93 0.168 0.022 0.7]);
% ylabel(c, 'Rayleighs/Rayleighs');
% caxis(h, [mincolor, maxcolor]);
% saveas(f7, 'normint2.png', 'png');
% 
% clear h c sub t
% f7 = figure; figure(f7);
% subplot(3, 1, 1);
% imagesc(squeeze(NormIntensity(:,1,:)));
% xlabel('Time Since Midnight UTC [s]');
% title('01-Jan-2014 Normalized intensity 427 nm Wavelength Time Cutoff');
% h = colorbar;
% ylabel(h, 'Rayleighs/Rayleighs');
% 
% subplot(3,1,2);
% imagesc(squeeze(NormIntensity(:,4,:)));
% xlabel('Time Since Midnight UTC [s]');
% title('01-Jan-2014 Normalized intensity 557.7 nm Wavelength Time Cutoff');
% h = colorbar;
% ylabel(h, 'Rayleighs/Rayleighs');
% ylabel('Elevation Angle[deg] 0 = Northern Horizon');
% 
% subplot(3, 1, 3);
% imagesc(squeeze(NormIntensity(:,6,:)));
% xlabel('Time Since Midnight UTC [s]');
% title('01-Jan-2014 Normalized intensity 630 nm Wavelength Time Cutoff');
% h = colorbar;
% ylabel(h, 'Rayleighs/Rayleighs');
% saveas(f7, 'NormInt.png', 'png');

%CloudShape
% f8 = figure; figure(f8);
% f8.Position = [100 100 1000 800];
% mincolor = 0; maxcolor = max(max(max(CloudShape)));
% for i = 1:size(b,2)
% sub{i} = subplot(1,size(b,2),i);
% imagesc(sub{i},squeeze(CloudShape(:,i)))
% title([num2str(Wavelength(i)) ' nm']);
% caxis(sub{i}, [mincolor, maxcolor]);
% end
% h = axes(f8, 'visible', 'off');
% h.Title.Visible = 'on';
% h.XLabel.Visible = 'on';
% h.YLabel.Visible = 'on';
% ylabel(h, 'Elevation Angle[deg] 0 = Northern Horizon');
% xlabel(h, 'Average over Time');
% title(h, '01-Jan-2014 Cloud Shape [Avgerage of the Normalized Intensity over Time] Intensity', 'Position', [.5 1.05 .5]);
% c = colorbar(h, 'Position', [0.93 0.168 0.022 0.7]);
% ylabel(c, 'Rayleighs/Rayleighs');
% caxis(h, [mincolor, maxcolor]);
% saveas(f8, 'cloudh2.png', 'png');
% 
% clear h c sub t
% f8 = figure; figure(f8);
% subplot(1,3,1);
% imagesc(CloudShape(:,1))
% xlabel('One Time Point');
% ylabel('Elevation Angle[deg] 0 = Northern Horizon');
% h = colorbar; 
% ylabel(h, 'Rayleighs/Rayleighs');
% title('427.8 nm');
% 
% subplot(1,3,2);
% imagesc(CloudShape(:,4))
% xlabel('One Time Point');
% ylabel('Elevation Angle[deg] 0 = Northern Horizon');
% title('557.7 nm');
% h = colorbar;
% ylabel(h, 'Rayleighs/Rayleighs')
% 
% subplot(1,3,3);
% imagesc(CloudShape(:,5))
% xlabel('One Time Point');
% ylabel('Elevation Angle[deg] 0 = Northern Horizon');
% title('670 mm');
% h = colorbar;
% ylabel(h, 'Rayleighs/Rayleighs')
% sgtitle('CloudShape')
% saveas(f8, 'cloudsh.png', 'png');

% Cloud Mat
% f9 = figure; figure(f9);
% f9.Position = [100 100 1000 800];
% mincolor = 0; maxcolor = max(max(max(CloudMat)));
% for i = 1:size(b,2)
% sub{i} = subplot(size(b,2),1,i);
% imagesc(sub{i},squeeze(CloudMat(:,i,:)))
% title([num2str(Wavelength(i)) ' nm']);
% caxis(sub{i}, [mincolor, maxcolor]);
% xt = get(sub{i}, 'XTick');
% set(sub{i}, 'XTick', xt, 'XTickLabel', TimeSeconds);
% end
% h = axes(f9, 'visible', 'off');
% h.Title.Visible = 'on';
% h.XLabel.Visible = 'on';
% h.YLabel.Visible = 'on';
% ylabel(h, 'Elevation Angle[deg] 0 = Northern Horizon');
% xlabel(h, 'Time Since Midnight UTC [s]');
% title(h, '01-Jan-2014 Cloud Mat [Cloud Shape Repeated for All Times in Time Frame]', 'Position', [.5 1.05 .5]);
% c = colorbar(h, 'Position', [0.93 0.168 0.022 0.7]);
% ylabel(c, 'Rayleighs/Rayleighs');
% caxis(h, [mincolor, maxcolor]);
% saveas(f9, 'cloudmat2.png', 'png');
% 
% clear h c sub t
% f9 = figure; figure(f9);
% subplot(3,1,1);
% imagesc(squeeze(CloudMat(:,1,:)));
% xlabel('Time Since Midnight UTC [s]');
% title('01-Jan-2014 Cloud Mat 427 nm Wavelength Time Cutoff');
% h = colorbar;
% ylabel(h, 'Rayleighs/Rayleighs');
% 
% subplot(3,1,2);
% imagesc(squeeze(CloudMat(:,4,:)));
% xlabel('Time Since Midnight UTC [s]');
% title('01-Jan-2014 Cloud Mat 557.7 nm Wavelength Time Cutoff');
% h = colorbar;
% ylabel(h, 'Rayleighs/Rayleighs');
% ylabel('Elevation Angle[deg] 0 = Northern Horizon');
% 
% subplot(3,1,3);
% imagesc(squeeze(CloudMat(:,5,:)));
% xlabel('Time Since Midnight UTC [s]');
% title('01-Jan-2014 Cloud Mat 630 nm Wavelength Time Cutoff');
% h = colorbar;
% ylabel(h, 'Rayleighs/Rayleighs');
% saveas(f9, 'cloudmat.png', 'png');

% FFC
f10 = figure; figure(f10);
f10.Position = [100 100 1000 800];
mincolor = 0; maxcolor = max(max(max(FFC(:,b,:))))*a;
for i = 1:size(b,2)
sub{i} = subplot(size(b,2),1,i);
imagesc(sub{i},squeeze(FFC(:,b(i),:)))
title([num2str(Wavelength(b(i))) ' nm']);
caxis(sub{i}, [mincolor, maxcolor]);
xt = get(sub{i}, 'XTick');
set(sub{i}, 'XTick', xt, 'XTickLabel', TimeSeconds(xt));
end
h = axes(f10, 'visible', 'off');
h.Title.Visible = 'on';
h.XLabel.Visible = 'on';
h.YLabel.Visible = 'on';
ylabel(h, 'Elevation Angle[deg] 0 = Northern Horizon');
xlabel(h, 'Time Since Midnight UTC [s]');
title(h, [NCFilename(end-6:end-5) '-' NCFilename(end-4:end-3) '-' NCFilename(end-10:end-7) ' Flat Field Correction'], 'Position', [.5 1.05 .5]);
c = colorbar(h, 'Position', [0.93 0.168 0.022 0.7]);
ylabel(c, 'Rayleighs');
caxis(h, [mincolor, maxcolor]);
saveas(f10, ['FFC2' NCFilename(end-6:end-5) '-' NCFilename(end-4:end-3) '-' NCFilename(end-10:end-7) '.png'], 'png');

clear h c sub t
% f10 = figure; figure(f10);
% subplot(3,1,1);
% imagesc(squeeze(FFC(:,1,:)));
% xlabel('Time Since Midnight UTC [s]');
% title('01-Jan-2014 Flat Field Correction 427 nm Wavelength Time Cutoff');
% h = colorbar;
% ylabel(h, 'Rayleighs');
% 
% subplot(3,1,2);
% imagesc(squeeze(FFC(:,4,:)));
% xlabel('Time Since Midnight UTC [s]');
% title('01-Jan-2014 Flat Field Correction 557.7 nm Wavelength Time Cutoff');
% h = colorbar;
% ylabel(h, 'Rayleighs');
% ylabel('Elevation Angle[deg] 0 = Northern Horizon');
% 
% subplot(3,1,3);
% imagesc(squeeze(FFC(:,5,:)));
% xlabel('Time Since Midnight UTC [s]');
% title('01-Jan-2014 Flat Field Correction 630 nm Wavelength Time Cutoff');
% h = colorbar;
% ylabel(h, 'Rayleighs');
% saveas(f10, 'FFC.png', 'png');

% std_ffc
f11 = figure; figure(f11);
f11.Position = [100 100 1000 800];
mincolor = 0; maxcolor = max(max(max(std_FFC(b,:))))*a;
for i = 1:size(b,2)
sub{i} = subplot(size(b,2),1,i);
imagesc(sub{i},squeeze(std_FFC(b(i),:)))
title([num2str(Wavelength(b(i))) ' nm']);
caxis(sub{i}, [mincolor, maxcolor]);
xt = get(sub{i}, 'XTick');
set(sub{i}, 'XTick', xt, 'XTickLabel', TimeSeconds(xt));
end
h = axes(f11, 'visible', 'off');
h.Title.Visible = 'on';
h.XLabel.Visible = 'on';
h.YLabel.Visible = 'on';
% ylabel(h, 'Elevation Angle[deg] 0 = Northern Horizon');
xlabel(h, 'Time Since Midnight UTC [s]');
title(h, [NCFilename(end-6:end-5) '-' NCFilename(end-4:end-3) '-' NCFilename(end-10:end-7) ' standard deviation of the FFC at each time point'], 'Position', [.5 1.05 .5]);
c = colorbar(h, 'Position', [0.93 0.168 0.022 0.7]);
ylabel(c, 'Rayleighs');
caxis(h, [mincolor, maxcolor]);
saveas(f11, ['stdffc2' NCFilename(end-6:end-5) '-' NCFilename(end-4:end-3) '-' NCFilename(end-10:end-7) '.png'], 'png');

clear h c sub t
% f11 = figure; figure(f11);
% subplot(3,1,1);
% imagesc(std_FFC(1,:))
% xlabel('Time Since Midnight UTC [s]');
% h = colorbar; 
% ylabel(h, 'Rayleighs/Rayleighs');
% title('427.8 nm');
% 
% subplot(3,1,2);
% imagesc(std_FFC(4,:))
% xlabel('Time Since Midnight UTC [s]');
% title('557.7 nm');
% h = colorbar;
% ylabel(h, 'Rayleighs/Rayleighs')
% 
% subplot(3,1,3);
% imagesc(std_FFC(5,:))
% xlabel('Time Since Midnight UTC [s]');
% title('670 mm');
% h = colorbar;
% ylabel(h, 'Rayleighs/Rayleighs')
% sgtitle('01-Jan-2014 Standard Deviation of FFC Time Cutoff ')
% saveas(f11, 'stdffc.png', 'png');

% avgFFC
f12 = figure; figure(f12);
f12.Position = [100 100 1000 800];
mincolor = 0; maxcolor = max(max(max(AvgIntensityFFC(b,:))))*a;
for i = 1:size(b,2)
sub{i} = subplot(size(b,2),1,i);
imagesc(sub{i},squeeze(AvgIntensityFFC(b(i),:)))
title([num2str(Wavelength(b(i))) ' nm']);
caxis(sub{i}, [mincolor, maxcolor]);
xt = get(sub{i}, 'XTick');
set(sub{i}, 'XTick', xt, 'XTickLabel', TimeSeconds(xt));
end
h = axes(f12, 'visible', 'off');
h.Title.Visible = 'on';
h.XLabel.Visible = 'on';
h.YLabel.Visible = 'on';
% ylabel(h, 'Elevation Angle[deg] 0 = Northern Horizon');
xlabel(h, 'Time Since Midnight UTC [s]');
title(h, [NCFilename(end-6:end-5) '-' NCFilename(end-4:end-3) '-' NCFilename(end-10:end-7) ' Mean FFC at each time point'], 'Position', [.5 1.05 .5]);
c = colorbar(h, 'Position', [0.93 0.168 0.022 0.7]);
ylabel(c, 'Rayleighs');
caxis(h, [mincolor, maxcolor]);
saveas(f12, ['avgffc2' NCFilename(end-6:end-5) '-' NCFilename(end-4:end-3) '-' NCFilename(end-10:end-7) '.png'], 'png');

clear h c sub t

%CvFFC
load('cmap_13.mat');
f13 = figure; figure(f13);
f13.Position = [100 100 1000 800];
% mincolor = 0; maxcolor = max(max(max(cv_FFC)))*a;
for i = 1:size(b,2)
sub{i} = subplot(size(b,2),1,i);
% imagesc(sub{i},squeeze(cv_FFC(i,:)))
plot(TimeSeconds, cv_FFC(b(i),:), 'k-');
hold on
plot(TimeSeconds, zeros(size(TimeSeconds))+.5, 'r-');
title([num2str(Wavelength(b(i))) ' nm']);
% caxis(sub{i}, [mincolor, maxcolor]);
% colormap(sub{i}, mycmap);
% xt = get(sub{i}, 'XTick');
% set(sub{i}, 'XTick', xt, 'XTickLabel', TimeSeconds(xt));
end
h = axes(f13, 'visible', 'off');
h.Title.Visible = 'on';
h.XLabel.Visible = 'on';
h.YLabel.Visible = 'on';
ylabel(h, 'Coeficent of Variation');
xlabel(h, 'Time Since Midnight UTC [s]');
title(h, [NCFilename(end-6:end-5) '-' NCFilename(end-4:end-3) '-' NCFilename(end-10:end-7) ' Coefficent of Variation at each time point'], 'Position', [.5 1.05 .5]);
% c = colorbar(h, 'Position', [0.93 0.168 0.022 0.7]);
% ylabel(c, 'Rayleighs');
% caxis(h, [mincolor, maxcolor]);
saveas(f13, ['cvffc2' NCFilename(end-6:end-5) '-' NCFilename(end-4:end-3) '-' NCFilename(end-10:end-7) '.png'], 'png');

clear h c sub t
