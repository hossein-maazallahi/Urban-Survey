function G2301_Elevation=G2301_Baseline (G2301_GPS_Combine)
%%  MATLAB msbackadj
G2301_Elevation=zeros(size(G2301_GPS_Combine,1),12);
G2301_Elevation(:,1:6)=G2301_GPS_Combine(:,1:6);

% initially the background would be set by the msbackadj
G2301_Elevation(:,10)=msbackadj(G2301_GPS_Combine(:,1),G2301_GPS_Combine(:,7),'WindowSize',300);    %CO2 Elevation
G2301_Elevation(:,11)=msbackadj(G2301_GPS_Combine(:,1),G2301_GPS_Combine(:,8),'WindowSize',300);    %CH4 Elevation
G2301_Elevation(:,12)=msbackadj(G2301_GPS_Combine(:,1),G2301_GPS_Combine(:,10),'WindowSize',300);   %H2O Elevation
G2301_Elevation(:,7)=G2301_GPS_Combine(:,7)-G2301_Elevation(:,10);                                  %CO2 Background
G2301_Elevation(:,8)=G2301_GPS_Combine(:,8)-G2301_Elevation(:,11);                                %CH4 Background
G2301_Elevation(:,9)=G2301_GPS_Combine(:,10)-G2301_Elevation(:,12);                                 %H2O Background

%% Median from Moving Window
% taking out the background by the median of X-min moving average window
t=2.5*60;  % Average window for taking out the background (min*second)
    if size(G2301_Elevation,1)>t  
        S=size(G2301_Elevation,1);
        for i=t+1:S-t-1
            medCO2=prctile(G2301_GPS_Combine(i-t:i+t,7),5);%min(G2301_GPS_Combine(i-t:i+t,7));
            medCH4=median(G2301_GPS_Combine(i-t:i+t,8)); %prctile(G2301_GPS_Combine(i-t:i+t,8),5); %
            medH2O=median(G2301_GPS_Combine(i-t:i+t,10));
            G2301_Elevation(i,7)=medCO2;
            G2301_Elevation(i,8)=medCH4;
            G2301_Elevation(i,9)=medH2O;
        end
    end
    
dif_start=G2301_Elevation(t,7:9)-G2301_Elevation(t+1,7:9);
dif_end=G2301_Elevation(end-t,7:9)-G2301_Elevation(end-t-1,7:9);

weight=linspace(0,1,t)';
G2301_Elevation(1:t,7)=G2301_Elevation(1:t,7)-dif_start(1).*weight;
G2301_Elevation(1:t,8)=G2301_Elevation(1:t,8)-dif_start(2).*weight;
G2301_Elevation(1:t,9)=G2301_Elevation(1:t,9)-dif_start(3).*weight;

weight=linspace(1,0,t+1)';
G2301_Elevation(end-t:end,7)=G2301_Elevation(end-t:end,7)-dif_end(1,1).*weight;
G2301_Elevation(end-t:end,8)=G2301_Elevation(end-t:end,8)-dif_end(1,2).*weight;
G2301_Elevation(end-t:end,9)=G2301_Elevation(end-t:end,9)-dif_end(1,3).*weight;

%% Extracting the Elevations
% Elevation
G2301_Elevation(:,10)=G2301_GPS_Combine(:,7)-G2301_Elevation(:,7);
G2301_Elevation(:,11)=G2301_GPS_Combine(:,8)-G2301_Elevation(:,8);
G2301_Elevation(:,12)=G2301_GPS_Combine(:,10)-G2301_Elevation(:,9);
end

