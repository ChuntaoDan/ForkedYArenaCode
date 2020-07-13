%edited by Yichun Shuai -- Mar 11,2016 

rigName = 'Y-Arena1';

%setings of ports
%port for LED control
serial_port_for_LED_Controller = 'COM3';

%port for mass flow controller
% 01.31.19 - In the new olfactometer the MFCs are not plugged into the
% computer
%AC1_Port='COM6';%serial port for alicat BB9-232 #1 
%AC2_Port='COM5';%seria port for alicat BB9-232 #2

%port for solenoid valve control #1
USB6525_ID = 1;
valvedio1 = connectToUSB6525(USB6525_ID);


%port for solenoid valve control #2
USB6525_ID = 2;
valvedio2 = connectToUSB6525(USB6525_ID);


%port for solenoid valve control #3
USB6525_ID = 3;
valvedio3 = connectToUSB6525(USB6525_ID);


%port for PID recording
% DanalogInput = 'Dev4';  %National instrument USB 6009 for record
%{
serial_port_for_precon_sensor = 'COM5';
PortNum_odorC = 'COM1'; %serial port for odor controller
DanalogInput = 'Dev1';  %USB 6009
serial_port_for_MFC1 = 'COM6';
serial_port_for_MFC2 = 'COM7';
serial_port_for_MFC3 = 'COM8';
serial_port_for_MFC4 = 'COM9';
%}

%settings of environment
%initial parameters of mass flow controllers
% AC_firstDilution_default=0.5;% odor (B) in L/min [carrier1 (A) flow = 1 - odor (B) flow ]
% AC_secondDilution_default=3500;%carrier2 (D) in ml/min
% {
%Temp and Humidity update period (in secs)
THUpdateP = 1;
%}

%parameters for initialize camera
%settings of the camera
camera(1).ip = '127.0.0.1';
camera(1).port = 5010;
camera(2).ip = '127.0.0.1';
camera(2).port = 5020;

%frame rate
frameRate = 30;
%movie format
movieFormat = 'ufmf';
%region of interest
ROI = [0 0 1280 1024];
%trigger mode
triggerMode = 'internal';

%settings for the LED controller
IrInt_DefaultVal = 30;
RedInt_DefaultVal = 30;


% LED pulse parameters for a 60 second LED stimulation with 500ms ON, 500ms
% OFF periods
param.pulse_width = 500;
param.pulse_period = 1000;
param.number_of_pulses = 1;
param.pulse_train_interval = 0;
param.LED_delay = 0;
param.iteration = 120;

%Directory settings
expDataDir = 'E:\Adithya';
expProtocolDir = 'C:\Users\rajagopalana\Documents\MATLAB\Protocols';
% 
% %file settings
% defaultMetaXmlFile = 'C:\Arena\Olfactory\GUI_Version\olfactoryArenaMetaTree.xml';
% defaultExpNotesFile = 'C:\Arena\Olfactory\GUI_Version\olfactoryArenaExpNotes.xml';
% defaultProtocol = 'C:\Arena\Olfactory\Protocols\1xTrain-MCH+.xlsx';

%defaultJsonFile
biasFile = 'C:\Users\rajagopalana\Documents\MATLAB\GUI_Version\bias_gui.bat';
defaultJsonFile{1} = 'C:\Users\rajagopalana\Documents\MATLAB\GUI_Version\bias_config1.json';
defaultJsonFile{2} = 'C:\Users\rajagopalana\Documents\MATLAB\GUI_Version\bias_config2.json';
