function valvedio = connectToUSB6525(USB6525_ID)

% Purpose
% Initiate a connection to the USB-6525 box.
% Configure all DIOs as output
% since we won't be recording anything from the tunnels using DIO.
%
% Inputs
% USB6525_ID - 1 or 2, corresponding to the 1st or 2nd USB6525 (the 1st USB6525 controls the final valve that switch odors between quadrants)
%
% Outputs
% NI - handle to the created object. Briefly:
%       NI.Line(1) is Port0, Line0
%       NI.Line(8) is Port0, Line7
%       ...
%       NI.Line(24) is Port2, Line7
%
%
% Rob Cambell - March 2010
% Glenn Turner - January 2019
% Updated to USB-6525 for Yoshi's Generation 2 Olfactometer

if nargin<1, USB6525_ID=1; end      % use the 1st NI USB6525 by default
fprintf('connecting to USB6525 #%g...\n',USB6525_ID)

%Look-up table for which vial/valve is connected to which switch
%The first column will be defined as the LineName of each line later
vial_switch={...
    'Vial1',1;...       % This is normally open empty vial
    'Vial2',2;...
    'Vial3',3;...
    'Vial4',4;...
    'Vial5',5;...
    'Final',6} ;        % This is Igor's final valve 

    
% %Look-up table for which vial/valve is connected to which switch
% %The first column will be defined as the LineName of each line later
% vial_switch={...
%     'Vial1',1;...    % This is normally open empty vial
%     'Vial2',2;...
%     'Vial3',3;...
%     'Vial4',4;...
%     'Vial5',5;...
%     'Shuttle',6} ;  % This is final valve (shuttle valve)
% %     'Block',15;...%This is the block valve for calibration
% %     'QuadrantShuttle',16};...%This is the final shuttle valve that switch odors between quadrants of the arena
    
%Look-up table for which switch is connected to which port/line of USB6525
switch_line={...
    1,'0.0';...
    2,'0.2';...
    3,'0.4';...
    4,'0.6';...
    5,'0.8';...
    6,'0.10'};
%     7,'0.6';...
%     8,'0.7';...
%     9,'1.0';...
%     10,'1.1';...
%     11,'1.2';...
%     12,'1.3';...
%     13,'1.4';...
%     14,'1.5';...
%     15,'1.6';...
%     16,'1.7'};% not used

device = daq.getDevices;

% NI WILL BECOME YOUR IO OBJECT
deviceID={};
     
for i=1:length(device)
    if strmatch (device(i).Description,'National Instruments USB-6525')
        if isempty(deviceID)
            deviceID{1}=device(i).ID;
        else
            deviceID{end+1}=device(i).ID;
        end
    end
end

if isempty(deviceID)
    
    error('Cannot connect to USB-6525');
    
else
    
    try
        valvedio = daq.createSession('ni');
%         SET ALL CHANNELS TO OUTPUT ONLY SINCE IT TAKES ABOUT 2.5sec TO SET DIRECTION TO INPUT OR OUTPUT
        addDigitalChannel(valvedio,deviceID{USB6525_ID},'Port0/Line0:7','OutputOnly');
%         addDigitalChannel(valvedio,deviceID{USB6525_ID},'Port1/Line0:7','OutputOnly');
%         addDigitalChannel(valvedio,deviceID{USB6525_ID},'Port2/Line0:7','OutputOnly');
        
        % addDigitalChannel(NI,deviceID,'Port0/Line0:7','Bidirectional')
        % addDigitalChannel(NI,deviceID,'Port1/Line0:7','Bidirectional')
        % addDigitalChannel(NI,deviceID,'Port2/Line0:7','Bidirectional')
        % set(NI.Channels,'Direction','output')
        
%         SET ALL LINES HIGH SO SWITCHES ARE OFF - CONFIRM THIS IS CORRECT
        outputSingleScan(valvedio,zeros(1,length(valvedio.Channels))*1) ;
        
%         NAME THE LINES
        portname = {'0.0','0.2','0.4','0.6','0.8','0.10'} ;
%         portname={'0.0','0.1','0.2','0.3','0.4','0.5','0.6','0.7',...
%             '1.0','1.1','1.2','1.3','1.4','1.5','1.6','1.7',...
%             '2.0','2.1','2.2','2.3','2.4','2.5','2.6','2.7'};
        for i = 1:size(vial_switch,1)
            thisname = vial_switch{i,1};
            thisswitch = vial_switch{i,2};
            thisport = switch_line{cell2mat(switch_line(:,1))==thisswitch,2};
            thisline = find(strcmp(thisport,portname));
            if thisline
                set(valvedio.Channels(thisline),'Name',thisname);
            end
        end
        
    catch
        warning('An object for the chosen NI device has already been created.');
    end
end