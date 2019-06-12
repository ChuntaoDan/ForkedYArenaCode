%% INITIALIZE HARDWARE
clear
clc
close all

Y_Arena_User_settings;
param.iteration = 60;
% Turning on IR back-light
%initialize LED controller
hLEDController = serial(serial_port_for_LED_Controller, 'BaudRate', 115200, 'Terminator', 'CR');
fopen(hLEDController);
hComm.hLEDController = hLEDController;

%defining default intensity value of IR light once the port is turned on
YArena_LED_control(hComm.hLEDController,'RESET');
%load default IR intensity value from user setting file
Ir_int_val = IrInt_DefaultVal;
handles.IrIntValue = Ir_int_val;
YArena_LED_control(hComm.hLEDController,'IR',Ir_int_val);
YArena_LED_control(hComm.hLEDController,'RED',RedInt_DefaultVal);
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

snapshot = zeros(1024,1280);
xy = [];
count = 0;
more_count = 0;
less_count = 0;

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
    flea3(camCounter).initializeCamera(frameRate, movieFormat, ROI, triggerMode);
    flea3(camCounter).loadConfiguration(defaultJsonFile{camCounter});
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
    'Cam', num2str(1-1),'_Corrected1_2mintest_MCH+_8_arm1test'];

if ~exist(dataPath, 'dir')
    tempPath2 = dataPath;
    mkdir(tempPath2);
end
handles.expDataSubdir{1} = tempPath2;


%% RUN EXPT
flyBowl_camera_control(handles.hComm.flea3(1),'stop');
%start recording
trialMovieName = [handles.expDataSubdir{i}, '\movie_', '.', handles.movieFormat];
flyBowl_camera_control(handles.hComm.flea3(1),'start', trialMovieName);


s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 1 0 0 0 1],valvedio1); % valve 2 open - AIR
s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 1 0 0 0 1],valvedio2); % valve 2 open - AIR
s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 1 0 0 0 1],valvedio3); % valve 2 open - AIR

pause(30);

s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 1 0 0 1],valvedio1); % valve 3 open - MCH
s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 1 0 0 1],valvedio2); % valve 3 open - MCH
s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 1 0 0 1],valvedio3); % valve 3 open - MCH

pause(2); % 2 seconds is the delay between valve clicking and odor entering the arena

YArena_LED_control(hComm.hLEDController,'PULSE',param);
YArena_LED_control(hComm.hLEDController,'RUN');

pause(58) % duration of odor presentation is 60 seconds but a pause of 2 seconds is previously already used to allow for appropriate LED delay. 60 -2  = 58


s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 1 0 0 0 1],valvedio1); % valve 2 open - AIR
s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 1 0 0 0 1],valvedio2); % valve 2 open - AIR
s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 1 0 0 0 1],valvedio3); % valve 2 open - AIR

pause(30);

s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 0 1 0 1],valvedio1); % valve 4 open - OCT
s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 0 1 0 1],valvedio2); % valve 4 open - OCT
s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 0 1 0 1],valvedio3); % valve 4 open - OCT

pause(60)

s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 1 0 0 0 1],valvedio1); % valve 2 open - AIR
s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 1 0 0 0 1],valvedio2); % valve 2 open - AIR
s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 1 0 0 0 1],valvedio3); % valve 2 open - AIR

pause(30);

s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 1 0 0 1],valvedio2); % valve 3 open - MCH
s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 0 1 0 1],valvedio1); % valve 4 open - OCT
s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 0 1 0 1],valvedio3); % valve 4 open - OCT

pause(120)

s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 0 0 0 0],valvedio1); %
s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 0 0 0 0],valvedio2); %
s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 0 0 0 0],valvedio3); %



%     pause(180);

flyBowl_camera_control(handles.hComm.flea3(i),'stop');            
flyBowl_camera_control(handles.hComm.flea3(i),'preview');

movieFileWithVer = [handles.expDataSubdir{i}, '\movie*.', handles.movieFormat];
    
D = dir(movieFileWithVer);
if ~isempty(D)
    for j = 1:length(D)
        movieFileWithVer = fullfile(handles.expDataSubdir{i},D(j).name);
        defaultMovieFile = fullfile(handles.expDataSubdir{i}, [D(j).name(1:end-40),'.',handles.movieFormat]);
        movefile(movieFileWithVer, defaultMovieFile);
    end
end

matfilename = strcat(dataPath, '\all_variables.mat')
save(matfilename)
% end    
%% CLOSING THINGS DOWN
% turning off IR and closing the serial port
olfactoryArena_LED_control(handles.hComm.hLEDController,'IR',0);
flyBowl_camera_control(handles.hComm.flea3(i),'stop'); 

fclose(hLEDController);


s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 0 0 0 0],valvedio1); %
s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 0 0 0 0],valvedio2); %
s=FlipValveUSB6525({'Vial1','Vial2','Vial3','Vial4','Vial5','Final'},[0 0 0 0 0 0],valvedio3); %


% fclose(AC1);
% 
% fclose(AC2);
% imshow(snapshot)   
% flushdata(vidobj1
% 

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
