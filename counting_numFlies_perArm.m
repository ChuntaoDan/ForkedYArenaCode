%% count the number of flies per arm per frame in Y-arena
% Reset everything
clear
clc

%% Set all parameters
data_dir = ('/groups/turner/home/rajagopalana/Documents/MATLAB/Y-Arena/Data/050119_multiple_switch_test/'); % Folder containing olfactory arena videos
script_dir = '/groups/turner/home/rajagopalana/Documents/MATLAB/Y-Arena/'; % Folder containing behavior analysis scripts
cd(data_dir)
chunk_size = 600; % Number of frames loaded into memory at a time
min_area = 50; % Minimum area of a fly (in pixels)
acquisition_rate = 150; % Acquisition rate (in Hz)
[mat_file_list] = dir('*'); % List all folders containing "test_test"
% mat_file_list = textscan(mat_file_list, '%s', 'Delimiter', '\n'); % List of all experiment files made by recursively scanning all subdirectories of data_dir
% mat_file_list = mat_file_list{1, 1};


%% Loading video and defining binary masks. and calculating distance from closest line
cd(data_dir)

acquisition_rate = 150; % Acquisition rate (in Hz)
expt = '20190502T145855_Y-Arena1_Cam0_MCHp_switchingArms_3'
cd(expt)
video = 'movie__cam_0.ufmf';
header = ufmf_read_header(video); % Read the header for the test video 
n_frames = header.nframes - rem(header.nframes, acquisition_rate);

% background calculation
for aa = 1:15
    background_images(:,:,aa) = load_frames(aa*1000,1,header,expt);
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


cd(data_dir)
%% Actual counting of flies

for folder_n = 1:length(mat_file_list)
    cd(data_dir)    
    % Change directory to file containing output from video analysis
    expt = mat_file_list(folder_n).name;
    analyzed_file = [expt, '/', 'analyzed.txt'];
    error = strfind(expt, 'visa error');
    
    if ~isempty(error) % Skip if experiment is located in an error folder
        continue
    else
        cd(expt)
    end
    
    video = dir('movie__cam_0.ufmf'); % Find file containing test video
    analysis_dir = ['/groups/turner/home/rajagopalana/Documents/MATLAB/Y-Arena/Analysis/050119_multiple_switch_test','/',expt,]; % Create a name for the analyzed video directory
    
    if (size(video, 1) == 0) || (exist(analyzed_file, 'file') ~= 0)  % Skip if folder does not contain a test file or if folder contains analyzed tag
        continue
    end
    
    disp(expt)
  
  
    header = ufmf_read_header(video(1).name); % Read the header for the test video 
    n_frames = header.nframes - rem(header.nframes, acquisition_rate); % Round the number of frames to the nearest second
    n_flies = zeros(n_frames-(acquisition_rate*300)+1, 3); % Create a matrix for the number of flies per set of quadrants per frame
    
    
    for aa = 1:15
        background_images(:,:,aa) = load_frames(aa*500,1,header,expt);
    end

    for pics = 1:15
        if pics == 1
            sum_background = (1/15)*background_images(:,:,pics);
        else    
         sum_background = sum_background + (1/15)*background_images(:,:,pics);

        end
    end  
    
    
    
    
    % Load a chunk of frames at a time for each video
    for startframe_n = (acquisition_rate*300):chunk_size:n_frames % i start from n_frames-(acquisition_rate*150) becasue i want only the last 150 secs (shooting at 150 fps)
        if n_frames - startframe_n + 1 < chunk_size
            totframes = n_frames - startframe_n + 1;
        else
            totframes = chunk_size;
        end
        
        images = load_frames(startframe_n, totframes, header, expt);
        
        for frame_n = 1:totframes
            disp('Analyzing frame: ')
            disp(startframe_n + frame_n - 1)
            
            image = images(:, :, frame_n);
            bgsub_image = sum_background - image;
%             if startframe_n == 45000 && frame_n == 1 % Change this value to match the strcutre of the expt
%                 keyboard
%                 prompt = 'peform binarization. find appropriate threshold (either 0.18 or 0.25 in most cases). Enter threshhold';
%                 threshold = input(prompt)
%             end 
            
            bw = im2bw(bgsub_image,0.25);
               
            cc = bwconncomp(bw);
            rp = regionprops(cc,'Area','Centroid');
            large = find([rp.Area]>50);
            
            % Loop through each arm
            for aa = 1:length(large)
                if binarymask(round(rp(large(aa)).Centroid(2)),round(rp(large(aa)).Centroid(1))) == 1
                    n_flies(startframe_n + frame_n -(acquisition_rate*300), 1) = n_flies(startframe_n + frame_n -(acquisition_rate*300), 1)+ ceil(rp(large(aa)).Area/400);
                elseif binarymask2(round(rp(large(aa)).Centroid(2)),round(rp(large(aa)).Centroid(1))) == 1
                    n_flies(startframe_n + frame_n -(acquisition_rate*300), 2) = n_flies(startframe_n + frame_n -(acquisition_rate*300), 2)+ ceil(rp(large(aa)).Area/400);
                elseif binarymask3(round(rp(large(aa)).Centroid(2)),round(rp(large(aa)).Centroid(1))) == 1
                    n_flies(startframe_n + frame_n -(acquisition_rate*300), 3) = n_flies(startframe_n + frame_n -(acquisition_rate*300), 3)+ ceil(rp(large(aa)).Area/400);
        
                end
            end
        end   
        
        create_folder = mkdir(analysis_dir);
        save([analysis_dir, '/', 'flycounts.mat'], 'n_flies');
        
    end
    
    file = fopen('analyzed.txt', 'w'); 
    fclose(file);
    
end