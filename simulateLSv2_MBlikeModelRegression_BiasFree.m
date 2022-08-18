[I1,I2,C1_1000,C2_1000,y,R_vec,W_vec,S_vec] = Loewenstein_Seung_v2(0.8,0.2)
y = transpose(y)
X = S_vec(2:2001,:);
R = transpose(R_vec);
R(:,2) = R(:,1);
Y = y
for t_prime = 1:length(Y)
I1(t_prime,1) = sum((t_prime-1)*X(t_prime),2);
end
for t_prime = 1:length(Y)
Q(t_prime,:) = (t_prime-1)*sum(X(1:t_prime,:),1);
end
I2 = sum(X.*Q,2);
for t_prime = 1:length(Y)
R_v(t_prime,:) = (t_prime-1)*sum(R(1:t_prime,:),1);
end
I3 = sum(X.*R_v,2);
S_unsum = X.*R;
for t_prime = 1:length(Y)
S(t_prime,:) = (t_prime-1)*sum(S_unsum(1:t_prime,:),1);
end
I4 = sum(X.*S,2);
I = cat(2,I1,I2,I3,I4);

 
% Y = transpose(Y);


% For the current data set we have two predictors. Therefore beta_zero can 
% be defined as a two element vector. This initializes beta

beta = zeros(4,1);

beta_t_predictors = I*beta;
P_YgX = exp((beta_t_predictors))./(1+exp((beta_t_predictors)));

W = zeros(length(Y),length(Y));
for i = 1:length(Y)
    W(i,i) = P_YgX(i) * (1-P_YgX(i));
end

ll_zero = sum(Y.*log(P_YgX) + ((1-Y).*log(1-P_YgX)));

ll_past = ll_zero;
ll_now = ll_zero;

iter = 1
while ll_past < ll_now || ll_past == ll_zero
    iter = iter + 1
    ll_past = ll_now;

    beta = beta + inv(transpose(I)*W*I)*(transpose(I)*(Y-P_YgX));
    beta_t_predictors = I*beta;
    P_YgX = exp(beta_t_predictors)./(1+exp(beta_t_predictors));

    W = zeros(length(Y),length(Y));
    for i = 1:length(Y)
        W(i,i) = P_YgX(i) * (1-P_YgX(i));
    end
    V1 = Y.*log(P_YgX); 
    V2 = ((1-Y).*log(1-P_YgX));
    V1_nan = isnan(V1);
    V1(find(V1_nan == 1)) = 0;
    V2_nan = isnan(V2);
    V2(find(V2_nan == 1)) = 0;
    V = V1+V2;
    ll_now= sum(V);
end    

