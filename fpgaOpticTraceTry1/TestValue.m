LIGTHCoord = -1000:50:0;
firstScreenCoord = 200;
for i = 1:length(LIGTHCoord)
    [sres] = FunctionToFPGA(LIGTHCoord,firstScreenCoord);
end