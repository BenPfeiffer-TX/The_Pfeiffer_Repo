function [] = EllipsMovie(orient,bactdata,T,B)
%Just a simple program to make a movie of a single bacteria moving around
V = VideoWriter(['Ellipse-',num2str(B),'.avi'],'Uncompressed AVI');
V.FrameRate = 20;
% V.Quality = 100;
% count = 0;
% for i = 1 : T
%     if isempty(bactdata{B,i})==false
%         count=count+1;
%     end
% end
% F(count) = struct('cdata',[],'colormap',[]);
figure()
ind=1;
for t = 1:1:T
    if ~isempty(bactdata{B,t})
        hold on
        data = bactdata{B,t};
        orientation = orient{B,t};
        ylim([(min(data(:,2))-10) (40+min(data(:,2)))])
        xlim([(min(data(:,1))-10) (40+min(data(:,1)))])
%         ylim([375 425])
%         xlim([1085 1135])
        zlim([0 40])
        view(60,50)
        xlabel('X')
        ylabel('Y')
        
        scatter3(data(:,1),data(:,2),data(:,3))
        % surf(data(:,1),data(:,2),data(:,3))
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
        sc=15.3;
        a = sc*0.33;
        b = sc*1;
        c = sc*0.33;
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
        scatter3(model(:,1),model(:,2),model(:,3))
        %set(gca,'visible','off')
        F(ind) = getframe(gcf); %#ok<AGROW>
        ind=ind+1;
        clf('reset')
    end
end
all_valid = true;
flen = length(F);
for K = 1 : flen
    if isempty(F(K).cdata)
        all_valid = false;
        fprintf('Empty frame occurred at frame #%d of %d\n', K, flen);
    end
end
if ~all_valid
    error('Did not write movie because of empty frames')
end
%
open(V)
writeVideo(V,F)
close(V)
end

