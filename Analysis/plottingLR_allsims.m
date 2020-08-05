colvec = color_vec = cbrewer('qual','Dark2',10,'cubic');

figure
hold on
Pc_1_mat = [];
Pc_2_mat = [];
Pc_3_mat = [];
Pc_4_mat = [];
Pc_5_mat = [];
Pc_6_mat = [];
Pc_7_mat = [];
Pc_8_mat = [];
Pc_9_mat = [];
Pc_10_mat = [];
Pc_11_mat = [];
Pc_12_mat = [];
Pc_13_mat = [];
Pc_14_mat = [];
Pc_15_mat = [];
Pc_16_mat = [];
Pc_17_mat = [];
Pc_18_mat = [];
Pc_19_mat = [];
Pc_20_mat = [];

for d = 1:2100
    Pc_1_mat(d,1:length(Pc_mat{d}(1,:))) = Pc_mat{d}(1,:);
    Pc_2_mat(d,1:length(Pc_mat{d}(1,:))) = Pc_mat{d}(2,:);
    Pc_3_mat(d,1:length(Pc_mat{d}(1,:))) = Pc_mat{d}(3,:);
    Pc_4_mat(d,1:length(Pc_mat{d}(1,:))) = Pc_mat{d}(4,:);
    Pc_5_mat(d,1:length(Pc_mat{d}(1,:))) = Pc_mat{d}(5,:);
    Pc_6_mat(d,1:length(Pc_mat{d}(1,:))) = Pc_mat{d}(6,:);
    Pc_7_mat(d,1:length(Pc_mat{d}(1,:))) = Pc_mat{d}(7,:);
    Pc_8_mat(d,1:length(Pc_mat{d}(1,:))) = Pc_mat{d}(8,:);
    Pc_9_mat(d,1:length(Pc_mat{d}(1,:))) = Pc_mat{d}(9,:);
    Pc_10_mat(d,1:length(Pc_mat{d}(1,:))) = Pc_mat{d}(10,:);
%     Pc_11_mat(d,1:length(Pc_mat{d}(1,:))) = Pc_mat{d}(11,:);
%     Pc_12_mat(d,1:length(Pc_mat{d}(1,:))) = Pc_mat{d}(12,:);
%     Pc_13_mat(d,1:length(Pc_mat{d}(1,:))) = Pc_mat{d}(13,:);
%     Pc_14_mat(d,1:length(Pc_mat{d}(1,:))) = Pc_mat{d}(14,:);
%     Pc_15_mat(d,1:length(Pc_mat{d}(1,:))) = Pc_mat{d}(15,:);
%     Pc_16_mat(d,1:length(Pc_mat{d}(1,:))) = Pc_mat{d}(16,:);
%     Pc_17_mat(d,1:length(Pc_mat{d}(1,:))) = Pc_mat{d}(17,:);
%     Pc_18_mat(d,1:length(Pc_mat{d}(1,:))) = Pc_mat{d}(18,:);
%     Pc_19_mat(d,1:length(Pc_mat{d}(1,:))) = Pc_mat{d}(19,:);
%     Pc_20_mat(d,1:length(Pc_mat{d}(1,:))) = Pc_mat{d}(20,:);
% 

end  
    
meanPc(:,1) = (mean(Pc_1_mat,2));
meanPc(:,2) = (mean(Pc_2_mat(:,1:238),2));
meanPc(:,3) = (mean(Pc_3_mat(:,1:237),2));
meanPc(:,4) = (mean(Pc_4_mat(:,1:236),2));
meanPc(:,5) = (mean(Pc_5_mat(:,1:235),2));
meanPc(:,6) = (mean(Pc_6_mat(:,1:234),2));
meanPc(:,7) = (mean(Pc_7_mat(:,1:233),2));
meanPc(:,8) = (mean(Pc_8_mat(:,1:232),2));
meanPc(:,9) = (mean(Pc_9_mat(:,1:231),2));
meanPc(:,10) = (mean(Pc_10_mat(:,1:230),2));

plot_distribution([1:10],meanPc,'Color',colvec(5,:))

wi_mat_choices_10 = [];
wi_mat_rewards_10 = [];
wi_mat_choices_rewards_10 = [];

for d = 1:2100
    wi_mat_choices_10(d,:) = wi_mat{d,10}(2:11,1);
    wi_mat_rewards_10(d,:) = wi_mat{d,10}(12:21,1);
    wi_mat_choices_rewards_10(d,:) = wi_mat{d,10}(22:31,1);

end 

figure;
subplot 311
plot_distribution([1:10],wi_mat_choices_10(:,1:10),'Color',colvec(5,:))
subplot 312
plot_distribution([1:10],wi_mat_rewards_10(:,1:10),'Color',colvec(5,:))
subplot 313
plot_distribution([1:10],wi_mat_choices_rewards_10(:,1:10),'Color',colvec(5,:))


