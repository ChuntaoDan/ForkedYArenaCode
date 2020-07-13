%% INITIALIZE HARDWARE
clear
clc
close all

Y_Arena_User_settings;

% Turning on IR back-light
%initialize LED controller
hLEDController = serial(serial_port_for_LED_Controller, 'BaudRate', 115200, 'Terminator', 'CR');
fopen(hLEDController);
hComm.hLEDController = hLEDController;

%defining default intensity value of IR light once the port is turned on
olfactoryArena_LED_control(hComm.hLEDController,'RESET');
%load default IR intensity value from user setting file
Ir_int_val = IrInt_DefaultVal;
Red_int_val = RedInt_DefaultVal;
handles.IrIntValue = Ir_int_val;
handles.IrIntValue = Red_int_val;
olfactoryArena_LED_control(hComm.hLEDController,'IR',Ir_int_val);
olfactoryArena_LED_control(hComm.hLEDController,'RED',Red_int_val);
% connect to servos
servos = ModularClient('COM4');
servos.open;

%pause(5)

%Initializing MFCs (with Yichun's MFC setup)
% 
% AC1 = connectAlicat_YS(AC1_Port);
% AC2 = connectAlicat_YS(AC2_Port);
% initialiseFlows_YS(AC1, AC_firstDilution_default, AC_secondDilution_default,'_AC1');
% initialiseFlows_YS(AC2, AC_firstDilution_default, AC_secondDilution_default,'_AC2');
% hComm.AC1=AC1;
% hComm.AC2=AC2;

% initialize valve controls (with Yichun's valve setup)
% valvedio1 = connectToUSB6501_YS(valvedio1_ID);
% valvedio2 = connectToUSB6501_YS(valvedio2_ID);
% 
% hComm.valvedio1=valvedio1;
% hComm.valvedio2=valvedio2;


handles.rig = rigName;
handles.expProtocolDir = expProtocolDir;
handles.expDataDir = expDataDir;
handles.pulseWidth = 0;
handles.pulsePeriod = 0;
handles.expRun = 0;
handles.LEDpattern = logical([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]);
handles.intensityMode = 'LINEAR';
handles.Board1Patt = '0000';
handles.Board2Patt = '0000';
handles.Board3Patt = '0000';
handles.Board4Patt = '0000';

handles.jsonFile = defaultJsonFile;
handles.movieFormat = movieFormat;






% Defining variables

% snapshot = zeros(1024,1280);
% xy = [];
% air_arm = [];
% right_left = [];
% count = 0;
% more_count = 0;
% less_count = 0;

%imaqmem(20000000000);

i = 1;

%connect to cameras
try
    
    %Run the camera server program bias
    dos([biasFile, ' &']);
    %initialize the camera
    camCounter = 1
    flea3(camCounter) = BiasControlV49(camera(camCounter).ip,camera(camCounter).port);
    flea3(camCounter).connect();
    flea3(camCounter).disableLogging();
    flea3(camCounter).loadConfiguration(defaultJsonFile{camCounter});
    flea3(camCounter).initializeCamera(frameRate, movieFormat, ROI, triggerMode);
%     
    hComm.flea3(camCounter) = flea3(camCounter);

    
catch ME
    
    disp(ME.message);
    if camCounter == 1
       i = 1:length(camera)
       flea3(i) = 0;
       hComm.flea3(i) = flea3(i);
    elseif camCounter == 2
        flea3(2) = 0;
        hComm.flea3(2) = flea3(2);
    end
    
end


handles.hComm = hComm;


%get a preview
i = 1
if ~(hComm.flea3(i) == 0)
    flyBowl_camera_control(hComm.flea3(i),'preview');
end

%% DEFINE TRACKING CAMERA AND BINARY MASK CALCULATION

vidobj2 = videoinput('pointgrey',2);
triggerconfig(vidobj2, 'manual');
vidobj2.FramesPerTrigger = inf; 
start(vidobj2);
trigger(vidobj2) 
%         vidobj2.LoggingMode = 'disk&memory';
pause(0.1)

Track_cam_image = getdata(vidobj2,1);

% Define regions or load previously defined regions that control which
% odors to deliver
try
    load('C:\Users\rajagopalana\Documents\MATLAB\Y-Arena_Code\binary_masks.mat')
catch
    imshow(Track_cam_image)
    
    hfH = imfreehand()
    binarymask1 = hfH.createMask();

    hfH2 = imfreehand()
    binarymask2 = hfH2.createMask();

    hfH3 = imfreehand()
    binarymask3 = hfH3.createMask();

    hfH4 = imfreehand()
    binarymask4 = hfH4.createMask();

    hfH5 = imfreehand()
    binarymask5 = hfH5.createMask();

    hfH6 = imfreehand()
    binarymask6 = hfH6.createMask();

    hfH7 = imfreehand()
    binarymask7 = hfH7.createMask();
    
    hfH8 = imfreehand()
    binarymask8 = hfH8.createMask();

    hfH9 = imfreehand()
    binarymask9 = hfH9.createMask();

    save('C:\Users\rajagopalana\Documents\MATLAB\Y-Arena_Code\binary_masks.mat','binarymask1','binarymask2','binarymask3','binarymask4','binarymask5','binarymask6','binarymask7','binarymask8','binarymask9'); 
end
%% TAKING BACKGROUND SNAPSHOT.

for pics = 1:10
    background(:,:,pics) = getdata(vidobj2,1);
    % imshow(background(:,:,pics))
    if pics == 1
        sum_background = (1/10)*background(:,:,pics);
    else    
        sum_background = sum_background + (1/10)*background(:,:,pics);

    end
end    
ave_background = round(sum_background);
figure
imshow(ave_background)

flushdata(vidobj2)
delete(vidobj2)


%% PATH FOR EACH NEW EXPT
oldPath = pwd;
cd(handles.expDataDir);
currentDate = datestr(now, 29);
tempPath1 = [handles.expDataDir, '\', currentDate];
if ~exist(tempPath1, 'dir')
    mkdir(tempPath1)
end
cd(tempPath1);

handles.expStartTime = datestr(now,30);

dataPath = [tempPath1, '\', handles.expStartTime, '_',handles.rig, '_',...
    'Cam', num2str(1-1),'Test'];

if ~exist(dataPath, 'dir')
    tempPath2 = dataPath;
    mkdir(tempPath2);
end
handles.expDataSubdir{1} = tempPath2;


%% RUN EXPT
% flyBowl_camera_control(handles.hComm.flea3(1),'stop');
% %start recording
% trialMovieName = [handles.expDataSubdir{i}, '\movie_', '.', handles.movieFormat];
% flyBowl_camera_control(handles.hComm.flea3(1),'start', trialMovieName);
% % 
% time = 0;
% timestamps = [];
% statestamps = [];
% % 
% vidobj2 = videoinput('pointgrey',2);
% triggerconfig(vidobj2, 'manual');
% vidobj2.FramesPerTrigger = inf; 
% start(vidobj2);
% trigger(vidobj2) 

% FoodPortStatus = 0; % 0 implies all food ports are closed. 1 implies atleast one is open
% PreviousZone = 0;   % previous zone fly was located in
% PresentZone = 0;    % present zone fly is located in
% od_state = 0;        % defines odorized state; 0 - first trial or just after feeding has taken place actual odorized state could be 1, 2 or 3
%                     % 1 - arm 0 has clean air
%                     % 2 - arm 1 has clean air
%                     % 3 - arm 2 has clean air
% ch_state = 1;       % 1 - Right is OCT, Left is MCH
%                     % 2 - Right is MCH, Left is OCT
% reward = [];
% reset = 0;
n_trials = 1
clear('vidobj2')
% baiting = [0;0];
x = input('Enter intial reward probability for OCT - Range 0 to 1')
time = 0;


    while n_trials < 361 && time<21600
        if exist('vidobj2') == 0
            vidobj2 = videoinput('pointgrey',2);
            triggerconfig(vidobj2, 'manual');
            vidobj2.FramesPerTrigger = inf; 
            start(vidobj2);
            trigger(vidobj2) 
        end
        if time>21600
            n_trials = 400;
        end    
        tic
        if n_trials == 41
            [n_trials,time_n,vidobj2] = run_section_expt(n_trials,dataPath,x,ave_background,binarymask1,binarymask2,binarymask3,binarymask4,binarymask5,binarymask6,binarymask7,binarymask8,binarymask9,valvedio1,valvedio2,valvedio3,hComm,vidobj2)
            time = time+time_n;
        elseif n_trials == 121
            [n_trials,time_n,vidobj2] = run_section_expt(n_trials,dataPath,1-x,ave_background,binarymask1,binarymask2,binarymask3,binarymask4,binarymask5,binarymask6,binarymask7,binarymask8,binarymask9,valvedio1,valvedio2,valvedio3,hComm,vidobj2)
            time = time+time_n;
        elseif n_trials == 201
            [n_trials,time_n,vidobj2] = run_section_expt(n_trials,dataPath,x-0.2,ave_background,binarymask1,binarymask2,binarymask3,binarymask4,binarymask5,binarymask6,binarymask7,binarymask8,binarymask9,valvedio1,valvedio2,valvedio3,hComm,vidobj2)
            time = time+time_n;
        elseif n_trials == 281
            [n_trials,time_n,vidobj2] = run_section_expt(n_trials,dataPath,1.2-x,ave_background,binarymask1,binarymask2,binarymask3,binarymask4,binarymask5,binarymask6,binarymask7,binarymask8,binarymask9,valvedio1,valvedio2,valvedio3,hComm,vidobj2)
            time = time+time_n;
        elseif n_trials < 41   
            [n_trials,time_n,vidobj2] = run_naive_section_expt(n_trials,dataPath,ave_background,binarymask1,binarymask2,binarymask3,binarymask4,binarymask5,binarymask6,binarymask7,binarymask8,binarymask9,valvedio1,valvedio2,valvedio3,hComm,vidobj2)
            time = time+time_n;
        end

        s = toc;
        time = time + s;
    end



delete(vidobj2)

% Shutting down MFCs
s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 0 0 0 0],valvedio1); %
s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 0 0 0 0],valvedio2); %
s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 0 0 0 0],valvedio3); %

