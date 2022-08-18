function [x_y_time_color] = plot_position_choices_3_odors(region_at_time,xy,timestamps,air_arm,right_left,cps)
    x_y_time_color = struct('xy',[],'time',[],'distance_up_arm',[],'color',[]);
    choicetime = [];

    color_vec = cbrewer('qual','Dark2',10,'cubic');
    Air_Color = 0*color_vec(6,:);
    O_A_Color = color_vec(1,:);
    O_P_Color = 0.6*color_vec(1,:);
    O_AirWall_Color = 0.5*color_vec(1,:);
    P_A_Color = color_vec(3,:);
    P_O_Color = 0.6*color_vec(3,:);
    P_AirWall_Color = 0.5*color_vec(3,:);
    M_A_Color = color_vec(7,:);
    M_P_Color = 0.7*color_vec(7,:);
    M_AirWall_Color = 0.5*color_vec(7,:);
    P_M_Color = 0.6*color_vec(3,:);

        
    
    pastregion147 = 0;
    pastregion258 = 0;
    pastregion369 = 0;
    
    count = 0;
    % marker_colors = [1,0,0;0,1,0];
    % col_pairs = [1,2];

    ct_right_left = 0;
    choice_count = 2;
    for i = 1:length(xy(1,:))
        if xy(1,i) == 0 && xy(2,i) == 0
            continue
