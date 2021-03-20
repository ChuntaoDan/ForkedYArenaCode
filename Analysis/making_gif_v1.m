
% Create figure
figure1 = figure;

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
set(axes1,'FontSize',16,'XTick',[0 45 90],'YTick',[0 45 90]);
% Create rectangle
% Set the remaining axes properties

% Create rectangle
annotation(figure1,'rectangle',...
    [0.19129374201788 0.335463258785942 0.711643678160919 0.589456869009581],...
    'Color','none',...
    'FaceColor',[1 0 0],...
    'FaceAlpha',0.1);

% Create textbox
annotation(figure1,'textbox',...
    [0.561941251596426 0.818483755914941 0.319284792908613 0.0575079859826512],...
    'Color',[1 0 0],...
    'String',{'REWARD AVAILABLE'},...
    'FontSize',12,...
    'FitBoxToText','on',...
    'EdgeColor','none');

% Create rectangle
annotation(figure1,'rectangle',...
    [0.361430395913156 0.185303514376997 0.542784163473818 0.150159744408946],...
    'Color','none',...
    'FaceColor',[1 0 0],...
    'FaceAlpha',0.1);

% Create rectangle
annotation(figure1,'rectangle',...
    [0.188739463601533 0.18370607028754 0.175245210727969 0.148562300319489],...
    'Color','none',...
    'FaceColor',[1 1 1],...
    'FaceAlpha',0.1);

% Create textbox
annotation(figure1,'textbox',...
    [0.277139208173693 0.179511183346421 0.212005102619205 0.0575079859826512],...
    'String',{'NO REWARD'},...
    'FontSize',12,...
    'EdgeColor','none');

filename = 'learningCurve_v2.gif';

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
    plot(x,y,'b','LineWidth',4) 
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