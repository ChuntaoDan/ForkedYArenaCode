%% Position as a function of time (in color)

% Plot location of fly in arena over time (1 in every 100 frames shooting
% at 150fps). Early time points in blue slowly progressing red.

for i = 1:100:269850
    if isnan(xy_fly(i,1))==0 && isnan(xy_fly(i,2))== 0
        scatter(xy_fly(i,1), xy_fly(i,2),140,'filled','MarkerFaceColor',[i/269850,0,1-i/269850])
        hold on
    end
end    