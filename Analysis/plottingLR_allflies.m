colvec = cbrewer('qual','Dark2',10,'cubic');

wi_mat_choices_15 = [];
wi_mat_rewards_15 = [];
wi_mat_choices_rewards_15 = [];
count = 0;
for d = 1:18
        count = count + 1

        wi_mat_choices_15(count,:) = wi_mat{d,15}(1:16,1);
        wi_mat_rewards_15(count,:) = wi_mat{d,15}(17:31,1);

end 

figure
subplot 211
errorbar(mean(wi_mat_choices_15(:,2:16)),std(wi_mat_choices_15(:,2:16))/sqrt(18))
subplot 212
errorbar(mean(wi_mat_rewards_15(:,1:15)),std(wi_mat_rewards_15(:,1:15))/sqrt(18))
