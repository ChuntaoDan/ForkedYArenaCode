files = dir();

files([1:2, 4:5, 7:9, 16:17, 48:50]) = [];
pr_staying_g_Nreward = [];
pr_staying_g_reward =[];
pr_switching_g_Nreward = [];
pr_switching_g_reward =[];
groups = {};

for a = 1:38
load(files(a).name);
pr_staying_g_Nreward = cat(2,pr_staying_g_Nreward,p_staying_g_Nreward);
pr_staying_g_reward = cat(2,pr_staying_g_reward,p_staying_g_reward);
pr_switching_g_Nreward = cat(2,pr_switching_g_Nreward,p_switching_g_Nreward);
pr_switching_g_reward = cat(2,pr_switching_g_reward,p_switching_g_reward);

    for j = length(groups)+1 :  length(pr_staying_g_reward)
        groups{j} = num2str(a);
    end    
end
