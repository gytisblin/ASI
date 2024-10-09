% load('scint_data_test.mat')
% EventASCTime=1
% i=1
% ScintData.EventASCTime{i} = EventASCTime;
% 
ncdisp('PKR_SMSP_STD_20140101.NC')
ncinfo('PKR_SMSP_STD_20140101.NC')
t=ncread('PKR_SMSP_STD_20140101.NC','Time')
i=ncread('PKR_SMSP_STD_20140101.NC','PeakIntensity')
b=ncread('PKR_SMSP_STD_20140101.NC','BaseIntensity')
w=ncread('PKR_SMSP_STD_20140101.NC','Wavelength')
ncid = netcdf.open('PKR_SMSP_STD_20140101.NC')


% nccreate('PKR_SMSP_STD_20190227.NC', 'Time')
%  load('ReKeog20190227.mat')
% ncwriteatt('PKR_SMSP_STD_20190227.NC', 'Time','KeogTime',[1])
% ncdisp('PKR_SMSP_STD_20190227.NC')
% ncinfo('PKR_SMSP_STD_20190227.NC')
%  t=ncread('PKR_SMSP_STD_20190227.NC','Time')