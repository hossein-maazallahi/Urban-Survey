function G2301_Emission_Agg=G2301_TimeAggregation(G2301_Emission)
%% Aggregating the peak with 5 second or less time difference
flag=zeros(size(G2301_Emission,1),1);

family=0;
for i=1:size(G2301_Emission,1)-1
    if flag(i,1)==0
        family=family+1;
        family_index=false;
        for j=i+1:size(G2301_Emission,1)
            if flag(j,1)==0 && abs(G2301_Emission(i,1)-G2301_Emission(j,1))<6
                flag(i,1)=family;
                flag(j,1)=family;
                family_index=true;
            end
        end
        if family_index
            family=family;
            family_index=false;
        else
            family=family-1;
        end
    end
end
delet=[];
m=max(flag(:,1));
if m==0
    G2301_Emission_Agg=G2301_Emission;
else
    G2301_Emission_Agg=G2301_Emission(:,1:14);
    for k=1:m
        [a,b]=find(flag(:,1)==k);
        time=G2301_Emission(a(1,1),1);
        lat=sum((G2301_Emission(a(:),7).*G2301_Emission(a(:),2)))/sum(G2301_Emission(a(:),7));
        lon=sum(G2301_Emission(a(:),7).*G2301_Emission(a(:),3))/sum(G2301_Emission(a(:),7));
        dis=sum(G2301_Emission(a(:),7).*G2301_Emission(a(:),4))/sum(G2301_Emission(a(:),7));
        area=sum(G2301_Emission(a(:),7).*G2301_Emission(a(:),5))/sum(G2301_Emission(a(:),7));
        bckCH4=max(G2301_Emission(a,6));
        elCH4=max(G2301_Emission(a,7));
        elCO2=max(G2301_Emission(a,13));
        elH2O=max(G2301_Emission(a,14));
        vonFischer2017=max(G2301_Emission(a,8));
        Weller2019=max(G2301_Emission(a,9));
        G2301_Emission_Agg(a(1,1),1)=time;
        G2301_Emission_Agg(a(1,1),2)=lat;
        G2301_Emission_Agg(a(1,1),3)=lon;
        G2301_Emission_Agg(a(1,1),4)=dis;
        G2301_Emission_Agg(a(1,1),5)=area;
        G2301_Emission_Agg(a(1,1),6)=bckCH4;
        G2301_Emission_Agg(a(1,1),7)=elCH4;
        G2301_Emission_Agg(a(1,1),8)=vonFischer2017;
        G2301_Emission_Agg(a(1,1),9)=Weller2019;
        G2301_Emission_Agg(a(1,1),13)=elCO2;
        G2301_Emission_Agg(a(1,1),14)=elH2O;
        delet=[delet;a(2:end)];
    end
end
G2301_Emission_Agg(delet,:) = [];
G2301_Emission_Agg( ~any(G2301_Emission_Agg,2), : ) = []; %Remove zero rows
end