

blocklength = 0;
bONEacc = 0;
bTWOacc = 0;
bTHREEacc = 0;
bFOURacc = 0;
bFIVEacc = 0;
bSIXacc = 0;



for w = 1:length(data)
    if block == 1
        blocklength = blocklength + 1;
        
        if acc == 1
            bONEacc = bONEacc + 1;
        end
        
    elseif block == 2
        if acc == 1
            bTWOacc = bTWOacc + 1;
        end
        
    elseif block == 3
        if acc == 1
            bTHREEacc = bTHREEacc + 1;
        end
        
    elseif block == 4
        if acc == 1
            bFOURacc = bFOURacc + 1;
        end
        
    elseif block == 5
        if acc == 1
            bFIVEacc = bFIVEacc + 1;
        end
        
    elseif block == 6
        if acc == 1
            bSIXacc = bSIXacc + 1;
        end
        
        
    else clear all
    end
end

trainingacc = [bONEacc bTWOacc bTHREEacc bFOURacc bFIVEacc bSIXacc];
trainingacc = trainingacc/blocklength;


cleandata(k,1:6) = trainingacc;






















































k = k+1;
