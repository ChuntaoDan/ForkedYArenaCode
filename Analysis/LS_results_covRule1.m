clear
clc

count = 0;

for exptn = 1:30
    
    p1 = 0.3 - ((0.3/29)*(exptn-1));
    p2 = 0.3-p1;
    
    for contn = 1:10
        count = count + 1;
        
        [I1(count),I2(count),C1(count),C2(count)] = Loewenstein_Seung_v1(p1,p2);
    end
end


 fI1 = I1./[I1+I2];
 fC1 = C1./[C1+C2];
        
 scatter(fI1,fC1)
 
 hold on
 