% % Shutting down and saving video
% flyBowl_camera_control(handles.hComm.flea3(i),'stop');            
% flyBowl_camera_control(handles.hComm.flea3(i),'preview');
% 
% movieFileWithVer = [handles.expDataSubdir{i}, '\movie*.', handles.movieFormat];
%     
% D = dir(movieFileWithVer);
% if ~isempty(D)
%     for j = 1:length(D)
%         movieFileWithVer = fullfile(handles.expDataSubdir{i},D(j).name);
%         defaultMovieFile = fullfile(handles.expDataSubdir{i}, [D(j).name(1:end-40),'.',handles.movieFormat]);
%         movefile(movieFileWithVer, defaultMovieFile);
%     end
% end

% saving variables
matfilename = strcat(dataPath, '\other_variables.mat')
save(matfilename)

% turning off IR and closing the serial port
olfactoryArena_LED_control(handles.hComm.hLEDController,'IR',0);
% flyBowl_camera_control(handles.hComm.flea3(i),'stop'); 

fclose(hLEDController);


%% PLOT TRACKING
% plot the flies position
ct = 0;
xy_n = [];
for i = 1:length(xy)
if xy(1,i) ~= 0
ct = ct+1;
xy_n(1,ct) = xy(1,i);
xy_n(2,ct) = xy(2,i);
end
end
plot(xy_n(1,:),xy_n(2,:))
