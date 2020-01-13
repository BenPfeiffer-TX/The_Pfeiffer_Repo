function [Yangle,Zangle,angularvZ,angularvY,low_loc,high_loc,tempV,C_height,C_loc,C_vel,dh]...
= analyzer(tiff_stack,newB,heightmap,T)


Zangle = zeros(length(newB(:,1)), length(tiff_stack(1,1,:)));
Yangle = zeros(length(newB(:,1)), length(tiff_stack(1,1,:)));
angularvZ = zeros(length(newB(:,1)), length(tiff_stack(1,1,:)));
angularvY = zeros(length(newB(:,1)), length(tiff_stack(1,1,:)));
%C_height gives the height of the center of mass for each bacteria, C_vel
%gives the x,y, and z velocity of the center of mass, and C_loc gives the x
%and y location of the center of mass
C_height = zeros(length(newB(:,1)), length(tiff_stack(1,1,:)));
%C_vel{b,t}(1) = y velocity, (2) = x velocity
C_vel = cell(length(newB(:,1)), length(tiff_stack(1,1,:)));
%C_acc = cell(length(newB(:,1)), length(tiff_stack(1,1,:)));
C_loc = cell(length(newB(:,1)), length(tiff_stack(1,1,:)));
plength = zeros(length(newB(:,1)), length(tiff_stack(1,1,:)));
tlength = zeros(length(newB(:,1)), length(tiff_stack(1,1,:)));
dh = zeros(length(newB(:,1)), length(tiff_stack(1,1,:)));
tempV = cell(length(newB(:,1)),length(tiff_stack(1,1,:)));
low_loc = cell(length(newB(:,1)),length(tiff_stack(1,1,:)));
high_loc = cell(length(newB(:,1)),length(tiff_stack(1,1,:)));
for t = 1 : T
disp(t)
    for v = 1 : length(newB(:,t))
        if isempty(newB{v,t}) == false
            rowcol = newB{v,t};
            minH = min(min(heightmap(min(rowcol(:,1)):max(rowcol(:,1)),...
                       min(rowcol(:,2)):max(rowcol(:,2)),t)));
            maxH = max(max(heightmap(min(rowcol(:,1)):max(rowcol(:,1)),...
                       min(rowcol(:,2)):max(rowcol(:,2)),t)));

            indmax = find(heightmap(:,:,t)==maxH);
            indmin = find(heightmap(:,:,t)==minH);
            [maxx,maxy] = ind2sub(size(heightmap(:,:,t)),indmax);
            [minx,miny] = ind2sub(size(heightmap(:,:,t)),indmin);
            txmax = zeros();
            tymax = zeros(); %temporarily stores pixel coords to do length calcs with
            txmin = zeros(); %Sometimes there is more than one pixel w/ the lowest height
            tymin = zeros();
            ii = 1;
            for k = 1 : length(maxx)
                if ismember(maxx(k),min(rowcol(:,1)):max(rowcol(:,1))) == true &&...
                   ismember(maxy(k),min(rowcol(:,2)):max(rowcol(:,2))) == true
                    txmax(ii) = maxx(k);
                    tymax(ii) = maxy(k);
                    ii = ii + 1;
                end
            end
            ii=1;
            for kk = 1 : length(minx)
                if ismember(minx(kk), rowcol(:,1)) == true && ismember(miny(kk), rowcol(:,2)) == true
                    txmin(ii) = minx(kk);
                    tymin(ii) = miny(kk);
                    ii=ii+1;
                end
            end
            % This code determines the projected length by finding the
            % maximal distance between the various min and max height pts
            tempL = zeros();
            for i = 1 : length(txmax)
                for ij = 1 : length(txmin)
                    tempL(i,ij) = sqrt(abs(txmax(i)-txmin(ij))^2 + abs(tymax(i)-tymin(ij))^2);
                end
            end
            %C_0 is the coordinate for the lowest point of the bacteria,
            %C_e is the coordinate for the highest (visible) point of the bacteria
            Cx0 = mean(txmin);
            Cy0 = mean(tymin);
            temp=zeros();
            %This for loop finds the maximum distance from the lowest point
            %to all the other pixels in the region. This yields a more
            %accurate COM location since the displacement vector is closer
            %to parallel with the long axis
            for x = min(rowcol(:,1)):max(rowcol(:,1))
               for y = min(rowcol(:,2)):max(rowcol(:,2))
                   if isnan(heightmap(x,y,t)) == false
                        temp(i) = sqrt(abs(Cx0-x)^2 + abs(Cy0-y)^2);
                        if temp(i) == max(max(temp))
                            Cxe = x;
                            Cye = y;
                            plength(v,t) = (0.0653328)*temp(i);
                        end
                        i=i+1;
                   end
               end
            end
            Y = [0 1]; %This is our Y-hat vector
            low_loc{v,t}=[Cx0 Cy0];
            high_loc{v,t}=[Cxe Cye];
            templength = sqrt((Cxe - Cx0)^2 + (Cye - Cy0)^2);
            tempV{v,t} = (15.3*(0.5)*plength(v,t))*[(Cxe-Cx0) (Cye-Cy0)]/templength;
            Yangle(v,t) = acosd(dot(Y,tempV{v,t})/norm(tempV{v,t}));
            C_loc{v,t} = [Cx0 Cy0]+tempV{v,t}; 
            dh(v,t) = abs(minH-(heightmap(round(C_loc{v,t}(1)),round(C_loc{v,t}(2)),t)));
            %Temporary fix to stop NaNs from slipping into data, more than
            %likely over estimates angles, but that isn't a big concern
            %since my method in general understimates the angle
            if isnan(heightmap(round(C_loc{v,t}(1)),round(C_loc{v,t}(2)),t)) == true
                dh(v,t) = abs(minH-maxH);
            end
            
            tlength(v,t) = sqrt((plength(v,t))^2 + (dh(v,t))^2);
            tempP = C_loc{v,t}-low_loc{v,t};
            tempP = sqrt(tempP(1)^2 + tempP(2)^2)/15.3;
            Zangle(v,t) = atand(dh(v,t)/tempP);
            C_height(v,t) = sind(Zangle(v,t)) + minH;
            if t > 2
                angularvZ(v,t) = Zangle(v,t)-Zangle(v,t-1);
                if Zangle(v,t-1) == 0
                    angularvZ(v,t)=0;
                end
                angularvY(v,t) = Yangle(v,t)-Yangle(v,t-1);
                if isempty(C_loc{v,t-1}) == true
                    C_vel{v,t} = ...
                        [(C_loc{v,t}(1)-C_loc{v,t}(1))...
                        (C_loc{v,t}(2)-C_loc{v,t}(2))...
                        (C_height(v,t)-C_height(v,t))];
                else
                    C_vel{v,t} = ...
                        [(C_loc{v,t}(1)-C_loc{v,t-1}(1))...
                        (C_loc{v,t}(2)-C_loc{v,t-1}(2))...
                        (C_height(v,t)-C_height(v,t-1))];
                end
            end
        end
    end
end
end

