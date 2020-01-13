%This function is used to refit the Fail-to-Fit bacteria. We re-do the
%normal fitting process, and if we still get a "bad fit", then we increase
%the z-displacement and try again. If we get a "bad fit" three times in a
%row, we mark it as a failure and move on
function [newB,heightmap,C_loc,C_height,Zangle,Yangle,orient,bactdata,count_track] = EllipsFitter_refit(newB,heightmap,C_loc,C_height,Zangle,Yangle,refit_index)
count_track = refit_index;
for i = 1:length(refit_index(:,1))
    b = refit_index(i,1);
    t = refit_index(i,2);
    
    rx = min(newB{b,t}(:,2)):max(newB{b,t}(:,2));
    ry = min(newB{b,t}(:,1)):max(newB{b,t}(:,1));
    data = heightmap(ry,rx,t);
    temp = zeros(1,3);
    in = 1;
    for x = 1 : length(data(1,:))
        for y = 1 : length(data(:,1))
            if ~isnan(data(y,x))
                temp(in,1) = x+min(rx);
                temp(in,2) = y+min(ry);
                temp(in,3) = 15.3*data(y,x);
                in=in+1;
            end
        end
    end
    data = temp;
    %We have our bacteria identified, now we try to fit it again
    for count = 0:3
        %Orientation = [Theta_z, roll, Theta_y, Tx, Ty, Tz]
        initial = [Zangle(b,t) 0 Yangle(b,t) ...
            C_loc{b,t}(2) C_loc{b,t}(1) (10+15.3*C_height(b,t) + (count+1)*5)];
        [orientation] = err3D(data,initial);
        if orientation(6)/15.3 >= 0.5
            Zangle(b,t) = abs(orientation(1));
            Yangle(b,t) = orientation(3);
            C_height(b,t) = orientation(6)/15.3;
            %C_loc2{b,t} = [(orientation(5)) (orientation(4))];
            C_loc{b,t} = [(orientation(5)+min(ry)) (orientation(4)+min(rx))];
            count_track(i,3) = count;
            orient{b,t} = orientation;
            bactdata{b,t} = data;
            break;
        elseif orientation(6)/15.3 < 0.5 && count==3
                fprintf(['still failed to fit ',num2str(b),'@t:',num2str(t),', giving up\n']);
        end
    end
%We attempted to re-fit the fail-to-fits, now we just return results
end
%
end
