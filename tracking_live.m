function [xy,count,snapshot,ave_background,more_count, less_count,delete_vidobj_count] = tracking_live(xy,count,vidobj2,snapshot,ave_background,more_count, less_count,delete_vidobj_count) 
    
    try
    %         vidobj2.LoggingMode = 'disk&memory';
        pause(0.1)
        snapshot = getdata(vidobj2,1);
        img = ave_background-snapshot;
        %imshow(img)
        count= count+1;
        bw = im2bw(img,0.1);
        %figure;
        imshow(bw)
        cc = bwconncomp(bw);
        rp = regionprops(cc,'Area','Centroid');
        large = find([rp.Area]>30);
%         jr = find([rp(large).Area]<150);
        if length(large) == 1
            xy(:,count) = rp(large(1)).Centroid;
            more_count = 0;
            less_count = 0;
        elseif length(large) > 1
            if more_count < 10
                warning('more  than 1 oject IDed')
                more_count = more_count+1;
                xy(1:2,count) = -1;
            else
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

%                 flushdata(vidobj2)
%                 delete(vidobj2)
                more_count = 0;
                xy(1:2,count) = -1;
            end    
        else 
            if less_count < 10
                warning('less  than 1 oject IDed')
                less_count = less_count+1;
                xy(1:2,count) = -1;
            else
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

%                 flushdata(vidobj2)
%                 delete(vidobj2)
                less_count = 0; 
                xy(1:2,count) = -1;
            end
    %     x and y coordinates of the fly for each snapshot
    %     Here you can incorporate a case structure to control the Reward and
    %     Odor delivery
        end
    %     xy(:,count) = rp(large(1)).Centroid;
        flushdata(vidobj2)
    catch
        warning('TRACKING NOT WORKING!!!!')
        pause(0.1)
        delete(vidobj2);
        delete_vidobj_count =delete_vidobj_count +1
        clear('vidobj2');
        vidobj2 = videoinput('pointgrey',2);
            triggerconfig(vidobj2, 'manual');
            vidobj2.FramesPerTrigger = inf; 
            start(vidobj2);
            trigger(vidobj2) 
    end 