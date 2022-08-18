% Create figure
figure1 = figure();

% Create axes
axes1 = axes('Parent',figure1,...
    'Position',[0.187739463601533 0.182108626198083 0.717260536398468 0.742891373801916]);
hold(axes1,'on');


% Create ylabel
ylabel('# of Correct Choices');

% Create xlabel
xlabel('# of Incorrect Choices');

% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[0 90]);
% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[0 90]);
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',16,'XTick',[0 45 90],...
    'YTick',[0 45 90]);

% Create textbox
annotation(figure1,'textbox',...
    [0.530012771392085 0.324131760931667 0.242656442701893 0.0412517772884152],...
    'Color',[1 0 0],...
    'String',{'REWARD AVAILABLE'},...
    'FontSize',12,...
    'FitBoxToText','on',...
    'EdgeColor','none');

% Create textbox
annotation(figure1,'textbox',...
    [0.533844189016607 0.258735200037869 0.212005102619206 0.0575079859826513],...
    'String',{'NO REWARD'},...
    'FontSize',12,...
    'FitBoxToText','off',...
    'EdgeColor','none');

filename = 'learningCurve_v3.gif';

CO = load('choice_order_naive.mat');
CO = CO.choice_order;
load('choice_order_1.mat');
CO(41:length(choice_order)+length(CO)) = choice_order;
x = []
y = []

for n = 1:length(CO)
    % Draw plot for y = x.^n
    x(n) = length(find(CO(1:n) == 1));
    y(n) = length(find(CO(1:n) == 2));
    if n < 41
        plot(x,y,'k','LineWidth',4) 
        hold on
    else
        plot(x(40:n),y(40:n),'r','LineWidth',4) 
    end    
    xlim([0,90])
    ylim([0,90])


    drawnow 
    % Capture the plot as an image 
    frame = getframe(figure1); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256); 
    % Write to the GIF File 
    if n == 1 
      imwrite(imind,cm,filename,'gif','DelayTime',0,'Loopcount',inf); 
    else 
      imwrite(imind,cm,filename,'gif','DelayTime',0.1,'WriteMode','append'); 
    end 
end