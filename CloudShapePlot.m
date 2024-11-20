function CloudShapePlot(CloudShape, CutoffAngle, Wavelength, FileName, FigNum)
ToPlot = [1 4 5]; %channels and order to plot them in
figure(FigNum); hold on;
for k = 1:length(ToPlot)
    subplot(length(ToPlot),1,k);
    plot(CutoffAngle:(180-CutoffAngle),CloudShape(:,ToPlot(k))); hold on;
    plot(CutoffAngle:(180-CutoffAngle),flip(CloudShape(:,ToPlot(k)),1),'-.r');
    title(strcat(FileName, ', Channel ', num2str(ToPlot(k)),', Wavelength=',num2str(Wavelength(ToPlot(k))),'nm, Red-Dashed is reflected'),'Interpreter', 'none');
    xlabel('Elevation');
    ylabel('Normalized Intensity');
    xlim([0 180]);
    ylim([0 1.5]);
    %     ylim([0 max(NV(k,:))]);
end
set(gcf, 'Position',  [100, 100, 1000, 700])
end