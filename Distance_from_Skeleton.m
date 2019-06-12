%% Calculating distance from skeleton of arena

clear
clc

%% Location of Center of arena and center-most end points of each arm

v0 = [815,662,1];
v1 = [815,142,1];
v2 = [365,920,1];
v3 = [1260,920,1];


%% Loading video and defining binary masks. and calculating distance from closest line
cd('/groups/turner/home/rajagopalana/Documents/MATLAB/Y-Arena/Data/0hr/20190211T165432_Y-Arena1_Cam00hr_1')

acquisition_rate = 150; % Acquisition rate (in Hz)

video = 'movie__cam_0.ufmf';
header = ufmf_read_header(video); % Read the header for the test video 
n_frames = header.nframes - rem(header.nframes, acquisition_rate);
expt = '20190211T165432_Y-Arena1_Cam00hr_1'
% background calculation
for aa = 1:15
    background_images(:,:,aa) = load_frames(aa*10000,1,header,expt);
end

for pics = 1:15
    if pics == 1
        sum_background = (1/15)*background_images(:,:,pics);
    else    
     sum_background = sum_background + (1/15)*background_images(:,:,pics);

    end
end  

imshow(sum_background)
 % binary mask calculation

hfH = imfreehand()
binarymask = hfH.createMask();

hfH2 = imfreehand()
binarymask2 = hfH2.createMask();

hfH3 = imfreehand()
binarymask3 = hfH3.createMask();


cd('/groups/turner/home/rajagopalana/Documents/MATLAB/Y-Arena/Analysis')
folders  = dir;
distances = [];
count = 0
for j = 4
    fldr = strcat(folders(j).folder,'/',folders(j).name)
    cd(fldr)
    subfolders = dir;
    for k = 3:length(subfolders)
        count = count + 1;
        subfldr = strcat(subfolders(k).folder,'/',subfolders(k).name)
        cd(subfldr)
        xy_fly = load('flycounts.mat')
        xy_fly = xy_fly.xy_fly;
        % background calculation
        
        % Caluculating distance from closest line
        distance = [];

        for i = 1 :length(xy_fly)
            if isnan(xy_fly(i,1))==0 && isnan(xy_fly(i,2))==0
                pt(1) = xy_fly(i,1);
                pt(2) = xy_fly(i,2);
                pt(3) = 1;

                b = pt-v0;

                pt2dx = round(pt(2));
                pt2dy = round(pt(1));

                d1 = 0;
                d2 = 0;
                d3 = 0;

                if binarymask(pt2dx,pt2dy) == 1
                    a = v1-v0;
                    d1 = norm(cross(a,b))/norm(a);
                end    
                if binarymask2(pt2dx,pt2dy) == 1
                    a = v2-v0;
                    d2 = norm(cross(a,b))/norm(a);
                end
                if binarymask3(pt2dx,pt2dy) == 1
                    a = v3-v0;
                    d3 = norm(cross(a,b))/norm(a);
                end

                if d1~= 0 || d2~=0 || d3~=0
                    ds = [d1,d2,d3];
                    ds = ds(ds~=0);
                    d_min = min(ds);
                    distance(length(distance)+1) = d_min;
                end
            end    
        end 
        distances(1:length(distance),count) = distance;
    end    
end

%% Plot Histogram

% Create figure
figure1 = figure;

% Create axes
axes1 = axes;
hold(axes1,'on');

% Create histogram
histogram(distances(1:260000,:),'Normalization','probability','BinLimits',[0 60],...
    'BinWidth',5);

% Create ylabel
ylabel('Probability of finding fly at a given distance','FontWeight','bold',...
    'FontSize',16);

% Create xlabel
xlabel('Distance from skeleton','FontWeight','bold','FontSize',16);

% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[0 0.26]);
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',16,'YTick',...
    [0 0.02 0.04 0.06 0.08 0.1 0.12 0.14 0.16 0.18 0.2 0.22 0.24 0.26]);
% Create line
annotation(figure1,'line',[0.131238447319778 0.902033271719039],...
    [0.366311072056239 0.366432337434095],'LineWidth',4,'LineStyle','--');

% Create rectangle
annotation(figure1,'rectangle',...
    [0.575861367837338 0.109841827768014 0.32802033271719 0.813708260105448],...
    'Color','none',...
    'FaceColor',[1 0 0],...
    'FaceAlpha',0.2);

       