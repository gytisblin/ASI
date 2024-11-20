% Cloud Shape Yearly Plot
% 1=428 4=557 5=630 
wavelengths = [1 4 5];
waves = ["Cloud Shape Master 428 nm", "Cloud Shape Master 557 nm", "Cloud Shape Master 630 nm"];
load('CloudShapeMasterYearly.mat');
Years = 2014:2018;
f1 = figure; figure(f1);
for i = 1:length(wavelengths)
   subplot(3, 1, i)
   for k = 1:length(Years)
      plot(10:170, CloudShapeMaster{k}(:,i), 'DisplayName', num2str(Years(k))); 
      hold on;
   end
   legend()
   title(waves(i))
end