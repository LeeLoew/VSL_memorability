%must be edited to reflect high-low male-female faces

female_high = 1;
male_high = 2;
female_low = 3;
male_low = 4;

high_high = 1;
high_low = 2;
low_high = 3;
low_low = 4;
i = 1;

for i = 1:length(recData)
    if recData(i,1) == female_high %if first image female high
        if recData(i,3) == female_high %if second image female high
            recData(i,14) = high_high;
        elseif recData(i,3) == female_low %if second image female_low
            recData(i,14) = high_low;
        elseif recData(i,3) == male_high %if second image male high
             recData(i,14) = high_high;
        elseif recData(i,3) == male_low %if second image male_low
            recData(i,14) = high_low;
        else
            recData(i,14) = -911;
        end
        
        
    elseif recData(i,1) == male_high %if first image male high
        if recData(i,3) == male_high %if second image male high
            recData(i,14) = high_high;
        elseif recData(i,3) == male_low %if second image male_low
            recData(i,14) = high_low;
        elseif recData(i,3) == female_high %if second image female high
            recData(i,14) = high_high;
        elseif recData(i,3) == female_low %if second image female_low
            recData(i,14) = high_low;
        else
            recData(i,14) = -911;
        end
        
    elseif recData(i,1) == female_low %if first image female_low
        if recData(i,3) == female_low
            recData(i,14) = low_low;
        elseif recData(i,3) == female_high
            recData(i,14) = low_high;
        elseif recData(i,3) == male_low
            recData(i,14) = low_low;
        elseif recData(i,3) == male_high
            recData(i,14) = low_high;
        else
            recData(i,14) = -911;
        end
        
    elseif recData(i,1) == male_low %if first image male_low
        if recData(i,3) == male_low
            recData(i,14) = low_low;
        elseif recData(i,3) == male_high
            recData(i,14) = low_high;
        elseif recData(i,3) == female_low
            recData(i,14) = low_low;
        elseif recData(i,3) == female_high
            recData(i,14) = low_high;
        else
            recData(i,14) = -911;
        end
        
        
        
    end
    
    
end

zzz = [0 0 0 0 0 0 0 0];


for i = 1:length(recData)
    if recData(i,11) == 1
        if recData(i,14) == high_high;
            
            zzz = zzz+[1 0 0 0 0 0 0 0];
        elseif recData(i,14) == high_low;
            zzz = zzz+[0 1 0 0 0 0 0 0];
            
        elseif recData(i,14) == low_high;
            zzz = zzz+[0 0 1 0 0 0 0 0];
            
        elseif recData(i,14) == low_low;
            zzz = zzz+[0 0 0 1 0 0 0 0];
            
            
        end
        
    end
end









zzz = zzz/16;

zzzz(k, :) = zzz;
k = k+1;


