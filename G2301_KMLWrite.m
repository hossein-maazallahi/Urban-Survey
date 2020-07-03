function G2301_KMLWrite(G2301_SpeedCheck,KML_FileName)
directory=strcat('output/',KML_FileName);
a=size(G2301_SpeedCheck,1);
kmlwriteline(directory, G2301_SpeedCheck(1:2:a,2),G2301_SpeedCheck(1:2:a,3),G2301_SpeedCheck(1:2:a,11)*100);
end