%         elseif xy(1,i) == -1 && xy(2,i) == -1 && i ~= 1
%             count = count + 1;
%             x_y_time_color.xy(count,:) = x_y_time_color.xy(count-1,:);
%             x_y_time_color.time(count) = sum(timestamps(1,1:i));
%             x_y_time_color.distance_up_arm(count) = x_y_time_color.distance_up_arm(count-1);
%             x_y_time_color.color(count,:) = x_y_time_color.color(count-1,:);
%             continue
        elseif xy(1,i) == -1 && xy(2,i) == -1 %&& i == 1 
            continue

        end
        count = count+1;
        ct_right_left = ct_right_left + 1;
        x_y_time_color.xy(count,1) = xy(1,i);
        x_y_time_color.xy(count,2) = xy(2,i);
        x_y_time_color.time(count) = sum(timestamps(1,1:i));
        
        %DISTANCE TRAVELLED UP ARM RELATIVE TO A SKELETON IN THE CENTER OF
        %THE ARM.
        
        p0 = [554,643];
        v1 = [544,172;554,643];
        v2 = [964,878;554,643];
        v3 = [151,886;554,643];
        
        w13 = [496,234;496,612];
        w12 = [605,234;605,612];
        w21 = [936,800;605,612];
        w23 = [886,892;553,712];
        w32 = [232,899;553,712];
        w31 = [178,809;496,612];
        
        if region_at_time(i) == 1||region_at_time(i) == 4||region_at_time(i) == 7
            pt_on_line = proj_pt(v1,[xy(1,i),xy(2,i)]);
            distance_traveled = sqrt((pt_on_line(1)-p0(1))^2+(pt_on_line(2)-p0(2))^2);
            x_y_time_color.distance_up_arm(count) = distance_traveled;
            pt_on_wall13 = proj_pt(w13,[xy(1,i),xy(2,i)]);
            distance_wall13 = sqrt((pt_on_wall13(1) - xy(1,i))^2 + (pt_on_wall13(2) - xy(2,i))^2);
            pt_on_wall12 = proj_pt(w12,[xy(1,i),xy(2,i)]);
            distance_wall12 = sqrt((pt_on_wall12(1) - xy(1,i))^2 + (pt_on_wall12(2) - xy(2,i))^2);
            if distance_wall12 > distance_wall13
                closest_wall = 13;
            else
                closest_wall = 12;
            end    
        elseif region_at_time(i) == 2||region_at_time(i) == 5||region_at_time(i) == 8
            pt_on_line = proj_pt(v2,[xy(1,i),xy(2,i)]);
            distance_traveled = sqrt((pt_on_line(1)-p0(1))^2+(pt_on_line(2)-p0(2))^2);
            x_y_time_color.distance_up_arm(count) = distance_traveled;     
            pt_on_wall23 = proj_pt(w23,[xy(1,i),xy(2,i)]);
            distance_wall23 = sqrt((pt_on_wall23(1) - xy(1,i))^2 + (pt_on_wall23(2) - xy(2,i))^2);
            pt_on_wall21 = proj_pt(w21,[xy(1,i),xy(2,i)]);
            distance_wall21 = sqrt((pt_on_wall21(1) - xy(1,i))^2 + (pt_on_wall21(2) - xy(2,i))^2);
            if distance_wall21 > distance_wall23
                closest_wall = 23;
            else
                closest_wall = 21;
            end 
        elseif region_at_time(i) == 3||region_at_time(i) == 6||region_at_time(i) == 9
            pt_on_line = proj_pt(v3,[xy(1,i),xy(2,i)]);
            distance_traveled = sqrt((pt_on_line(1)-p0(1))^2+(pt_on_line(2)-p0(2))^2);
            x_y_time_color.distance_up_arm(count) = distance_traveled;
            pt_on_wall31 = proj_pt(w31,[xy(1,i),xy(2,i)]);
            distance_wall31 = sqrt((pt_on_wall31(1) - xy(1,i))^2 + (pt_on_wall31(2) - xy(2,i))^2);
            pt_on_wall32 = proj_pt(w32,[xy(1,i),xy(2,i)]);
            distance_wall32 = sqrt((pt_on_wall32(1) - xy(1,i))^2 + (pt_on_wall32(2) - xy(2,i))^2);
            if distance_wall32 > distance_wall31
                closest_wall = 31;
            else
                closest_wall = 32;
            end 
        end
        
        
        % COLOR
        if i == 1 
            if region_at_time(i) == 1 ||region_at_time(i) == 4 ||region_at_time(i) == 7
                if closest_wall == 12
                    if right_left(i) == 1
                        x_y_time_color.color(count,:) = P_AirWall_Color;
                    elseif right_left(i) == 2
                        x_y_time_color.color(count,:) = O_AirWall_Color;
                    elseif right_left(i) == 3
                        x_y_time_color.color(count,:) = M_AirWall_Color;
                    else
                        x_y_time_color.color(count,:) = P_AirWall_Color;
                    end
                else
                    if right_left(i) == 1
                        x_y_time_color.color(count,:) = O_AirWall_Color;
                    elseif right_left(i) == 2
                        x_y_time_color.color(count,:) = P_AirWall_Color;
                    elseif right_left(i) == 3
                        x_y_time_color.color(count,:) = P_AirWall_Color;
                    else
                        x_y_time_color.color(count,:) = M_AirWall_Color;
                    end
                end    
            elseif region_at_time(i) == 2 ||region_at_time(i) == 5 ||region_at_time(i) == 8
                if closest_wall == 21 
                     if right_left(i) == 1
                        x_y_time_color.color(count,:) = O_AirWall_Color;
                    elseif right_left(i) == 2
                        x_y_time_color.color(count,:) = P_AirWall_Color;
                    elseif right_left(i) == 3
                        x_y_time_color.color(count,:) = P_AirWall_Color;
                    else
                        x_y_time_color.color(count,:) = M_AirWall_Color;
                    end
                else
                    if right_left(i) == 1
                        x_y_time_color.color(count,:) = P_AirWall_Color;
                    elseif right_left(i) == 2
                        x_y_time_color.color(count,:) = O_AirWall_Color;
                    elseif right_left(i) == 3
                        x_y_time_color.color(count,:) = M_AirWall_Color;
                    else
                        x_y_time_color.color(count,:) = P_AirWall_Color;
                    end
                end    
            else
                if closest_wall == 31 
                     if right_left(i) == 1
                        x_y_time_color.color(count,:) = P_AirWall_Color;
                    elseif right_left(i) == 2
                        x_y_time_color.color(count,:) = O_AirWall_Color;
                    elseif right_left(i) == 3
                        x_y_time_color.color(count,:) = M_AirWall_Color;
                    else
                        x_y_time_color.color(count,:) = P_AirWall_Color;
                    end
                else
                    if right_left(i) == 1
                        x_y_time_color.color(count,:) = O_AirWall_Color;
                    elseif right_left(i) == 2
                        x_y_time_color.color(count,:) = P_AirWall_Color;
                    elseif right_left(i) == 3
                        x_y_time_color.color(count,:) = P_AirWall_Color;
                    else
                        x_y_time_color.color(count,:) = M_AirWall_Color;
                    end
                end  
            end    
            if air_arm(i+1) == 1
                pastregion147 = 1;
            elseif air_arm(i+1) == 2
                pastregion258 = 1;
            elseif air_arm(i+1) == 3
                pastregion369 = 1;
            end 
            continue
        elseif region_at_time(i) == 0
            x_y_time_color.color(count,:) = x_y_time_color.color(count-1,:); 
        end
        if choice_count <= length(cps)
            if i == length(xy(1,:))
                x_y_time_color.color(count,:) = Air_Color;
                continue
            end 
            if mod(choice_count,2) == 0
                if i < cps(choice_count)
                    if pastregion147 == 1
                        if region_at_time(i) == 1||region_at_time(i)== 4||region_at_time(i) == 7
                            if air_arm(ct_right_left) == 1
                                if right_left(ct_right_left) == 1
                                    if closest_wall == 12
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    end  
                                else
                                    if closest_wall == 12
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end 
                                end    
                            else    
                                x_y_time_color.color(count,:) = x_y_time_color.color(count-1,:);
                            end
                        elseif region_at_time(i) == 2||region_at_time(i)== 5||region_at_time(i) == 8
                            pastregion147 = 0;
                            pastregion258 = 1;
                            if right_left(ct_right_left) == 1
                                if air_arm(ct_right_left) == 1
                                    x_y_time_color.color(count,:) = P_A_Color;
                                elseif air_arm(ct_right_left) == 2
                                    if closest_wall == 21
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end    
                                elseif air_arm(ct_right_left) == 3
                                    x_y_time_color.color(count,:) = O_P_Color;
                                end
                            elseif right_left(ct_right_left) == 2
                                if air_arm(ct_right_left) == 1
                                    x_y_time_color.color(count,:) = O_A_Color;
                                elseif air_arm(ct_right_left) == 2
                                    if closest_wall == 21
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    end  
                                elseif air_arm(ct_right_left) == 3
                                    x_y_time_color.color(count,:) = P_O_Color;
                                end
                            end
                        elseif region_at_time(i) == 3||region_at_time(i)== 6||region_at_time(i) == 9
                            pastregion147 = 0;
                            pastregion369 = 1;
                            if right_left(ct_right_left) == 1
                                if air_arm(ct_right_left) == 1
                                    x_y_time_color.color(count,:) = O_A_Color;
                                elseif air_arm(ct_right_left) == 2
                                    x_y_time_color.color(count,:) = P_O_Color;
                                elseif air_arm(ct_right_left) == 3
                                    if closest_wall == 31
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    end  
                                end
                            elseif right_left(ct_right_left) == 2
                                if air_arm(ct_right_left) == 1
                                    x_y_time_color.color(count,:) = P_A_Color;
                                elseif air_arm(ct_right_left) == 2
                                    x_y_time_color.color(count,:) = O_P_Color;
                                elseif air_arm(ct_right_left) == 3
                                    if closest_wall == 31
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                                end
                            end
                        end
                    elseif pastregion258 == 1    
                        if region_at_time(i) == 2||region_at_time(i)== 5||region_at_time(i) == 8
                            if air_arm(ct_right_left) == 2
                                if right_left(ct_right_left) == 1
                                    if closest_wall == 23
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    end  
                                else
                                    if closest_wall == 23
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end 
                                end    
                            else    
                                x_y_time_color.color(count,:) = x_y_time_color.color(count-1,:);
                            end
                        elseif region_at_time(i) == 1||region_at_time(i)== 4||region_at_time(i) == 7
                            pastregion258 = 0;
                            pastregion147 = 1;
                            if right_left(ct_right_left) == 1
                                if air_arm(ct_right_left) == 1
                                    if closest_wall == 12
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    end  
                                elseif air_arm(ct_right_left) == 2
                                    x_y_time_color.color(count,:) = O_A_Color;
                                elseif air_arm(ct_right_left) == 3
                                    x_y_time_color.color(count,:) = P_O_Color;
                                end
                            elseif right_left(ct_right_left) == 2
                                if air_arm(ct_right_left) == 1
                                    if closest_wall == 12
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                                elseif air_arm(ct_right_left) == 2
                                    x_y_time_color.color(count,:) = P_A_Color;
                                elseif air_arm(ct_right_left) == 3
                                    x_y_time_color.color(count,:) = O_P_Color;
                                end
                            end
                        elseif region_at_time(i) == 3||region_at_time(i)== 6||region_at_time(i) == 9
                            pastregion258 = 0;
                            pastregion369 = 1;
                            if right_left(ct_right_left) == 1
                                if air_arm(ct_right_left) == 1
                                    x_y_time_color.color(count,:) = O_P_Color;
                                elseif air_arm(ct_right_left) == 2
                                    x_y_time_color.color(count,:) = P_A_Color;
                                elseif air_arm(ct_right_left) == 3
                                    if closest_wall == 31
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    end  
                                end
                            elseif right_left(ct_right_left) == 2
                                if air_arm(ct_right_left) == 1
                                    x_y_time_color.color(count,:) = P_O_Color;
                                elseif air_arm(ct_right_left) == 2
                                    x_y_time_color.color(count,:) = O_A_Color;
                                elseif air_arm(ct_right_left) == 3
                                    if closest_wall == 31
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                                end
                            end
                        end
                    elseif pastregion369 == 1    
                        if region_at_time(i) == 3||region_at_time(i)== 6||region_at_time(i) == 9
                            if air_arm(ct_right_left) == 3
                                if right_left(ct_right_left) == 1
                                    if closest_wall == 31
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    end  
                                else
                                    if closest_wall == 31
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end 
                                end    
                            else    
                                x_y_time_color.color(count,:) = x_y_time_color.color(count-1,:);
                            end
                        elseif region_at_time(i) == 1||region_at_time(i)== 4||region_at_time(i) == 7
                            pastregion369 = 0;
                            pastregion147 = 1;
                            if right_left(ct_right_left) == 1
                                if air_arm(ct_right_left) == 1
                                    if closest_wall == 12
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    end  
                                elseif air_arm(ct_right_left) == 2
                                    x_y_time_color.color(count,:) = O_P_Color;
                                elseif air_arm(ct_right_left) == 3
                                    x_y_time_color.color(count,:) = P_A_Color;
                                end
                            elseif right_left(ct_right_left) == 2
                                if air_arm(ct_right_left) == 1
                                    if closest_wall == 31
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                                elseif air_arm(ct_right_left) == 2
                                    x_y_time_color.color(count,:) = P_O_Color;
                                elseif air_arm(ct_right_left) == 3
                                    x_y_time_color.color(count,:) = O_A_Color;
                                end
                            end
                        elseif region_at_time(i) == 2||region_at_time(i)== 5||region_at_time(i) == 8
                            pastregion258 = 1;
                            pastregion369 = 0;
                            if right_left(ct_right_left) == 1
                                if air_arm(ct_right_left) == 1
                                    x_y_time_color.color(count,:) = P_O_Color;
                                elseif air_arm(ct_right_left) == 2
                                    if closest_wall == 21
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                                elseif air_arm(ct_right_left) == 3
                                    x_y_time_color.color(count,:) = O_A_Color;
                                end
                            elseif right_left(ct_right_left) == 2
                                if air_arm(ct_right_left) == 1
                                    x_y_time_color.color(count,:) = O_P_Color;
                                elseif air_arm(ct_right_left) == 2
                                    if closest_wall == 21
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    end  
                                elseif air_arm(ct_right_left) == 3
                                    x_y_time_color.color(count,:) = P_A_Color;
                                end
                            end
                        end
                    end

                else
                    choice_count = choice_count + 1;
                    if pastregion147 == 1
                        if region_at_time(i) == 1||region_at_time(i) == 4 ||region_at_time(i) == 7
                            if right_left(i+1) == 3
                                if closest_wall ==12
                                    x_y_time_color.color(count,:) = M_AirWall_Color;
                                else
                                    x_y_time_color.color(count,:) = P_AirWall_Color;
                                end  
                            else
                                if closest_wall ==12
                                    x_y_time_color.color(count,:) = P_AirWall_Color;
                                else
                                    x_y_time_color.color(count,:) = M_AirWall_Color;
                                end 
                            end   
                        elseif region_at_time(i) == 2||region_at_time(i) == 5 ||region_at_time(i) == 8
                            pastregion147 = 0;
                            pastregion258 = 1;
                            if right_left(ct_right_left) == 1
                                x_y_time_color.color(count,:) = P_A_Color;
                            elseif right_left(ct_right_left) == 2
                                x_y_time_color.color(count,:) = O_A_Color;
                            end
                        elseif region_at_time(i) == 3||region_at_time(i) == 6 ||region_at_time(i) == 9     
                            pastregion147 = 0;
                            pastregion369 = 1;
                            if right_left(ct_right_left) == 1
                                x_y_time_color.color(count,:) = O_A_Color;
                            elseif right_left(ct_right_left) == 2
                                x_y_time_color.color(count,:) = P_A_Color;
                            end 
                        end
                    elseif pastregion258 == 1
                        if region_at_time(i) == 2||region_at_time(i) == 5 ||region_at_time(i) == 8
                            if right_left(i+1) == 3
                                if closest_wall ==23
                                    x_y_time_color.color(count,:) = M_AirWall_Color;
                                else
                                    x_y_time_color.color(count,:) = P_AirWall_Color;
                                end  
                            else
                                if closest_wall ==23
                                    x_y_time_color.color(count,:) = P_AirWall_Color;
                                else
                                    x_y_time_color.color(count,:) = M_AirWall_Color;
                                end 
                            end   
                        elseif region_at_time(i) == 1||region_at_time(i) == 4 ||region_at_time(i) == 7
                            pastregion147 = 1;
                            pastregion258 = 0;
                            if right_left(ct_right_left) == 1
                                x_y_time_color.color(count,:) = O_A_Color;
                            elseif right_left(ct_right_left) == 2
                                x_y_time_color.color(count,:) = P_A_Color;
                            end
                        elseif region_at_time(i) == 3||region_at_time(i) == 6 ||region_at_time(i) == 9     
                            pastregion258 = 0;
                            pastregion369 = 1;
                            if right_left(ct_right_left) == 1
                                x_y_time_color.color(count,:) = P_A_Color;
                            elseif right_left(ct_right_left) == 2
                                x_y_time_color.color(count,:) = O_A_Color;
                            end 
                        end    
                    elseif pastregion369 == 1
                        if region_at_time(i) == 3||region_at_time(i) == 6 ||region_at_time(i) == 9
                            if right_left(i+1) == 3
                                if closest_wall ==31
                                    x_y_time_color.color(count,:) = M_AirWall_Color;
                                else
                                    x_y_time_color.color(count,:) = P_AirWall_Color;
                                end  
                            else
                                if closest_wall ==31
                                    x_y_time_color.color(count,:) = P_AirWall_Color;
                                else
                                    x_y_time_color.color(count,:) = M_AirWall_Color;
                                end 
                            end   
                        elseif region_at_time(i) == 1||region_at_time(i) == 4 ||region_at_time(i) == 7
                            pastregion147 = 1;
                            pastregion369 = 0;
                            if right_left(ct_right_left) == 1
                                x_y_time_color.color(count,:) = P_A_Color;
                            elseif right_left(ct_right_left) == 2
                                x_y_time_color.color(count,:) = O_A_Color;
                            end
                        elseif region_at_time(i) == 2||region_at_time(i) == 5 ||region_at_time(i) == 8     
                            pastregion258 = 1;
                            pastregion369 = 0;
                            if right_left(ct_right_left) == 1
                                x_y_time_color.color(count,:) = O_A_Color;
                            elseif right_left(ct_right_left) == 2
                                x_y_time_color.color(count,:) = P_A_Color;
                            end 
                        end
                    end 
                end
            elseif mod(choice_count,2) == 1
                if i < cps(choice_count)
                    if pastregion147 == 1
                        if region_at_time(i) == 1||region_at_time(i)== 4||region_at_time(i) == 7
                            if air_arm(ct_right_left) == 1
                                if right_left(ct_right_left) == 3
                                    if closest_wall == 12
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                                else
                                    if closest_wall == 12
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    end 
                                end    
                            else    
                                x_y_time_color.color(count,:) = x_y_time_color.color(count-1,:);
                            end
                        elseif region_at_time(i) == 2||region_at_time(i)== 5||region_at_time(i) == 8
                            pastregion147 = 0;
                            pastregion258 = 1;
                            if right_left(ct_right_left) == 3
                                if air_arm(ct_right_left) == 1
                                    x_y_time_color.color(count,:) = M_A_Color;
                                elseif air_arm(ct_right_left) == 2
                                    if closest_wall == 21
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    end  
                                elseif air_arm(ct_right_left) == 3
                                    x_y_time_color.color(count,:) = P_M_Color;
                                end
                            elseif right_left(ct_right_left) == 4
                                if air_arm(ct_right_left) == 1
                                    x_y_time_color.color(count,:) = P_A_Color;
                                elseif air_arm(ct_right_left) == 2
                                    if closest_wall == 21
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                                elseif air_arm(ct_right_left) == 3
                                    x_y_time_color.color(count,:) = M_P_Color;
                                end
                            end
                        elseif region_at_time(i) == 3||region_at_time(i)== 6||region_at_time(i) == 9
                            pastregion147 = 0;
                            pastregion369 = 1;
                            if right_left(ct_right_left) == 3
                                if air_arm(ct_right_left) == 1
                                    x_y_time_color.color(count,:) = P_A_Color;
                                elseif air_arm(ct_right_left) == 2
                                    x_y_time_color.color(count,:) = M_P_Color;
                                elseif air_arm(ct_right_left) == 3
                                    if closest_wall == 31
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                                end
                            elseif right_left(ct_right_left) == 4
                                if air_arm(ct_right_left) == 1
                                    x_y_time_color.color(count,:) = M_A_Color;
                                elseif air_arm(ct_right_left) == 2
                                    x_y_time_color.color(count,:) = P_M_Color;
                                elseif air_arm(ct_right_left) == 3
                                    if closest_wall == 31
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    end  
                                end
                            end
                        end
                    elseif pastregion258 == 1    
                        if region_at_time(i) == 2||region_at_time(i)== 5||region_at_time(i) == 8
                            if air_arm(ct_right_left) == 2
                                if right_left(ct_right_left) == 3
                                    if closest_wall == 23
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                                else
                                    if closest_wall == 23
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    end 
                                end    
                            else    
                                x_y_time_color.color(count,:) = x_y_time_color.color(count-1,:);
                            end
                        elseif region_at_time(i) == 1||region_at_time(i)== 4||region_at_time(i) == 7
                            pastregion258 = 0;
                            pastregion147 = 1;
                            if right_left(ct_right_left) == 3
                                if air_arm(ct_right_left) == 1
                                    if closest_wall == 13
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    end  
                                elseif air_arm(ct_right_left) == 2
                                    x_y_time_color.color(count,:) = P_A_Color;
                                elseif air_arm(ct_right_left) == 3
                                    x_y_time_color.color(count,:) = M_P_Color;
                                end
                            elseif right_left(ct_right_left) == 4
                                if air_arm(ct_right_left) == 1
                                    if closest_wall == 13
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                                elseif air_arm(ct_right_left) == 2
                                    x_y_time_color.color(count,:) = M_A_Color;
                                elseif air_arm(ct_right_left) == 3
                                    x_y_time_color.color(count,:) = P_M_Color;
                                end
                            end
                        elseif region_at_time(i) == 3||region_at_time(i)== 6||region_at_time(i) == 9
                            pastregion258 = 0;
                            pastregion369 = 1;
                            if right_left(ct_right_left) == 3
                                if air_arm(ct_right_left) == 1
                                    x_y_time_color.color(count,:) = P_M_Color;
                                elseif air_arm(ct_right_left) == 2
                                    x_y_time_color.color(count,:) = M_A_Color;
                                elseif air_arm(ct_right_left) == 3
                                    if closest_wall == 31
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                                end
                            elseif right_left(ct_right_left) == 4
                                if air_arm(ct_right_left) == 1
                                    x_y_time_color.color(count,:) = M_P_Color;
                                elseif air_arm(ct_right_left) == 2
                                    x_y_time_color.color(count,:) = P_A_Color;
                                elseif air_arm(ct_right_left) == 3
                                    if closest_wall == 31
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    end  
                                end
                            end
                        end
                    elseif pastregion369 == 1    
                        if region_at_time(i) == 3||region_at_time(i)== 6||region_at_time(i) == 9
                            if air_arm(ct_right_left) == 3
                                if right_left(ct_right_left) == 3
                                    if closest_wall == 31
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                                else
                                    if closest_wall == 31
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    end 
                                end    
                            else    
                                x_y_time_color.color(count,:) = x_y_time_color.color(count-1,:);
                            end
                        elseif region_at_time(i) == 1||region_at_time(i)== 4||region_at_time(i) == 7
                            pastregion369 = 0;
                            pastregion147 = 1;
                            if right_left(ct_right_left) == 3
                                if air_arm(ct_right_left) == 1
                                    if closest_wall == 13
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    end  
                                elseif air_arm(ct_right_left) == 2
                                    x_y_time_color.color(count,:) = P_M_Color;
                                elseif air_arm(ct_right_left) == 3
                                    x_y_time_color.color(count,:) = M_A_Color;
                                end
                            elseif right_left(ct_right_left) == 4
                                if air_arm(ct_right_left) == 1
                                    if closest_wall == 31
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                                elseif air_arm(ct_right_left) == 2
                                    x_y_time_color.color(count,:) = M_P_Color;
                                elseif air_arm(ct_right_left) == 3
                                    x_y_time_color.color(count,:) = P_A_Color;
                                end
                            end
                        elseif region_at_time(i) == 2||region_at_time(i)== 5||region_at_time(i) == 8
                            pastregion258 = 1;
                            pastregion369 = 0;
                            if right_left(ct_right_left) == 3
                                if air_arm(ct_right_left) == 1
                                    x_y_time_color.color(count,:) = M_P_Color;
                                elseif air_arm(ct_right_left) == 2
                                    if closest_wall == 21
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    end  
                                elseif air_arm(ct_right_left) == 3
                                    x_y_time_color.color(count,:) = P_A_Color;
                                end
                            elseif right_left(ct_right_left) == 4
                                if air_arm(ct_right_left) == 1
                                    x_y_time_color.color(count,:) = P_M_Color;
                                elseif air_arm(ct_right_left) == 2
                                    if closest_wall == 21
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                                elseif air_arm(ct_right_left) == 3
                                    x_y_time_color.color(count,:) = M_A_Color;
                                end
                            end
                        end
                    end

                else
                    choice_count = choice_count + 1;
                    if pastregion147 == 1
                        if i == length(xy(1,:))
                            x_y_time_color.color(count,:) = Air_Color;
                            continue
                        end    
                        if region_at_time(i) == 1||region_at_time(i) == 4 ||region_at_time(i) == 7
                            if right_left(i+1) == 1
                                if closest_wall ==13
                                    x_y_time_color.color(count,:) = O_AirWall_Color;
                                else
                                    x_y_time_color.color(count,:) = P_AirWall_Color;
                                end  
                            else
                                if closest_wall ==13
                                    x_y_time_color.color(count,:) = P_AirWall_Color;
                                else
                                    x_y_time_color.color(count,:) = O_AirWall_Color;
                                end 
                            end   
                        elseif region_at_time(i) == 2||region_at_time(i) == 5 ||region_at_time(i) == 8
                            pastregion147 = 0;
                            pastregion258 = 1;
                            if right_left(ct_right_left) == 3
                                x_y_time_color.color(count,:) = M_A_Color;
                            elseif right_left(ct_right_left) == 4
                                x_y_time_color.color(count,:) = P_A_Color;
                            end
                        elseif region_at_time(i) == 3||region_at_time(i) == 6 ||region_at_time(i) == 9     
                            pastregion147 = 0;
                            pastregion369 = 1;
                            if right_left(ct_right_left) == 3
                                x_y_time_color.color(count,:) = P_A_Color;
                            elseif right_left(ct_right_left) == 4
                                x_y_time_color.color(count,:) = M_A_Color;
                            end 
                        end
                    elseif pastregion258 == 1
                        if i == length(xy(1,:))
                            x_y_time_color.color(count,:) = Air_Color;
                            continue
                        end 
                        if region_at_time(i) == 2||region_at_time(i) == 5 ||region_at_time(i) == 8
                            if right_left(i+1) == 1
                                if closest_wall ==21
                                    x_y_time_color.color(count,:) = O_AirWall_Color;
                                else
                                    x_y_time_color.color(count,:) = P_AirWall_Color;
                                end  
                            else
                                if closest_wall ==21
                                    x_y_time_color.color(count,:) = P_AirWall_Color;
                                else
                                    x_y_time_color.color(count,:) = O_AirWall_Color;
                                end 
                            end 
                        elseif region_at_time(i) == 1||region_at_time(i) == 4 ||region_at_time(i) == 7
                            pastregion147 = 1;
                            pastregion258 = 0;
                            if right_left(ct_right_left) == 3
                                x_y_time_color.color(count,:) = P_A_Color;
                            elseif right_left(ct_right_left) == 4
                                x_y_time_color.color(count,:) = M_A_Color;
                            end
                        elseif region_at_time(i) == 3||region_at_time(i) == 6 ||region_at_time(i) == 9     
                            pastregion258 = 0;
                            pastregion369 = 1;
                            if right_left(ct_right_left) == 3
                                x_y_time_color.color(count,:) = M_A_Color;
                            elseif right_left(ct_right_left) == 4
                                x_y_time_color.color(count,:) = P_A_Color;
                            end 
                        end    
                    elseif pastregion369 == 1
                        if i == length(xy(1,:))
                            x_y_time_color.color(count,:) = Air_Color;
                            continue
                        end 
                        if region_at_time(i) == 3||region_at_time(i) == 6 ||region_at_time(i) == 9
                            if right_left(i+1) == 1
                                if closest_wall ==32
                                    x_y_time_color.color(count,:) = O_AirWall_Color;
                                else
                                    x_y_time_color.color(count,:) = P_AirWall_Color;
                                end  
                            else
                                if closest_wall ==32
                                    x_y_time_color.color(count,:) = P_AirWall_Color;
                                else
                                    x_y_time_color.color(count,:) = O_AirWall_Color;
                                end 
                            end 
                        elseif region_at_time(i) == 1||region_at_time(i) == 4 ||region_at_time(i) == 7
                            pastregion147 = 1;
                            pastregion369 = 0;
                            if right_left(ct_right_left) == 3
                                x_y_time_color.color(count,:) = M_A_Color;
                            elseif right_left(ct_right_left) == 4
                                x_y_time_color.color(count,:) = P_A_Color;
                            end
                        elseif region_at_time(i) == 2||region_at_time(i) == 5 ||region_at_time(i) == 8     
                            pastregion258 = 1;
                            pastregion369 = 0;
                            if right_left(ct_right_left) == 3
                                x_y_time_color.color(count,:) = P_A_Color;
                            elseif right_left(ct_right_left) == 4
                                x_y_time_color.color(count,:) = M_A_Color;
                            end 
                        end
                    end    
                end
            end    
        elseif choice_count > length(cps) 
            if i == length(xy(1,:))
                x_y_time_color.color(count,:) = Air_Color;
                continue
            end 
            if mod(choice_count,2) == 0
                 if pastregion147 == 1
                        if region_at_time(i) == 1||region_at_time(i)== 4||region_at_time(i) == 7
                            if air_arm(ct_right_left) == 1
                                if right_left(ct_right_left) == 1
                                    if closest_wall == 12
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    end  
                                else
                                    if closest_wall == 12
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end 
                                end    
                            else    
                                x_y_time_color.color(count,:) = x_y_time_color.color(count-1,:);
                            end
                        elseif region_at_time(i) == 2||region_at_time(i)== 5||region_at_time(i) == 8
                            pastregion147 = 0;
                            pastregion258 = 1;
                            if right_left(ct_right_left) == 1
                                if air_arm(ct_right_left) == 1
                                    x_y_time_color.color(count,:) = P_A_Color;
                                elseif air_arm(ct_right_left) == 2
                                    if closest_wall == 21
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                                elseif air_arm(ct_right_left) == 3
                                    x_y_time_color.color(count,:) = O_P_Color;
                                end
                            elseif right_left(ct_right_left) == 2
                                if air_arm(ct_right_left) == 1
                                    x_y_time_color.color(count,:) = O_A_Color;
                                elseif air_arm(ct_right_left) == 2
                                    if closest_wall == 21
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    end  
                                elseif air_arm(ct_right_left) == 3
                                    x_y_time_color.color(count,:) = P_O_Color;
                                end
                            end
                        elseif region_at_time(i) == 3||region_at_time(i)== 6||region_at_time(i) == 9
                            pastregion147 = 0;
                            pastregion369 = 1;
                            if right_left(ct_right_left) == 1
                                if air_arm(ct_right_left) == 1
                                    x_y_time_color.color(count,:) = O_A_Color;
                                elseif air_arm(ct_right_left) == 2
                                    x_y_time_color.color(count,:) = P_O_Color;
                                elseif air_arm(ct_right_left) == 3
                                    if closest_wall == 31
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    end  
                                end
                            elseif right_left(i) == 2
                                if air_arm(ct_right_left) == 1
                                    x_y_time_color.color(count,:) = P_A_Color;
                                elseif air_arm(ct_right_left) == 2
                                    x_y_time_color.color(count,:) = O_P_Color;
                                elseif air_arm(ct_right_left) == 3
                                    if closest_wall == 31
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                                end
                            end
                        end
                    elseif pastregion258 == 1    
                        if region_at_time(i) == 2||region_at_time(i)== 5||region_at_time(i) == 8
                            if air_arm(ct_right_left) == 2
                                if right_left(ct_right_left) == 1
                                    if closest_wall == 23
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    end  
                                else
                                    if closest_wall == 23
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end 
                                end    
                            else    
                                x_y_time_color.color(count,:) = x_y_time_color.color(count-1,:);
                            end
                        elseif region_at_time(i) == 1||region_at_time(i)== 4||region_at_time(i) == 7
                            pastregion258 = 0;
                            pastregion147 = 1;
                            if right_left(ct_right_left) == 1
                                if air_arm(ct_right_left) == 1
                                    if closest_wall == 13
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                                elseif air_arm(ct_right_left) == 2
                                    x_y_time_color.color(count,:) = O_A_Color;
                                elseif air_arm(ct_right_left) == 3
                                    x_y_time_color.color(count,:) = P_O_Color;
                                end
                            elseif right_left(i) == 2
                                if air_arm(ct_right_left) == 1
                                    if closest_wall == 13
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    end  
                                elseif air_arm(ct_right_left) == 2
                                    x_y_time_color.color(count,:) = P_A_Color;
                                elseif air_arm(ct_right_left) == 3
                                    x_y_time_color.color(count,:) = O_P_Color;
                                end
                            end
                        elseif region_at_time(i) == 3||region_at_time(i)== 6||region_at_time(i) == 9
                            pastregion258 = 0;
                            pastregion369 = 1;
                            if right_left(ct_right_left) == 1
                                if air_arm(ct_right_left) == 1
                                    x_y_time_color.color(count,:) = O_P_Color;
                                elseif air_arm(ct_right_left) == 2
                                    x_y_time_color.color(count,:) = P_A_Color;
                                elseif air_arm(ct_right_left) == 3
                                    if closest_wall == 31
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    end  
                                end
                            elseif right_left(ct_right_left) == 2
                                if air_arm(ct_right_left) == 1
                                    x_y_time_color.color(count,:) = M_O_Color;
                                elseif air_arm(ct_right_left) == 2
                                    x_y_time_color.color(count,:) = O_A_Color;
                                elseif air_arm(ct_right_left) == 3
                                    if closest_wall == 31
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                                end
                            end
                        end
                    elseif pastregion369 == 1    
                        if region_at_time(i) == 3||region_at_time(i)== 6||region_at_time(i) == 9
                            if air_arm(ct_right_left) == 3
                                if right_left(ct_right_left) == 1
                                    if closest_wall == 31
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    end  
                                else
                                    if closest_wall == 31
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end 
                                end    
                            else    
                                x_y_time_color.color(count,:) = x_y_time_color.color(count-1,:);
                            end
                        elseif region_at_time(i) == 1||region_at_time(i)== 4||region_at_time(i) == 7
                            pastregion369 = 0;
                            pastregion147 = 1;
                            if right_left(ct_right_left) == 1
                                if air_arm(ct_right_left) == 1
                                    if closest_wall == 13
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                                elseif air_arm(ct_right_left) == 2
                                    x_y_time_color.color(count,:) = O_P_Color;
                                elseif air_arm(ct_right_left) == 3
                                    x_y_time_color.color(count,:) = P_A_Color;
                                end
                            elseif right_left(ct_right_left) == 2
                                if air_arm(ct_right_left) == 1
                                    if closest_wall == 13
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    end  
                                elseif air_arm(ct_right_left) == 2
                                    x_y_time_color.color(count,:) = P_O_Color;
                                elseif air_arm(ct_right_left) == 3
                                    x_y_time_color.color(count,:) = O_A_Color;
                                end
                            end
                        elseif region_at_time(i) == 2||region_at_time(i)== 5||region_at_time(i) == 8
                            pastregion258 = 1;
                            pastregion369 = 0;
                            if right_left(ct_right_left) == 1
                                if air_arm(ct_right_left) == 1
                                    x_y_time_color.color(count,:) = P_O_Color;
                                elseif air_arm(ct_right_left) == 2
                                    if closest_wall == 21
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                                elseif air_arm(ct_right_left) == 3
                                    x_y_time_color.color(count,:) = O_A_Color;
                                end
                            elseif right_left(ct_right_left) == 2
                                if air_arm(ct_right_left) == 1
                                    x_y_time_color.color(count,:) = O_P_Color;
                                elseif air_arm(ct_right_left) == 2
                                    if closest_wall == 21
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = O_AirWall_Color;
                                    end  
                                elseif air_arm(ct_right_left) == 3
                                    x_y_time_color.color(count,:) = P_A_Color;
                                end
                            end
                        end
                 end
            elseif mod(choice_count,2) == 1
                if pastregion147 == 1
                    if region_at_time(i) == 1||region_at_time(i)== 4||region_at_time(i) == 7
                        if air_arm(ct_right_left) == 1
                            if right_left(ct_right_left) == 3
                                if closest_wall == 12
                                    x_y_time_color.color(count,:) = M_AirWall_Color;
                                else
                                    x_y_time_color.color(count,:) = P_AirWall_Color;
                                end  
                            else
                                if closest_wall == 12
                                    x_y_time_color.color(count,:) = P_AirWall_Color;
                                else
                                    x_y_time_color.color(count,:) = M_AirWall_Color;
                                end 
                            end    
                        else    
                            x_y_time_color.color(count,:) = x_y_time_color.color(count-1,:);
                        end
                        elseif region_at_time(i) == 2||region_at_time(i)== 5||region_at_time(i) == 8
                        pastregion147 = 0;
                        pastregion258 = 1;
                        if right_left(ct_right_left) == 3
                            if air_arm(ct_right_left) == 1
                                x_y_time_color.color(count,:) = M_A_Color;
                            elseif air_arm(ct_right_left) == 2
                                if closest_wall == 21
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    end  
                            elseif air_arm(ct_right_left) == 3
                                x_y_time_color.color(count,:) = P_M_Color;
                            end
                        elseif right_left(ct_right_left) == 4
                            if air_arm(ct_right_left) == 1
                                x_y_time_color.color(count,:) = P_A_Color;
                            elseif air_arm(ct_right_left) == 2
                                if closest_wall == 21
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                            elseif air_arm(ct_right_left) == 3
                                x_y_time_color.color(count,:) = M_P_Color;
                            end
                        end
                    elseif region_at_time(i) == 3||region_at_time(i)== 6||region_at_time(i) == 9
                        pastregion147 = 0;
                        pastregion369 = 1;
                        if right_left(ct_right_left) == 3
                            if air_arm(ct_right_left) == 1
                                x_y_time_color.color(count,:) = P_A_Color;
                            elseif air_arm(ct_right_left) == 2
                                x_y_time_color.color(count,:) = M_P_Color;
                            elseif air_arm(ct_right_left) == 3
                                if closest_wall == 31
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                            end
                        elseif right_left(ct_right_left) == 4
                            if air_arm(ct_right_left) == 1
                                x_y_time_color.color(count,:) = M_A_Color;
                            elseif air_arm(ct_right_left) == 2
                                x_y_time_color.color(count,:) = P_M_Color;
                            elseif air_arm(ct_right_left) == 3
                                if closest_wall == 31
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    end  
                            end
                        end
                    end
                elseif pastregion258 == 1    
                    if region_at_time(i) == 2||region_at_time(i)== 5||region_at_time(i) == 8
                        if air_arm(ct_right_left) == 2
                                if right_left(ct_right_left) == 3
                                    if closest_wall == 23
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                                else
                                    if closest_wall == 23
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    end 
                                end    
                            else    
                                x_y_time_color.color(count,:) = x_y_time_color.color(count-1,:);
                            end
                         elseif region_at_time(i) == 1||region_at_time(i)== 4||region_at_time(i) == 7
                        pastregion258 = 0;
                        pastregion147 = 1;
                        if right_left(ct_right_left) == 3
                            if air_arm(ct_right_left) == 1
                                if closest_wall == 12
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                            elseif air_arm(ct_right_left) == 2
                                x_y_time_color.color(count,:) = P_A_Color;
                            elseif air_arm(ct_right_left) == 3
                                x_y_time_color.color(count,:) = M_P_Color;
                            end
                        elseif right_left(ct_right_left) == 4
                            if air_arm(ct_right_left) == 1
                                if closest_wall == 12
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    end  
                            elseif air_arm(ct_right_left) == 2
                                x_y_time_color.color(count,:) = M_A_Color;
                            elseif air_arm(ct_right_left) == 3
                                x_y_time_color.color(count,:) = P_M_Color;
                            end
                        end
                    elseif region_at_time(i) == 3||region_at_time(i)== 6||region_at_time(i) == 9
                        pastregion258 = 0;
                        pastregion369 = 1;
                        if right_left(ct_right_left) == 3
                            if air_arm(ct_right_left) == 1
                                x_y_time_color.color(count,:) = P_M_Color;
                            elseif air_arm(ct_right_left) == 2
                                x_y_time_color.color(count,:) = M_A_Color;
                            elseif air_arm(ct_right_left) == 3
                                if closest_wall == 31
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                            end
                        elseif right_left(ct_right_left) == 4
                            if air_arm(ct_right_left) == 1
                                x_y_time_color.color(count,:) = M_P_Color;
                            elseif air_arm(ct_right_left) == 2
                                x_y_time_color.color(count,:) = P_A_Color;
                            elseif air_arm(ct_right_left) == 3
                                if closest_wall == 31
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    end  
                            end
                        end
                    end
                elseif pastregion369 == 1    
                    if region_at_time(i) == 3||region_at_time(i)== 6||region_at_time(i) == 9
                        if air_arm(ct_right_left) == 3
                                if right_left(ct_right_left) == 3
                                    if closest_wall == 31
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                                else
                                    if closest_wall == 31
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    end 
                                end    
                            else    
                                x_y_time_color.color(count,:) = x_y_time_color.color(count-1,:);
                            end
                        elseif region_at_time(i) == 1||region_at_time(i)== 4||region_at_time(i) == 7
                        pastregion369 = 0;
                        pastregion147 = 1;
                        if right_left(ct_right_left) == 3
                            if air_arm(ct_right_left) == 1
                                if closest_wall == 12
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                            elseif air_arm(ct_right_left) == 2
                                x_y_time_color.color(count,:) = P_M_Color;
                            elseif air_arm(ct_right_left) == 3
                                x_y_time_color.color(count,:) = M_A_Color;
                            end
                        elseif right_left(ct_right_left) == 4
                            if air_arm(ct_right_left) == 1
                                if closest_wall == 12
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    end  
                            elseif air_arm(ct_right_left) == 2
                                x_y_time_color.color(count,:) = M_P_Color;
                            elseif air_arm(ct_right_left) == 3
                                x_y_time_color.color(count,:) = P_A_Color;
                            end
                        end
                    elseif region_at_time(i) == 2||region_at_time(i)== 5||region_at_time(i) == 8
                        pastregion258 = 1;
                        pastregion369 = 0;
                        if right_left(ct_right_left) == 3
                            if air_arm(ct_right_left) == 1
                                x_y_time_color.color(count,:) = M_P_Color;
                            elseif air_arm(ct_right_left) == 2
                                if closest_wall == 21
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    end  
                            elseif air_arm(ct_right_left) == 3
                                x_y_time_color.color(count,:) = P_A_Color;
                            end
                        elseif right_left(ct_right_left) == 4
                            if air_arm(ct_right_left) == 1
                                x_y_time_color.color(count,:) = P_M_Color;
                            elseif air_arm(ct_right_left) == 2
                                if closest_wall == 21
                                        x_y_time_color.color(count,:) = M_AirWall_Color;
                                    else
                                        x_y_time_color.color(count,:) = P_AirWall_Color;
                                    end  
                            elseif air_arm(ct_right_left) == 3
                                x_y_time_color.color(count,:) = M_A_Color;
                            end
                        end
                    end
                end
            end    
        end   

    end    

end