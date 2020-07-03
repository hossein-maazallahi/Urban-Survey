function G2301_GPS_Combine=Data_Combine(GHG_inter,GPS)
S1=GHG_inter(1,1);
E1=GHG_inter(end,1);
S2=GPS(1,1);
E2=GPS(end,1);
S=max(S1,S2);
E=min(E1,E2);

flag=1;
for i=S:E
    G2301_GPS_Combine(flag,1)=i;                                    %Time
    [I,index]=min(abs(i-GPS(:,1))); 
    G2301_GPS_Combine(flag,2)=GPS(index,2);                         %Lat (degree)
    G2301_GPS_Combine(flag,3)=GPS(index,3);                         %Lon (degree)
    G2301_GPS_Combine(flag,4)=GPS(index,4);                         %Alt (m
    G2301_GPS_Combine(flag,5)=GPS(index,5);                         %Speed (m/s)
    G2301_GPS_Combine(flag,6)=GPS(index,6);                         %Distance driven from the Begining (m)
    [I,index]=min(abs(i-GHG_inter(:,1)));
    G2301_GPS_Combine(flag,7)=GHG_inter(index,2);                   %Carbon Dixide (ppm)
    G2301_GPS_Combine(flag,8)=(0.9969*GHG_inter(index,3)-0.0111);   %Methane_Cal (ppm) 
    G2301_GPS_Combine(flag,9)=GHG_inter(index,3);                   %Methane_Uncal (ppm)
    G2301_GPS_Combine(flag,10)=GHG_inter(index,4);                  %Water (%)
    flag=flag+1;
end

end