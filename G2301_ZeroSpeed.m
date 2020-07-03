function G2301_SpeedCheck=G2301_ZeroSpeed(G2301_Enhancement,G2301_GPS_Combine,CampaignDate)
G2301_SpeedCheck=G2301_Enhancement;
G2301_SpeedCheck(G2301_SpeedCheck(:,5)==0,:)=[];

figure
        a=G2301_Enhancement(:,7); %CO2 Background Trend
        b=G2301_Enhancement(:,8); %CH4 Background Trend
        fig(1)=subplot(2,1,1);
        plot(G2301_Enhancement(:,1)/86400,a,'r-','LineWidth',2.5,'MarkerSize',1);
             
        hold on
        
        plot(G2301_GPS_Combine(:,1)/86400,G2301_GPS_Combine(:,7),'LineWidth',1,'MarkerSize',1);

        datetick('x','HH:MM:SS','keepticks', 'keeplimits')
        
        xlabel('Time (UTC)','FontSize',24,'FontWeight','bold')
        ylabel('CO_{2} Mole Fraction (ppm)','FontSize',24,'FontWeight','bold')
        leg=legend('Background Level','Carbon Dioxide Mixing Ratio');
        leg.FontSize=18;
        s=strcat('Picarro G2301 Measurements,',{' '},CampaignDate);
        title(s, 'FontSize', 30,'FontWeight','bold')
        grid on
        grid minor        
        hold off
        grid on
grid minor
ax = gca;
ax.FontSize = 18; 
ax.GridColor = [0 .5 .5];
ax.GridLineStyle = '--';
ax.GridAlpha = 0.5;
ax.Layer = 'top';
ax.LineWidth = 1.5;

        fig(2)=subplot(2,1,2);
        plot(G2301_Enhancement(:,1)/86400,b,'r-','LineWidth',2.5,'MarkerSize',1)
        hold on
        %datetick('x','hh:mm','keepticks', 'keeplimits')
        plot(G2301_GPS_Combine(:,1)/86400,G2301_GPS_Combine(:,8),'LineWidth',1.5,'MarkerSize',1)
        datetick('x','HH:MM:SS','keepticks', 'keeplimits')
        xlabel('Time (UTC)','FontSize',24,'FontWeight','bold')
        ylabel('CH_{4} Mole Fraction (ppm)','FontSize',24,'FontWeight','bold')

        leg=legend('Background Level','Methane Mixing Ratio');
        leg.FontSize=18;
        grid on
        grid minor
        hold off
        linkaxes(fig, 'x');
        grid on
grid minor
ax = gca;
ax.FontSize = 18; 
ax.GridColor = [0 .5 .5];
ax.GridLineStyle = '--';
ax.GridAlpha = 0.5;
ax.Layer = 'top';
ax.LineWidth = 1.5;
end
