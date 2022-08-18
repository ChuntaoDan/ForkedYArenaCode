% FOR 3 ODOR EXPTS
load('pis_0.mat')
load('pis_m.mat')
load('turns.mat')


p_turn_O = [];
p_stay_O = [];
p_turn_M = [];
p_stay_M = [];
p_turn_PO = [];
p_stay_PO = [];
p_turn_PM = [];
p_stay_PM = [];

m_hi = [2,4,5,8,10]
m_low = [1,3,6,7,9]
order = cat(2,m_hi,m_low)

for k = 1:10
    i = k;
        p_stay_M(1,k,:) = (40*individual_pi_m(1,i,:))./((40*individual_pi_m(1,i,:))+num_turns_away_M(1,k,:));
        p_turn_M(1,k,:) = num_turns_away_M(1,k,:)./((40*individual_pi_m(1,i,:))+num_turns_away_M(1,k,:));
        p_stay_PM(1,k,:) = (40*(1-individual_pi_m(1,i,:)))./((40*(1-individual_pi_m(1,i,:)))+num_turns_away_PM(1,k,:));
        p_turn_PM(1,k,:) = num_turns_away_PM(1,k,:)./((40*(1-individual_pi_m(1,i,:)))+num_turns_away_PM(1,k,:));
        p_stay_O(1,k,:) = (40*individual_pi_o(1,i,:))./((40*individual_pi_o(1,i,:))+num_turns_away_O(1,k,:));
        p_turn_O(1,k,:) = num_turns_away_O(1,k,:)./((40*individual_pi_o(1,i,:))+num_turns_away_O(1,k,:));
        p_stay_PO(1,k,:) = (40*(1-individual_pi_o(1,i,:)))./((40*(1-individual_pi_o(1,i,:)))+num_turns_away_PO(1,k,:));
        p_turn_PO(1,k,:) = num_turns_away_PO(1,k,:)./((40*(1-individual_pi_o(1,i,:)))+num_turns_away_PO(1,k,:))
    
end    

p_stay_high_rewarded = [];
p_turn_high_rewarded = [];
p_turn_low_rewarded = [];
p_stay_low_rewarded = [];
p_stay_high_unrewarded = [];
p_turn_high_unrewarded = [];
p_stay_low_unrewarded = [];
p_turn_low_unrewarded = [];

p_turn_low_unrewarded = [];
p_turn_low_unrewarded  = p_turn_PM(1,m_low,:)
p_turn_low_unrewarded(1,6:10,:) = p_turn_PO(1,m_hi(1:5),:)
p_turn_high_unrewarded = [];
p_turn_high_unrewarded  = p_turn_PM(1,m_hi,:)
p_turn_high_unrewarded(1,6:10,:) = p_turn_PO(1,m_low(1:5),:)
p_stay_low_unrewarded = [];
p_stay_low_unrewarded  = p_stay_PM(1,m_low,:)
p_stay_low_unrewarded(1,6:10,:) = p_stay_PO(1,m_hi(1:5),:)
p_stay_high_unrewarded = [];
p_stay_high_unrewarded  = p_stay_PM(1,m_hi,:)
p_stay_high_unrewarded(1,6:10,:) = p_stay_PO(1,m_low(1:5),:)

p_turn_low_rewarded = p_turn_M(1,m_low(1:5),:)
p_turn_low_rewarded(1,6:10,:) = p_turn_O(1,m_hi(1:5),:)
p_stay_low_rewarded = p_stay_M(1,m_low(1:5),:)
p_stay_low_rewarded(1,6:10,:) = p_stay_O(1,m_hi(1:5),:)
p_turn_high_rewarded = p_turn_M(1,m_hi(1:5),:)
p_turn_high_rewarded(1,6:10,:) = p_turn_O(1,m_low(1:5),:)
p_stay_high_rewarded = p_stay_M(1,m_hi(1:5),:)
p_stay_high_rewarded(1,6:10,:) = p_stay_O(1,m_low(1:5),:)

