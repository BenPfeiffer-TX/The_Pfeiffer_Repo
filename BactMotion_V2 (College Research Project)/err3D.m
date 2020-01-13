function [orient] = err3D(data,initial)
%For now this is a proof of concept of doing error analysis between
%incomplete data of an ellipsoid and an idealized ellipsoid representation
%of a bacteria. This function only needs to be passed the data of the
%bacteria in question (passed as an Lx3 array storing the x|y|z of each point)
%and will return the orientation of the bacteria
%(which will probably be stored as [Theta_x, Theta_z, x_com, y_com, z_com])
options = optimset('MaxFunEvals',4000);%2400);
%If the bacteria's long axis is perpendicular or past perp to y-hat, then
%we want to flip the sign of the initial z_angle guess. This is because the
%modeling of the ellipsoid pitches relative to the bacteria's frame of
%reference not the axes, and not having this sign inversion causes the
%initial guess to be backwards
if initial(3) > 90
    initial(1) = -initial(1);
end
[orient, ~] = fminsearch(@ErrMin3,initial,options);
    function err = ErrMin3(orient)
        %Rotations
        rx = orient(1);
        ry = orient(2);
        rz = orient(3);
        %Translations
        Tx = orient(4);
        Ty = orient(5);
        Tz = orient(6);
        %Rotation Matrices
        Rx = [1 0 0;0 cosd(rx) -sind(rx);0 sind(rx) cosd(rx)];
        Ry = [cosd(ry) 0 sind(ry);0 1 0;-sind(ry) 0 cosd(ry)];
        Rz = [cosd(rz) -sind(rz) 0;sind(rz) cosd(rz) 0;0 0 1];
        R = Rz*Ry*Rx;
        %Here we parameterize and draw the model bacteria
        sc=15.3;
        a = sc*0.5;
        b = sc*1.25;
        c = sc*0.5;
        model = zeros(1,3);
        in = 1;
        for ph = 0:5:360
            for th = 0:5:180
                r = [a*sind(th)*cosd(ph); b*sind(ph)*sind(th); c*cosd(th)];
                tran = R*r;
                model(in,1) = tran(1) + Tx; %x
                model(in,2) = tran(2) + Ty; %y
                model(in,3) = tran(3) + Tz; %z
                in = in+1;
            end
        end
        %err = CSDE(data,model);
        err = CSDE2kd2(data,model);
    end
end
% pmodeltc1 = zeros(1,3);
% in = 1;
% for i = 1 : length(modeltc1)
%     if modeltc1(i,3) < 10
%         pmodeltc1(in,:) = modeltc1(i,:);
%         in = in+1;
%     end
% end

