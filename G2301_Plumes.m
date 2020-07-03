function G2301_Peaks=G2301_Plumes(G2301_SpeedCheck)
    [G2301_Peaks(:,1),G2301_Peaks(:,2), G2301_Peaks(:,3)] = findpeaks(G2301_SpeedCheck(:,11)); %First Column is the peak and second column is the indixes
    [a,b,c]=findpeaks(-G2301_SpeedCheck(:,11));
    if b(1)>G2301_Peaks(1,2)
        G2301_Peaks(1,:)=[];
    end
    
    if b(end)>G2301_Peaks(end,2)
        a(end)=[];
        b(end)=[];
        c(end)=[];
    end
    G2301_Peaks(:,4)=a;
    G2301_Peaks(:,5)=b; 
    G2301_Peaks(:,6)=c;
    
end