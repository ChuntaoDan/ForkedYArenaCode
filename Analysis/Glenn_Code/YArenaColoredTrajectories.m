% IMPROVEMENTS
% I could use the acquired timestamps to plot points according to the real times
% CURRENTLY THERE ARE VALUES MISSING AROUND 0 DISTANCE - WHAT IS THE REASON FOR THAT?

% Assign frames an OdorZone value according to which arm is air (AirArmMat) and which arm the fly is in (CurrentArmMat)
% SHOULD I FIRST TAKE OUT ALL THE ZEROS FROM AirArmMat?
for n = 1:length(CurrentArmMat)
    % If the fly is in the RIGHT arm
    if         (AirArmMat(n) == 1 && CurrentArmMat(n) == 3) ...
            || (AirArmMat(n) == 2 && CurrentArmMat(n) == 1) ...
            || (AirArmMat(n) == 3 && CurrentArmMat(n) == 2)
        % Break out by which odor is right/left
        switch ArmRandomizer
            case 0 % When ArmRandomizer=0 RIGHT = OCT & LEFT = MCH
                OdorZone(n) = 0 ; % Fly turned RIGHT & chose OCT
            case 1 % When ArmRandomizer=1 RIGHT = MCH & LEFT = OCT
                OdorZone(n) = 1 ; % Fly turned RIGHT & chose MCH
        end
        % If the fly is in the LEFT arm
    elseif     (AirArm == 1 && CurrentArm == 2) ...
            || (AirArm == 2 && CurrentArm == 3) ...
            || (AirArm == 3 && CurrentArm == 1)
        % Break out by which odor is right/left
        switch ArmRandomizer
            case 0 % When ArmRandomizer=0 RIGHT = OCT & LEFT = MCH
                OdorZone(n) = 1 ; % Fly turned LEFT & chose MCH
            case 1 % When ArmRandomizer=1 RIGHT = MCH & LEFT = OCT
                OdorZone(n) = 0 ; % Fly turned LEFT & chose OCT
        end
    elseif AirArmMat(n) == CurrentArmMat(n)
        OdorZone(n) = 3 ; % Fly is in AIR
    end
end
% OdorZone now takes on different values for each frame based on which odor the fly is in
% 0 = OCT
% 1 = MCH
% 3 = AIR

%% COMPUTE DISTANCES
% Switch which arm vector you calculate the dot product with depending on
% which arm the fly is in 

% REAL NUMBERS FOR CARTESIAN COORDINATES
% Center   = [565, 644] ;
% Vertex_0 = [559, 177] ;
% Vertex_1 = [970, 874] ;
% Vertex_2 = [165, 887] ;

Center   = [565, 644] ;
Vertex_0 = [559, 177] ;
Vertex_1 = [970, 874] ;
Vertex_2 = [165, 887] ;
Arm0Vec = Vertex_0 - Center ;
Arm1Vec = Vertex_1 - Center ;
Arm2Vec = Vertex_2 - Center ;

% Extract all Fly Centroids
Cs = extractfield(FlySpotsMat,'Centroid') ;
% Remove all NaNs resulting from frames with tracking problems
Cs = Cs(~isnan(Cs)) ; 
% Reshape to [xloc yloc]
Cs = reshape(Cs,2,[]) ; 
Centroids = [Cs(1,:)' Cs(2,:)'] ; 
% Convert to vector of FlyLocation to ArenaCenter
FlyVec = Centroids - Center ; 

% Display fly trajectories within the arena
figure
% image(BackgroundImage)
% hold on
plot(FlyVec(:,1),FlyVec(:,2))

% Calculate distance down each arm as normalized dot product
DistanceDownArm = zeros(1,length(FlyVec)) ;
for n = 1:length(FlyVec)
    switch CurrentArmMat(n) % NB: CurrentArm values are 1/2/3 not 0/1/2
        case 1
            DistanceDownArm(n) = dot(FlyVec(n,:),Arm0Vec)/dot(Arm0Vec,Arm0Vec) ;
        case 2
            DistanceDownArm(n) = dot(FlyVec(n,:),Arm1Vec)/dot(Arm1Vec,Arm1Vec) ;
        case 3
            DistanceDownArm(n) = dot(FlyVec(n,:),Arm2Vec)/dot(Arm2Vec,Arm2Vec) ;
    end
end
% NOW I HAVE FRAME-BY-FRAME VECTORS OF BOTH OdorZone AND DistanceDownArm

% Set distances down AirArm to be negative
AirFrames = find(OdorZone==3) ; 
DistanceDownArm(AirFrames) = -1*DistanceDownArm(AirFrames) ; 

% To plot different colored lines for each odor I have to make each odor
% distance a separate line in the plot
Distances = NaN(length(FlyVec),3) ; 
Frames_OCT = find(OdorZone==0) ; 
Frames_MCH = find(OdorZone==1) ; 
Frames_AIR = find(OdorZone==3) ; 

Distances(Frames_OCT,1) = DistanceDownArm(Frames_OCT) ; 
Distances(Frames_MCH,2) = DistanceDownArm(Frames_MCH) ; 
Distances(Frames_AIR,3) = DistanceDownArm(Frames_AIR) ; 

% Construct a time vector - THIS COULD/SHOULD BE REPLACED WITH REAL TIMESTAMPS
time = [1:length(FlyVec)]; 

figure
plot(time, Distances(:,1),'r') ; hold on ;
plot(time, Distances(:,2),'b') ; hold on ;
plot(time, Distances(:,3),'k') ; hold on ;
