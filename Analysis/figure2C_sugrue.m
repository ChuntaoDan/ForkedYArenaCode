function [mean_for_efficiancy_list,std_for_efficiancy_list] = figure2C_sugrue(tau_start,tau_end,num_trials,x,figures_on)

mean_for_efficiancy_list = zeros(tau_end-tau_start+1,1);
std_for_efficiancy_list = zeros(tau_end-tau_start+1,1);

for tau = tau_start:tau_end
    tau
    for_efficiancy_list_current_tau = [];
    for i = 1:1000
        
        for_efficiancy_list_current_tau(i) = leaky_integrator_model(num_trials,x,tau,figures_on);
    end
    mean_for_efficiancy_list(tau-tau_start+1,1) = mean(for_efficiancy_list_current_tau);
    std_for_efficiancy_list(tau-tau_start+1,1) = std(for_efficiancy_list_current_tau);
end

end