function GHG_inter=G2301_interGHG(G2301_DataFile,delay)
    Time = G2301_DataFile(:,1)*86400-delay;
    Ts=ceil(Time(1,1));
    Te=floor(Time(end,1));
    GHG_inter(:,1) = linspace(Ts,Te,(Te-Ts)+1)';
    
for i=2:size(G2301_DataFile,2)
            GHG_inter(:,i)=interpn(Time(1:1:end),G2301_DataFile(1:1:end,i),GHG_inter(:,1),'linear');
end
    GHG_inter(end-1:end,:)=[];
end