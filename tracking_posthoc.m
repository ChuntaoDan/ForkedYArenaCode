%% To track fly in the y-arena post-hoc.

clear
clc

%% Define parameters

data_dir = cd('/groups/turner/home/rajagopalana/Desktop'); % Folder containing olfactory arena videos
script_dir = '/groups/turner/home/rajagopalana/Desktop';
chunk_size = 600; % Number of frames loaded into memory at a time
min_area = 50; % Minimum area of a fly (in pixels)
acquisition_rate = 150; % Acquisition rate (in Hz)
[~, mat_file_list] = system('dir /S/B *Cam*.'); % List all folders containing "Cam"
mat_file_list = textscan(mat_file_list, '%s', 'Delimiter', '\n'); % List of all experiment files made by recursively scanning all subdirectories of data_dir
mat_file_list = mat_file_list{1, 1};

%% Analyze all of the behavior arena videos
for folder_n = 1:length(mat_file_list)
    % Change directory to file containing output from video analysis
    expt = mat_file_list{folder_n, 1};
    analyzed_file = [expt, '\', 'analyzed.txt'];
    error = strfind(expt, 'error');
    
    if ~isempty(error) % Skip if experiment is located in an error folder
        continue
    else
        cd(expt)
    end
    
    video = dir('movie__cam_0.ufmf'); % Find file containing test video
    analysis_dir = replace(expt, 'Data', 'Analysis'); % Create a name for the analyzed video directory
    
    if (size(video, 1) == 0) || (exist(analyzed_file, 'file') ~= 0)  % Skip if folder does not contain a test file or if folder contains analyzed tag
        continue
    end
    
    disp(expt)
    
    header = ufmf_read_header(video(1).name); % Read the header for the test video 
    n_frames = header.nframes - rem(header.nframes, acquisition_rate); % Round the number of frames to the nearest second
    xy_fly = NaN(n_frames, 2); % Create a matrix for the x and y coordinates of fly per frame
    
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
   % imshow(sum_background)
    
    % Load a chunk of frames at a time for each video
    for startframe_n = 1:chunk_size:n_frames
        if n_frames - startframe_n + 1 < chunk_size
            totframes = n_frames - startframe_n + 1;
        else
            totframes = chunk_size;
        end
        
        images = load_frames(startframe_n, totframes, header, expt);
        
        % Load an individual frame from the chunk of frames
        for frame_n = 1:totframes
            disp('Analyzing frame: ')
            disp(startframe_n + frame_n - 1)
            
            image = images(:, :, frame_n);
            %imshow(image)
            % background subtract and locate fly
            img = sum_background-image;
            %imshow(img)
            bw = im2bw(img,0.1);
            %figure;
            %imshow(bw)
            cc = bwconncomp(bw);
            rp = regionprops(cc,'Area','Centroid');
            large = find([rp.Area]>30);
            
            if length(large) == 1
                xy_fly(startframe_n + frame_n - 1, :) = rp(large(1)).Centroid;
            else
                jr = find([rp(large).Area]<150);
                if length(jr)== 1
                    xy_fly(startframe_n + frame_n - 1, :) = rp(large(jr(1))).Centroid;
                end    
            end
        end
        % Save number of fly counts to Analysis file
        create_folder = mkdir(analysis_dir);
        save([analysis_dir, '\', 'flycounts.mat'], 'xy_fly');
    end
    
    % Create an analyzed file tag
    file = fopen(analyzed_file, 'w'); 
    fclose(file);
end