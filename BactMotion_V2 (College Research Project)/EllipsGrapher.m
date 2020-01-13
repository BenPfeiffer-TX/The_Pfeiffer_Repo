function [] = EllipsGrapher(data,orientation)
%Simple function to automate taking in the data of a bacteria as well as
%the "optimized" parameters for the ellipsoid, and graphs them together
figure()
hold on
scatter3(data(:,1),data(:,2),data(:,3))
roll = orientation(1);
pitch = orientation(2);
yaw = orientation(3);
Tx = orientation(4);
Ty = orientation(5);
Tz = orientation(6);
%Rotation matrices
Rx = [1 0 0;0 cosd(roll) -sind(roll);0 sind(roll) cosd(roll)];
Ry = [cosd(pitch) 0 sind(pitch);0 1 0;-sind(pitch) 0 cosd(pitch)];
Rz = [cosd(yaw) -sind(yaw) 0;sind(yaw) cosd(yaw) 0;0 0 1];
R = Rz*Rx*Ry;
%
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
%
scatter3(model(:,1),model(:,2),model(:,3))
ylim([(min(data(:,2))-10) (40+min(data(:,2)))])
xlim([(min(data(:,1))-10) (40+min(data(:,1)))])
zlim([0 40])
view(45,35)
end

