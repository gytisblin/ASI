% clear all;close all;clc;
% 
% scintprn = 16;
% timelist = [datetime(2014,2,19,21,28,04) datetime(2014,2,19,21,28,05) datetime(2014,2,19,21,28,06)];
% [az_el_out] = dazel_list(scintprn,timelist)
% % PKR_DASC_0558_20151007_062003.020.FITS

function [az_el_out] = dazel_list(scintprn,timelist, data_dir)
% IN
% scintprn = scalar PRN
% timelist = nx1 datetime array
% OUT
% az_el_out = nx2 list of az,el for PRN

% lat = 41.840664; %Chicago lake tests
% lon = -87.606982;
% ht = 181;
lat = 65.1260; %Poker Flats ASC, from header in .FITS
lon = -147.479;
ht = 350;
location(:,1) = lat * (pi/180);
location(:,2) = lon * (pi/180);
location(:,3) = ht;

time0 = timelist(1);
alm_folder = fullfile(data_dir,'GPSAlm',num2str(year(time0)));
% Create string of the day of year.
doy = day(time0,'dayofyear');
if doy < 10
    doystr = ['00' num2str(doy)];
elseif doy < 100
    doystr = ['0' num2str(doy)];
else
    doystr = num2str(doy);
end

alm_file = fullfile(alm_folder, [doystr '.ALM']);
rolltime = datetime('2019-04-06 00:00:00.000', 'InputFormat', 'yyyy-MM-dd HH:mm:ss.SSS');
if time0 < rolltime
    rollover_flag = 1;
else
    rollover_flag = 2;
end
[gps_alm, glo_alm] = readyuma(alm_file,rollover_flag);

% 
timelist_utc = datevec(timelist);

% az_el_table = dyuma2az_el(gps_alm, location, time0_utc, timef_utc, time_step)
% start_time=time0_utc;
% stop_time=timef_utc;
% function az_el_table = dyuma2az_el(gps_alm, location, start_time, stop_time, time_step)

% yuma2az_el(alm_file, location, start_time, stop_time, time_step)
% A function to read a YUMA file and output satellites' azimuth and
% elevation angles between start_time and stop_time for a given
% station lacation.
%%% This function is derived from iono_as_geomGen.m written by Jiyun Lee.
%  6/20/06 Godwin Zhang 
% 6/29/06 Seebany Datta-Barua Modified to keep information about 1024 week
% rollovers.  This file works with supertruth data for 10/30/03 and
% 301.alm,  This almanac has week rollover so that 10/30/03 is listed as week 218.
% 7 Aug 2013 SDB Commenting out the week rollover parts because the version
% of utc2gps.m I now use doesn't return that info. Output is now 5 cols:
% az_el_table = [mod(gps_week,1024) gps_sec prn az el].
%
% Output:
% table az_el_table = [mod(gps_week,1024) gps_sec rollover_flag prn az el]
% Inputs:   
%alm_file: YUMA filename string
%location:  The lla coordinate of a station, in radian.
%start_time and stop_time: Start and stop time in UTC format.
%time_step: time step in second
% This script uses Constellation Toolbox

% convert the station location from lat, long, alt. to ECEF vector
location_ecef = DCOPYlla2ecef(location);

% load the GPS almanac for the given almanac week
alm_2_use = gps_alm;

%%% Don't need
% % % from Curt's comment : LAN = RAAN - GHA(Greenwich Hour Angle) 
% % % alm_2_use(:,8)  = alm_2_use(:,8) - 275.11*pi/180;%272.64*pi/180; (June 30,23:34:24)%275.11*pi/180; (June 27)% 279.06*pi/180; (July1) 

% sort out the unhealthy satellites
I_gps_good = find(alm_2_use(:,2) == 0);
alm_2_use = alm_2_use(I_gps_good,:);
I_gps_bad = find(alm_2_use(:,2) == ~0);
if ~isempty(I_gps_bad)
    disp('There are unhealthy satellites');
    I_gps_bad
end

% convert the almanacs to ephemeris format
[gps_ephem] = alm2geph(alm_2_use);
scintgps_ephem = gps_ephem(find(gps_ephem(:,1)==scintprn),:);

az_el_out=zeros(length(timelist),2);

for n=1:length(timelist)

% first convert the start and stop times to GPS time.
start_gps = utc2gps(timelist_utc(n,:));
% stop_gps = utc2gps(stop_time);

% compute satellite positions in ECEF frame for the given time range and interval
[t_gps,prn_gps,x_gps,v_gps] = propgeph(scintgps_ephem, start_gps); 
% t_gps(1,:)
% location_ecef
% t_gps
% tm = [prn_gps x_gps]
% compute LOS vectors in ECEF frame
[t_los_gps, gps_los, los_ind] = los(t_gps(1,:), location_ecef, t_gps, [prn_gps x_gps]);

% convert LOS in ECEF to NED frame
% [test_11, test_12, test_51, test_52, test_101, test_102, test_501, test_502] = test_ecef(gps_los)

[gps_los_ned] = ecef2ned(gps_los, location);
% test_11 = ecef2ned(test_11, location);
% test_12 = ecef2ned(test_12, location);
% test_51 = ecef2ned(test_51, location);
% test_52 = ecef2ned(test_52, location);
% test_101 = ecef2ned(test_101, location);
% test_102 = ecef2ned(test_102, location);
% test_501 = ecef2ned(test_501, location);
% test_502 = ecef2ned(test_502, location);

% Compute azimuth and elevation
[az, el] = ned2azel(gps_los_ned);
% [test11_az, test11_el] = ned2azel(test_11);
% [test12_az, test12_el] = ned2azel(test_12);
% [test51_az, test51_el] = ned2azel(test_51);
% [test52_az, test52_el] = ned2azel(test_52);
% [test101_az, test101_el] = ned2azel(test_101);
% [test102_az, test102_el] = ned2azel(test_102);
% [test501_az, test501_el] = ned2azel(test_501);
% [test502_az, test502_el] = ned2azel(test_502);

azdeg=rad2deg(az);
eldeg=rad2deg(el);
% test11_az = rad2deg(test11_az);
% test11_el = rad2deg(test11_el);
% test12_az = rad2deg(test12_az);
% test12_el = rad2deg(test12_el);
% test51_az = rad2deg(test51_az);
% test51_el = rad2deg(test51_el);
% test52_az = rad2deg(test52_az);
% test52_el = rad2deg(test52_el);
% test101_az = rad2deg(test101_az);
% test101_el = rad2deg(test101_el);
% test102_az = rad2deg(test102_az);
% test102_el = rad2deg(test102_el);
% test501_az = rad2deg(test501_az);
% test501_el = rad2deg(test501_el);
% test502_az = rad2deg(test502_az);
% test502_el = rad2deg(test502_el);

% Note: az_el_table will be nx6 because now t_gps is nx3, where the 3rd
% column is the rollover flag.
az_el_table = [t_gps, prn_gps, azdeg, eldeg];
az_el_out(n,:) = az_el_table(1,4:5);
% test11_out = [test11_az, test11_el];
% test12_out = [test12_az, test12_el];
% test51_out = [test51_az, test51_el];
% test52_out = [test52_az, test52_el];
% test101_out = [test11_az, test101_el];
% test102_out = [test12_az, test102_el];
% test501_out = [test501_az, test501_el];
% test502_out = [test502_az, test502_el];
end
end
