function GPS=GPS_import(GPS_FileName)
%% GPS .txt File
delimiter = ',';
startRow = 2;

%% Format for each line of text:
%   column2: text (%s)
%	column3: double (%f)
%   column4: double (%f)
%	column5: double (%f)
%   column6: double (%f)
%	column7: text (%s)
%   column8: double (%f)
%	column9: double (%f)
%   column10: double (%f)
%	column11: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%*s%s%f%f%f%f%s%f%f%f%f%*s%*s%[^\n\r]';

%% Open the text file.
fileID = fopen(strcat(GPS_FileName,'.txt'),'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
GPS_Text = table(dataArray{1:end-1}, 'VariableNames', {'time','latitude','longitude','accuracym','altitudem','geoid_heightm','speedms','bearingdeg','sat_used','sat_inview'});

GPSFlag=dataArray{:,4};
%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%% GPS .gpx File
trk = gpxread(strcat(GPS_FileName), 'FeatureType', 'track');
timeStr = strrep(trk.Time, 'T', ' ');
timeStr = strrep(timeStr, '.000Z', '');
trk.DateNumber = datenum(timeStr,'yyyy-mm-dd HH:MM:SS', 31);
day = fix(trk.DateNumber(1));
trk.TimeOfDay = trk.DateNumber - day;

%% Write GPS Variable
GPS(:,1)=round(trk.TimeOfDay*86400);
GPS(:,2)=trk.Latitude; %Latitude
GPS(:,3)=trk.Longitude; %Longitude
GPS(:,4)=trk.Elevation; %Altitude m
GPS(:,5)=table2array(GPS_Text(:,7)); % Speed m/s
GPS(:,6)=cumsum(GPS(:,5));
GPS(:,7)=GPSFlag;
GPS(GPS(:,7)==10,:)=[]; %Coordinates with low GPS Quality get Removed
end