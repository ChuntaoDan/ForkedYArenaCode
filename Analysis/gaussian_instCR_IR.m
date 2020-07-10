load('choice_order.mat')
load('reward_order.mat')
load('cps_pre.mat')

x = 0:0.1:length(choice_order)/10;
pd1 = makedist('HalfNormal','mu',0,'sigma',3);
pdf2 = pdf(pd1,x)

M_IncomeOrder2 = [];
for j =1:length(reward_order(length(cps_pre):end))
if reward_order(j) == 1
M_IncomeOrder2(j) = 1;
elseif reward_order(j) ~= 1
M_IncomeOrder2(j) = 0;
end
end
M_IR2 = []
for i = 1:length(reward_order(length(cps_pre):end))
M_IR2(i) = M_IncomeOrder2(1:i)*transpose(flip(pdf2(1:i)));
end

O_IncomeOrder2 = [];
for j =1:length(reward_order(length(cps_pre):end))
if reward_order(j) == 2
O_IncomeOrder2(j) = 1;
elseif reward_order(j) ~= 2
O_IncomeOrder2(j) = 0;
end
end
O_IR2 = []
for i = 1:length(reward_order(length(cps_pre):end))
O_IR2(i) = O_IncomeOrder2(1:i)*transpose(flip(pdf2(1:i)));
end

IR = O_IR2./M_IR2;


O_ChoiceOrder2 = [];
for j =1:length(choice_order(length(cps_pre):end))
if choice_order(j) == 1
O_ChoiceOrder2(j) = 0;
else
O_ChoiceOrder2(j) = 1;
end
end
O_CR2 = []
for i = 1:length(choice_order(length(cps_pre):end))
O_CR2(i) = O_ChoiceOrder2(1:i)*flip(transpose(pdf2(1:i)));
end

M_ChoiceOrder2 = [];
for j =1:length(choice_order(length(cps_pre):end))
if choice_order(j) == 1
M_ChoiceOrder2(j) = 1;
else
M_ChoiceOrder2(j) = 0;
end
end
M_CR2 = []
for i = 1:length(choice_order(length(cps_pre):end))
M_CR2(i) = M_ChoiceOrder2(1:i)*flip(transpose(pdf2(1:i)));
end

CR = O_CR2./M_CR2;

figure 
plot(rad2deg(atan(IR)),'LineWidth',4,'Color','k')
hold on
plot(rad2deg(atan(CR)),'LineWidth',4,'Color','b')