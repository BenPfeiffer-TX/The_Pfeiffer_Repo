function [Zangle2,Yangle2,C_loc2,C_height2,orient,bactdata] = EllipsFitter(newB,heightmap,C_loc,C_height,Zangle,Yangle,T)
%This function does secondary, indirect analysis of the data by means of
%fitting an ideal ellipsoid onto the heightmap of bacteria.
%
%Our new arrays of data derived from this indirect analysis method
Zangle2 = zeros(length(newB(:,1)),T+1);
Yangle2 = Zangle2;
C_height2 = Zangle2;
C_loc2 = cell(length(newB(:,1)),T+1);
orient = cell(length(newB(:,1)),T+1);
bactdata = cell(length(newB(:,1)),T+1);
%
for b = 200:200%1 : length(newB(:,1))
    for t = 1 : T  
        if ~isempty(newB{b,t})
            %For a given region from newB, we generate an Lx3 array of data
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
            %Now we feed this data array + initial estimate of parameters into
            %fitting function
            %Orientation = [Theta_z, roll, Theta_y, Tx, Ty, Tz]
            initial = [Zangle(b,t) 0 Yangle(b,t) ...
                C_loc{b,t}(2) C_loc{b,t}(1) (10+15.3*C_height(b,t))];
            %Here we call err3D(), the fcn that draws the ellipse with the
            %initial parameters and then calls fminsearch() to optimize the
            %fit
            [orientation] = err3D(data,initial);
            %Lastly we store the orientation values from the fit into new
            %arrays
            Zangle2(b,t) = abs(orientation(1));
            Yangle2(b,t) = orientation(3);
            C_height2(b,t) = orientation(6)/15.3;
            %C_loc2{b,t} = [(orientation(5)) (orientation(4))];
            C_loc2{b,t} = [(orientation(5)+min(ry)) (orientation(4)+min(rx))];
            %%%%%
            
            %EllipsGrapher() is just used to automate the graphing process
            %to see how well the ellipsoids fit, and likewise the print
            %statement is to track progress
            orient{b,t} = orientation;
            bactdata{b,t} = data;
            %EllipsGrapher(data,orientation)
            fprintf(['Analyzed bact:',num2str(b),'@t:',num2str(t),'\n'])
        end
    end
end
%
end

