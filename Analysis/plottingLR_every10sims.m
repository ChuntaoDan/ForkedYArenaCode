colvec  = cbrewer('qual','Dark2',10,'cubic');

d= 0
for ct = 1:10:2100
    if isnan(LossLOU_mat{ct}(1))||isnan(LossLOU_mat{ct}(2))||isnan(LossLOU_mat{ct}(3))||isnan(LossLOU_mat{ct}(4))||isnan(LossLOU_mat{ct}(5))
        continue
    end
    d = d+1;
    LossLOU(d,1) = LossLOU_mat{ct}(1);
    LossLOU(d,2) = LossLOU_mat{ct}(2);
    LossLOU(d,3) = LossLOU_mat{ct}(3);
    LossLOU(d,4) = LossLOU_mat{ct}(4);
    LossLOU(d,5) = LossLOU_mat{ct}(5);
    LossLOU(d,6) = LossLOU_mat{ct}(6);
    LossLOU(d,7) = LossLOU_mat{ct}(7);
    LossLOU(d,8) = LossLOU_mat{ct}(8);
    LossLOU(d,9) = LossLOU_mat{ct}(9);
    LossLOU(d,10) = LossLOU_mat{ct}(10);
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

end



plot_distribution([1:10],LossLOU,'Color',colvec(5,:))


wi_mat_choices_10 = [];
wi_mat_rewards_10 = [];
wi_mat_choices_rewards_10 = [];
d = 0
for ct = 1:10:2100
    d = d+1;
    wi_mat_choices_10(d,:) = wi_mat{ct,10}(2:11,1);
    wi_mat_rewards_10(d,:) = wi_mat{ct,10}(12:21,1);
    wi_mat_choices_rewards_10(d,:) = wi_mat{ct,10}(22:31,1);
end


figure
subplot 311
plot_distribution([1:10],wi_mat_choices_10(:,1:10),'Color',colvec(5,:))
subplot 312
plot_distribution([1:10],wi_mat_rewards_10(:,1:10),'Color',colvec(5,:))
subplot 313
plot_distribution([1:10],wi_mat_choices_rewards_10(:,1:10),'Color',colvec(5,:))



wi_mat_choices_5 = [];
wi_mat_rewards_5 = [];
wi_mat_choices_rewards_5 = [];
d = 0
for ct = 1:10:2100
    d = d+1;
    wi_mat_choices_5(d,:) = wi_mat{ct,5}(2:6,1);
    wi_mat_rewards_5(d,:) = wi_mat{ct,5}(7:11,1);
    wi_mat_choices_rewards_5(d,:) = wi_mat{ct,5}(12:16,1);
end


figure
subplot 311
plot_distribution([1:5],wi_mat_choices_5(:,1:5),'Color',colvec(5,:))
subplot 312
plot_distribution([1:5],wi_mat_rewards_5(:,1:5),'Color',colvec(5,:))
subplot 313
plot_distribution([1:5],wi_mat_choices_rewards_5(:,1:5),'Color',colvec(5,:))



wi_mat_choices_3 = [];
wi_mat_rewards_3 = [];
wi_mat_choices_rewards_3 = [];
d = 0
for ct = 1:10:2100
    d = d+1
    wi_mat_choices_3(d,:) = wi_mat{ct,3}(2:4,1);
    wi_mat_rewards_3(d,:) = wi_mat{ct,3}(5:7,1);
    wi_mat_choices_rewards_3(d,:) = wi_mat{ct,3}(8:10,1);
end

figure
subplot 311
plot_distribution([1:3],wi_mat_choices_3(:,1:3),'Color',colvec(5,:))
subplot 312
plot_distribution([1:3],wi_mat_rewards_3(:,1:3),'Color',colvec(5,:))
subplot 313
plot_distribution([1:3],wi_mat_choices_rewards_3(:,1:3),'Color',colvec(5,:))


