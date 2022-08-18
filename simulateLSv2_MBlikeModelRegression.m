[I1,I2,C1_1000,C2_1000,y,R_vec,W_vec,S_vec] = Loewenstein_Seung_v2(0.8,0.2)
y = transpose(y)
X = S_vec(2:2001,:);
R = transpose(R_vec);
R(:,2) = R(:,1);
R_ave = []
for timept = 1:length(Y)
    if timept < 10
        R_ave(timept,:) = mean(R(1:timept,:),1);
    else
        R_ave(timept,:) = mean(R(timept-9:timept,:),1);
    end
end    

R_ER = R - R_ave;

Y = y
for t_prime = 1:length(Y)
I1(t_prime,1) = sum((t_prime-1)*X(t_prime),2);
end
for t_prime = 1:length(Y)
Q(t_prime,:) = sum(X(1:t_prime,:),1);
end
I2 = sum(X.*Q,2);
for t_prime = 1:length(Y)
R_v(t_prime,:) = sum(R_ER(1:t_prime,:),1);
end
I3 = sum(X.*R_v,2);
S_unsum = X.*R;
for t_prime = 1:length(Y)
S(t_prime,:) = sum(S_unsum(1:t_prime,:),1);
end
I4 = sum(X.*S,2);
I = cat(2,I1,I2,I3,I4);
[B,FitInfo] = lassoglm(I,Y,'binomial','CV',10);%,'Alpha',0.1);
idxLambdaMinDeviance = FitInfo.IndexMinDeviance;
B0 = FitInfo.Intercept(idxLambdaMinDeviance);
wi = [B0; B(:,idxLambdaMinDeviance)];
yhat = glmval(wi,I,'logit');
find(X(:,1) == 1)
figure; plot(Y(ans))
hold on
plot(yhat(ans))
figure
for i = 6:length(Y)-6
Y_tA(i-5) = mean(Y(i-5:i+5))
end
for i = 6:length(Y)-6
yhat_tA(i-5) = mean(yhat(i-5:i+5))
end
plot(Y_tA)
hold on
plot(yhat_tA)
find(X(:,2) == 1)
figure; plot(Y(ans))
hold on
plot(yhat(ans))