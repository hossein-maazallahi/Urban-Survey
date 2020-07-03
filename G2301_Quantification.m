function [G2301_Emission,G2301_Emission_Agg]=G2301_Quantification(G2301_GaussPlumes,G2301_Peaks,G2301_SpeedCheck,x,CampaignDate,GPSName,Gauss_Ceof)
%% Exclude the peak with speed more than 70km/h
%%
for i=1:size(G2301_GaussPlumes,1)
    G2301_Emission(i,1)=G2301_SpeedCheck(G2301_Peaks(i,2),1); %Time
    G2301_Emission(i,2)=G2301_SpeedCheck(G2301_Peaks(i,2),2); %Lat
    G2301_Emission(i,3)=G2301_SpeedCheck(G2301_Peaks(i,2),3); %Lon
    G2301_Emission(i,4)=G2301_SpeedCheck(G2301_Peaks(i,2),6); %Distance
    
    %% Estimating Peak Area based on the Gaussiam model
    G2301_Emission(i,5)=trapz(x(1,:),G2301_GaussPlumes(i,:)); %Area beneath the Gauss fit Curve
    G2301_Emission(i,6)=G2301_SpeedCheck(G2301_Peaks(i,2),8); %CH4 Back
    [a,b]=max(G2301_GaussPlumes(i,:));
    G2301_Emission(i,7)=G2301_SpeedCheck(G2301_Peaks(i,2),11); %CH4 excess
    G2301_Emission(i,13)=G2301_SpeedCheck(G2301_Peaks(i,2),10); %CO2 excess
    G2301_Emission(i,14)=G2301_SpeedCheck(G2301_Peaks(i,2),12); %H2O excess
    
end
    A=G2301_Emission(:,5);
    M=G2301_Emission(:,6);
    K=A./M;
    G2301_Emission(:,8)=10.^(0.1178+0.08267.*M-0.005175.*A+0.08626.*K);  
    for i=1:size(G2301_GaussPlumes,1)        
        G2301_Emission(i,9)=exp((log(G2301_Emission(i,7))+0.988)./0.817);
    end
    
%% Length of the Plume
unit=max(G2301_SpeedCheck(:,6))/100000;
for i=1:size(G2301_GaussPlumes,1)
    if max(G2301_GaussPlumes(i,:))>0.2
        G2301_Emission(i,10)=sum(G2301_GaussPlumes(i,:)>0.2)*unit; %Plume Length
    else
        G2301_Emission(i,10)=0;
    end
end

%% Add ID to the matrix; Writing the date to the matrix from the GPS Name
G2301_Emission(:,11)=str2double(GPSName(1:8)); 

%% Speed
G2301_Emission(:,12)=G2301_SpeedCheck(G2301_Peaks(1:end-1,2),5); %Speed

%% 200 ppb,160m, 1m length Constrain, and Speed Constraint
G2301_Emission(G2301_Emission(:,10)>160,:)=[];
G2301_Emission(G2301_Emission(:,10)<2,:)=[];
G2301_Emission(G2301_Emission(:,12)>19.45,:)=[];
G2301_Emission(G2301_Emission(:,12)==0,:)=[];

%% Removing the peaks were the eleveation was modelled 0
[index]=find(G2301_Emission(:,7)==0);
G2301_Emission(index,:)=[];

end