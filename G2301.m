clc
close all
clear all

%% Importing measurement files

%Import the G2301 data file
Campaign='Hamburg';

%Allocate imported array to column variable names
GPSName = convertStringsToChars("20181024-095557");
Picarro = convertStringsToChars("Hamburg_G2301_20181024");
delay   = 28;
lat_Ref = 53.547479;                      % x=0;
lon_Ref = 9.990709;                       % y=0;

%% Clear temporary variables
clearvars data raw stringVectors;
G2301_FileName=strcat(Picarro);    % Fill the Picarro file name in the ''
G2301_DataFile=G2301_import(G2301_FileName);

%Import GPS data file
GPS_FileName=strcat(GPSName);      % Fill the GPS file name in the ''
GPS=GPS_import(GPS_FileName);
CampaignDate=strcat(Campaign,';',{' '},GPSName);

%% G2301 File
% Allocate imported picarro measurement files to column variable names
% GHG Interpolation
GHG_inter=G2301_interGHG(G2301_DataFile,delay);

%% Combine Picarro Files and GPS
G2301_GPS_Combine=Data_Combine(GHG_inter,GPS);

%% Extracting the Base line (Background concentration for ch4/co2/H2o, order,framelen)
G2301_Enhancement=G2301_Baseline(G2301_GPS_Combine);

%% Removing Driving Stops (Applying Mean Values for the period where the speed was zero)
G2301_SpeedCheck=G2301_ZeroSpeed(G2301_Enhancement,G2301_GPS_Combine,CampaignDate);

%% Plume Detection
G2301_Peaks=G2301_Plumes(G2301_SpeedCheck);

%% Plume Gauss Fit
[G2301_GaussPlumes,Gauss_Ceof,fit_GOF,G2301_Peaks,x]=G2301_Gauss(G2301_Peaks,G2301_SpeedCheck,CampaignDate,Campaign);

%% Emission
G2301_Emission=G2301_Quantification(G2301_GaussPlumes,G2301_Peaks,G2301_SpeedCheck,x,CampaignDate,GPSName,Gauss_Ceof);

%% Time Aggregation
G2301_Emission_Agg=G2301_TimeAggregation(G2301_Emission);

%% Clustering
[G2301_Emission_Clus,dist_matrix,G2301_Emission_Agg]=G2301_Cluster(G2301_Emission_Agg,lat_Ref,lon_Ref);

%% Output Files
% KML file generator
KML_FileName=strcat(Campaign,'/','G2301','_',Campaign,GPSName); 
G2301_KMLWrite(G2301_SpeedCheck,KML_FileName);