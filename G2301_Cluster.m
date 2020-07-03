function [G2301_Emission_Clus,dist_matrix,G2301_Emission_Agg]=G2301_Cluster(G2301_Emission_Agg,lat_Ref,lon_Ref)


Re=6.378e6;

G2301_Emission_Agg(:,15)=(G2301_Emission_Agg(:,3)-lon_Ref).*pi/180.*cos(lat_Ref.*pi/180).*Re; %x Cartesian
G2301_Emission_Agg(:,16)=(G2301_Emission_Agg(:,2)-lat_Ref).*pi/180.*Re;                       %y Cartesian
dist_matrix=zeros(size(G2301_Emission_Agg,1),size(G2301_Emission_Agg,1));


if size(G2301_Emission_Agg,1)>1
        X = G2301_Emission_Agg(:,15:16);
        Z = linkage(X,'ward');
        c = cluster(Z,'cutoff',60,'criterion','distance');

        End_index=max(c);

        for i=1:End_index
            [a,b]=find(c==i);
            lat_temp=sum(G2301_Emission_Agg(a,2).*G2301_Emission_Agg(a,7));
            lon_temp=sum(G2301_Emission_Agg(a,3).*G2301_Emission_Agg(a,7));
            ppmm_temp=sum(G2301_Emission_Agg(a,5));
            bckCH4_temp=max(G2301_Emission_Agg(a,6));
            excessCH4_temp=max(G2301_Emission_Agg(a,7));
            excessCO2_temp=max(G2301_Emission_Agg(a,13));
            excessH2O_temp=max(G2301_Emission_Agg(a,14));
            sum_Excess=sum(G2301_Emission_Agg(a,7));
            emission_v1_temp=max(G2301_Emission_Agg(a,8));
            emission_v2_temp=max(G2301_Emission_Agg(a,9));
            length_temp=sum(G2301_Emission_Agg(a,10));
            x_temp=sum(G2301_Emission_Agg(a,15).*G2301_Emission_Agg(a,7));
            y_temp=sum(G2301_Emission_Agg(a,16).*G2301_Emission_Agg(a,7));

                            G2301_Emission_Clus(i,1)=lat_temp/sum_Excess;          %Lat
                            G2301_Emission_Clus(i,2)=lon_temp/sum_Excess;          %Lon
                            G2301_Emission_Clus(i,3)=x_temp/sum_Excess;            %X_Cartesian
                            G2301_Emission_Clus(i,4)=y_temp/sum_Excess;            %Y_Cartesian
                            G2301_Emission_Clus(i,5)=excessCO2_temp;               %Excess CO2
                            G2301_Emission_Clus(i,6)=excessCH4_temp;               %Excess CH4
                            G2301_Emission_Clus(i,7)=excessH2O_temp;               %Excess H2O
                            G2301_Emission_Clus(i,8)=emission_v2_temp;             %V2
                            G2301_Emission_Clus(i,9)=size(a,1);                    %no of LIs in the cluster
                            G2301_Emission_Clus(i,10)=ppmm_temp/size(a,1);         %PPMM
                            G2301_Emission_Clus(i,11)=bckCH4_temp;                 %back CH4
                            G2301_Emission_Clus(i,12)=length_temp/size(a,1);       %Plume Length
                            G2301_Emission_Clus(i,13)=emission_v1_temp;            %V1
                            
                            
                            
                            
        end
        figure;
            scatter(X(:,1),X(:,2),10,c);
            hold on; scatter(G2301_Emission_Clus(:,3),G2301_Emission_Clus(:,4),'d');
            legend('LIs','LIs Cluster Representatives')
else
    G2301_Emission_Clus(1,1:2)=G2301_Emission_Agg(1,2:3);
    G2301_Emission_Clus(1,3:8)=G2301_Emission_Agg(1,5:10);
    G2301_Emission_Clus(1,9:10)=G2301_Emission_Agg(1,12:13);
    G2301_Emission_Clus(1,11)=1; % number of peaks fall into the cluster
        figure;
            scatter(G2301_Emission_Clus(:,9),G2301_Emission_Clus(:,10),10,G2301_Emission_Clus(:,7));
            hold on; scatter(G2301_Emission_Clus(:,9),G2301_Emission_Clus(:,10),'d');
            legend('Peaks','Cluster Representatives')
end

G2301_Emission_Clus(G2301_Emission_Clus(:,6)<0.1*G2301_Emission_Clus(:,11),:)=[]; %10% CH4 back
end