<<<<<<< HEAD

wi_mat_choices_3 = [];
wi_mat_rewards_3 = [];
wi_mat_choices_rewards_3 = [];

for d = 1:2100
    wi_mat_choices_3(d,:) = wi_mat{d,3}(2:4,1);
    wi_mat_rewards_3(d,:) = wi_mat{d,3}(5:7,1);
    wi_mat_choices_rewards_3(d,:) = wi_mat{d,3}(8:10,1);
=======
wi_mat_choices_5 = [];
wi_mat_rewards_5 = [];
wi_mat_choices_rewards_5 = [];

for d = 1:2100
    wi_mat_choices_5(d,:) = wi_mat{d,5}(2:6,1);
    wi_mat_rewards_5(d,:) = wi_mat{d,5}(7:11,1);
    wi_mat_choices_rewards_5(d,:) = wi_mat{d,5}(12:16,1);
>>>>>>> 082b6c139c26158bb5d768527420841216ba232b

end 


subplot 311
<<<<<<< HEAD
plot_distribution([1:3],wi_mat_choices_3(:,1:3),'Color',colvec(5,:))
subplot 312
plot_distribution([1:3],wi_mat_rewards_3(:,1:3),'Color',colvec(5,:))
subplot 313
plot_distribution([1:3],wi_mat_choices_rewards_3(:,1:3),'Color',colvec(5,:))


for d = 1:2100
    LossLOU(d,1) = LossLOU_mat{d}(1);
    LossLOU(d,2) = LossLOU_mat{d}(2);
    LossLOU(d,3) = LossLOU_mat{d}(3);
    LossLOU(d,4) = LossLOU_mat{d}(4);
    LossLOU(d,5) = LossLOU_mat{d}(5);
    LossLOU(d,6) = LossLOU_mat{d}(6);
    LossLOU(d,7) = LossLOU_mat{d}(7);
    LossLOU(d,8) = LossLOU_mat{d}(8);
    LossLOU(d,9) = LossLOU_mat{d}(9);
    LossLOU(d,10) = LossLOU_mat{d}(10);
%     LossLOU(d-1,11) = LossLOU_mat{d}(11);
%     LossLOU(d-1,12) = LossLOU_mat{d}(12);
%     LossLOU(d-1,13) = LossLOU_mat{d}(13);
%     LossLOU(d-1,14) = LossLOU_mat{d}(14);
%     LossLOU(d-1,15) = LossLOU_mat{d}(15);
%     LossLOU(d-1,16) = LossLOU_mat{d}(16);
%     LossLOU(d-1,17) = LossLOU_mat{d}(17);
%     LossLOU(d-1,18) = LossLOU_mat{d}(18);
%     LossLOU(d-1,19) = LossLOU_mat{d}(19);
%     LossLOU(d-1,20) = LossLOU_mat{d}(20);
=======
plot_distribution([1:5],wi_mat_choices_5(:,1:5),'Color',colvec(5,:))
subplot 312
plot_distribution([1:5],wi_mat_rewards_5(:,1:5),'Color',colvec(5,:))
subplot 313
plot_distribution([1:5],wi_mat_choices_rewards_5(:,1:5),'Color',colvec(5,:))


for d = 2:15
    LossLOU(d-1,1) = LossLOU_mat{d}(1);
    LossLOU(d-1,2) = LossLOU_mat{d}(2)
    LossLOU(d-1,3) = LossLOU_mat{d}(3)
    LossLOU(d-1,4) = LossLOU_mat{d}(4)
    LossLOU(d-1,5) = LossLOU_mat{d}(5)
    LossLOU(d-1,6) = LossLOU_mat{d}(6)
    LossLOU(d-1,7) = LossLOU_mat{d}(7)
    LossLOU(d-1,8) = LossLOU_mat{d}(8)
    LossLOU(d-1,9) = LossLOU_mat{d}(9)
    LossLOU(d-1,10) = LossLOU_mat{d}(10)
    LossLOU(d-1,11) = LossLOU_mat{d}(11)
    LossLOU(d-1,12) = LossLOU_mat{d}(12)
    LossLOU(d-1,13) = LossLOU_mat{d}(13)
    LossLOU(d-1,14) = LossLOU_mat{d}(14)
    LossLOU(d-1,15) = LossLOU_mat{d}(15)
    LossLOU(d-1,16) = LossLOU_mat{d}(16)
    LossLOU(d-1,17) = LossLOU_mat{d}(17)
    LossLOU(d-1,18) = LossLOU_mat{d}(18)
    LossLOU(d-1,19) = LossLOU_mat{d}(19)
    LossLOU(d-1,20) = LossLOU_mat{d}(20)
>>>>>>> 082b6c139c26158bb5d768527420841216ba232b
end    

plot_distribution([1:10],LossLOU,'Color',colvec(5,:))
