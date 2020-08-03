clear
clc

count = 0;

for exptn = 1:30
    
    p1 = 1 - ((1/29)*(exptn-1));
    p2 = 1-p1;
    
    for contn = 1:10
        count = count + 1;
%         [nC1(count),nC2(count),nI1(count),nI2(count),I1_list(count,:),I2_list(count,:),C1_list(count,:),C2_list(count,:)] = Strategy1(300,p1,p2);
%         [nC1(count),nC2(count),nI1(count),nI2(count),I1_list(count,:),I2_list(count,:),C1_list(count,:),C2_list(count,:)] = Strategy2(300,p1,p2,10);
        [nC1(count),nC2(count),nI1(count),nI2(count),I1_list(count,:),I2_list(count,:),C1_list(count,:),C2_list(count,:)] = Strategy3(300,p1,p2,100,0.2);
    end
end


 fI1 = nI1./[nI1+nI2];
 fC1 = nC1./[nC1+nC2];
        
 scatter(fI1,fC1)
 
 hold on