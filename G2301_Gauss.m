function [G2301_GaussPlumes,Gauss_Ceof,fit_GOF,G2301_Peaks,x]=G2301_Gauss(G2301_Peaks,G2301_SpeedCheck,CampaignDate,Campaign)

    flag=0;
for i=1:size(G2301_Peaks,1)-1
    
    flag=flag+1;
    XValues=G2301_SpeedCheck(G2301_Peaks(i,5):G2301_Peaks(i+1,5),6);  %Distance XAxis
    YValues=G2301_SpeedCheck(G2301_Peaks(i,5):G2301_Peaks(i+1,5),11); %Methane YAxis
    [xData, yData] = prepareCurveData( XValues, YValues );

    % Set up fittype and options.
    ft = fittype( 'gauss1' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.Lower = [-Inf -Inf 0];
    %opts.StartPoint = [0.001402433650875 250 1.85370619608721];

    % Fit model to data.
    [fitresult, gof] = fit( xData, yData, ft, opts );
    Gauss_Ceof(flag,:)=coeffvalues(fitresult);
    fit_GOF(flag,:)=gof;
end
    Pos = G2301_SpeedCheck(G2301_Peaks(:,2),6);
    Hgt = G2301_Peaks(:,1);
    Wdt = G2301_Peaks(:,3);
    x = linspace(0,max(G2301_SpeedCheck(:,6)),100000);
    for n = 1:length(Gauss_Ceof)
        G2301_GaussPlumes(n,:) = Gauss_Ceof(n,1).*exp(-((x - Gauss_Ceof(n,2))./Gauss_Ceof(n,3)).^2);
    end
    
    %% Removing undesired Gauss Fits; by checking if the maximum is more than double value of the measurements
row_delet(1)=NaN;
    flag=0;
    for i=1:size(G2301_GaussPlumes,1)
        if max(G2301_GaussPlumes(i,:))>2*G2301_Peaks(i,1) %==0 %cellfun(@isnan,a(5,i)) % check if the cell is NaN
            flag=flag+1;
            row_delet(flag)=i;
        end  
    end
    if ~isnan(row_delet)
        G2301_GaussPlumes(row_delet,:)=[];
        G2301_Peaks(row_delet,:)=[];
    end
PeakSig = sum(G2301_GaussPlumes);

  
%% correlation plot of Model and Measurements
temp_x(1,1)=G2301_SpeedCheck(1,6);
temp_y(1,1)=G2301_SpeedCheck(1,11);
flag=1;
for i=2:size(G2301_SpeedCheck(:,6),1)
    if G2301_SpeedCheck(i,6)~= G2301_SpeedCheck(i-1,6)
        flag=flag+1;
        temp_x(flag,1)=G2301_SpeedCheck(i,6);
        temp_y(flag,1)=G2301_SpeedCheck(i,11);
    end
end
Measure_Inter=interp1(temp_x,temp_y,x);
Model=sum(G2301_GaussPlumes);

end
