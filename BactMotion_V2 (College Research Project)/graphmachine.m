function [] = graphmachine(T,newB,C_height,C_vel,Zangle,Yangle,angularvZ,angularvY)

%Average angle vs height (+/- dh) for bacteria falling towards the surface
figure()
title('Average angle_Z vs height from surface, negative Vz (0.1 {\mu}m range)')
ylabel('Angle (degrees)')
xlabel('Height of c.o.m from surface ({\mu}m)')
hold on
mh=0;
Mh=0.1;
longang=zeros();
longh=zeros();
err=zeros();
id2=1;
for in = 0:0.1:1
    tang = zeros();
    th = zeros();
    id=1;
    for l = 1 : length(newB(:,1))
        for t = 1 : T
            if C_height(l,t) < Mh && C_height(l,t) >= mh
                if isempty(C_vel{l,t}) == false
                    if C_vel{l,t}(3) < 0
                        tang(id)=Zangle(l,t);
                        th(id) = (Mh+mh)/2;
                        id=id+1;
                    end
                end
            end
        end
    end
    longang(id2)=mean(tang);
    longh(id2)=mean(th);
    err(id2)=std(tang)/sqrt(length(tang));
    id2=id2+1;
    mh=in;
    Mh=in+0.1;
end
%scatter(longh,longang,50,'d','black','filled')
errorbar(longh,longang,err,'ok')


%%%%%


figure()
title('Average {\omega}_{Vertical} vs height from surface, negative Vz (0.1 {\mu}m range)')
ylabel('{\omega}_{Vertical} (degrees / 0.01seconds)')
xlabel('Height of c.o.m from surface ({\mu}m)')
hold on
mh=0;
Mh=0.1;
longang=zeros();
longh=zeros();
err=zeros();
id2=1;
for in = 0:0.1:1
    tang = zeros();
    th = zeros();
    id=1;
    for l = 1 : length(newB(:,1))
        for t = 1 : T
            if C_height(l,t) < Mh && C_height(l,t) >= mh
                if isempty(C_vel{l,t}) == false
                    if C_vel{l,t}(3) < 0
                        tang(id)=angularvZ(l,t);
                        th(id) = (Mh+mh)/2;
                        id=id+1;
                    end
                end
            end
        end
    end
    longang(id2)=mean(tang);
    longh(id2)=mean(th);
    err(id2)=std(tang)/sqrt(length(tang));
    id2=id2+1;
    mh=in;
    Mh=in+0.1;
end
%scatter(longh,longang,50,'d','black','filled')
errorbar(longh,longang,err,'ok')





%This plot shows the full ensemble in angle vs height (ok only bacteria
%moving down), and then selects specific regions and looks at the average
%angle vs height for the bacteria that move downwards starting in those
%regions
figure()
subplot(2,1,1)
rx1=0.4:.01:0.6;
ry=5:.1:15;
title('Angle_Z vs height all bact, moving down')%,num2str(min(ry)),'-',num2str(max(ry)),'°, ',num2str(min(rx)),'-',num2str(max(rx)),'h'])
xlabel('Height of c.o.m from Surface ({\mu}m)')
ylabel('Angle relative to surface (degrees)')
hold on
ang = zeros();
hei = zeros();
interest1=cell(1,1);
ind = 1;
ind2=1;
for b = 1 : length(newB(:,1))
    for t = 1 : T
        if Zangle(b,t) ~= 0
            ang(ind)=Zangle(b,t);
            hei(ind)=C_height(b,t);
            if Zangle(b,t) < max(ry) && Zangle(b,t) > min(ry)
                if C_height(b,t) <=max(rx1) && C_height(b,t) >=min(rx1)
                    if isempty(C_vel{b,t}) == false
                        if C_vel{b,t}(3) < 0
                            interest1{ind2}=[b t];
                            ind2=ind2+1;
                        end
                    end
                end
            end
            ind=ind+1;
        end
    end
end
scatter(hei,ang,8,'o','black','filled')
plot(rx1, (max(ry))*(ones(size(rx1))),'-r','LineWidth',1)
plot(rx1, (min(ry))*(ones(size(rx1))),'-r','LineWidth',1)
plot((min(rx1))*(ones(size(ry))),ry,'-r','LineWidth',1)
plot((max(rx1))*(ones(size(ry))),ry,'-r','LineWidth',1)
%
rx=0.6:.01:0.8;
ry=25:.1:35;
ang = zeros();
hei = zeros();
interest2=cell(1,1);
ind = 1;
ind2=1;
for b = 1 : length(newB(:,1))
    for t = 1 : T
        if Zangle(b,t) ~= 0
            ang(ind)=Zangle(b,t);
            hei(ind)=C_height(b,t);
            if Zangle(b,t) < max(ry) && Zangle(b,t) > min(ry)
                if C_height(b,t) <=max(rx) && C_height(b,t) >=min(rx)
                    if isempty(C_vel{b,t}) == false
                        if C_vel{b,t}(3) < 0
                            interest2{ind2}=[b t];
                            ind2=ind2+1;
                        end
                    end
                end
            end
            ind=ind+1;
        end
    end
end
plot(rx, (max(ry))*(ones(size(rx))),'-b','LineWidth',1)
plot(rx, (min(ry))*(ones(size(rx))),'-b','LineWidth',1)
plot((min(rx))*(ones(size(ry))),ry,'-b','LineWidth',1)
plot((max(rx))*(ones(size(ry))),ry,'-b','LineWidth',1)
%
hold off
subplot(2,1,2)
title('Averaged angle_Z vs height, falling bact in region')
xlabel('Height of c.o.m from Surface ({\mu}m)')
ylabel('Angle relative to surface (degrees)')
hold on
for r = 0:0.1:1.1
    mh=0+r;
    Mh=0.1+r;
    ind=1;
    tempval=zeros();
    tempval(:)=NaN;
    for b = 1 : length(interest1)
        for t = interest1{b}(2) : T
            if isempty(C_vel{interest1{b}(1),t}) == false && C_vel{interest1{b}(1),t}(3) < 0
                if C_height(interest1{b}(1),t) < Mh && C_height(interest1{b}(1),t) >= mh && C_height(interest1{b}(1),t) <= max(rx1)
                    tempval(ind) = Zangle(interest1{b}(1),t);
                    ind=ind+1;
                end
            end
        end
    end
    err=std(tempval)/sqrt(length(tempval));
    errorbar(((mh+Mh)/2),mean(tempval),err,'or')
end
%
for r = 0:0.1:1.1
    mh=0+r;
    Mh=0.1+r;
    ind=1;
    tempval=zeros();
    tempval(:)=NaN;
    for b = 1 : length(interest2)
        for t = interest2{b}(2) : T
            if isempty(C_vel{interest2{b}(1),t}) == false && C_vel{interest2{b}(1),t}(3) < 0
                if C_height(interest2{b}(1),t) < Mh && C_height(interest2{b}(1),t) >= mh&& C_height(interest2{b}(1),t) <= max(rx)
                    tempval(ind) = Zangle(interest2{b}(1),t);
                    ind=ind+1;
                end
            end
        end
    end
    err=std(tempval/sqrt(length(tempval)));
    errorbar(((mh+Mh)/2),mean(tempval),err,'ob')
end















%This plot shows the delta-theta_z versus height for the ensemble of
%bacteria that are moving down
%%%%%
figure()
subplot(2,1,1)
rx1=0.5:.01:0.7;
ry=5:.1:15;
title('Angle_Z vs height all bact, moving down')%,num2str(min(ry)),'-',num2str(max(ry)),'°, ',num2str(min(rx)),'-',num2str(max(rx)),'h'])
xlabel('Height of c.o.m from Surface ({\mu}m)')
ylabel('Angle relative to surface (degrees)')
hold on
ang = zeros();
hei = zeros();
interest1=cell(1,1);
ind = 1;
ind2=1;
for b = 1 : length(newB(:,1))
    for t = 1 : T
        if Zangle(b,t) ~= 0
            ang(ind)=Zangle(b,t);
            hei(ind)=C_height(b,t);
            if Zangle(b,t) < max(ry) && Zangle(b,t) > min(ry)
                if C_height(b,t) <max(rx1) && C_height(b,t) >=min(rx1)
                    if isempty(C_vel{b,t}) == false
                        if C_vel{b,t}(3) < 0
                            interest1{ind2}=[b t];
                            ind2=ind2+1;
                        end
                    end
                end
            end
            ind=ind+1;
        end
    end
end
scatter(hei,ang,8,'o','black','filled')
plot(rx1, (max(ry))*(ones(size(rx1))),'-r','LineWidth',1)
plot(rx1, (min(ry))*(ones(size(rx1))),'-r','LineWidth',1)
plot((min(rx1))*(ones(size(ry))),ry,'-r','LineWidth',1)
plot((max(rx1))*(ones(size(ry))),ry,'-r','LineWidth',1)
%
rx=0.5:.01:0.7;
ry=20:.1:30;
ang = zeros();
hei = zeros();
interest2=cell(1,1);
ind = 1;
ind2=1;
for b = 1 : length(newB(:,1))
    for t = 1 : T
        if Zangle(b,t) ~= 0
            ang(ind)=Zangle(b,t);
            hei(ind)=C_height(b,t);
            if Zangle(b,t) < max(ry) && Zangle(b,t) > min(ry)
                if C_height(b,t) <max(rx) && C_height(b,t) >=min(rx)
                    if isempty(C_vel{b,t}) == false
                        if C_vel{b,t}(3) < 0
                            interest2{ind2}=[b t];
                            ind2=ind2+1;
                        end
                    end
                end
            end
            ind=ind+1;
        end
    end
end
plot(rx, (max(ry))*(ones(size(rx))),'-b','LineWidth',1)
plot(rx, (min(ry))*(ones(size(rx))),'-b','LineWidth',1)
plot((min(rx))*(ones(size(ry))),ry,'-b','LineWidth',1)
plot((max(rx))*(ones(size(ry))),ry,'-b','LineWidth',1)
%
hold off
subplot(2,1,2)
title('Averaged {\omega}_{Vertical} vs height, falling bact in region')
xlabel('Height of c.o.m from Surface ({\mu}m)')
ylabel('{\omega}_{Vertical} (degrees per 0.01 seconds)')
hold on
for r = 0:0.1:1.1
    mh=0+r;
    Mh=0.1+r;
    ind=1;
    tempval=zeros();
    tempval(:)=NaN;
    for b = 1 : length(interest1)
        for t = interest1{b}(2) : T
            if isempty(C_vel{interest1{b}(1),t}) == false && C_vel{interest1{b}(1),t}(3) < 0 && angularvZ(interest1{b}(1),t) ~= 0
                if C_height(interest1{b}(1),t) < Mh && C_height(interest1{b}(1),t) >= mh && C_height(interest1{b}(1),t) <= max(rx1)
                    tempval(ind) = angularvZ(interest1{b}(1),t);
                    ind=ind+1;
                end
            end
        end
    end
    err=std(tempval)/sqrt(length(tempval));
    errorbar(((mh+Mh)/2),mean(tempval),err,'or')
end
%
for r = 0:0.1:1.1
    mh=0+r;
    Mh=0.1+r;
    ind=1;
    tempval=zeros();
    tempval(:)=NaN;
    for b = 1 : length(interest2)
        for t = interest2{b}(2) : T
            if isempty(C_vel{interest2{b}(1),t}) == false && C_vel{interest2{b}(1),t}(3) < 0 && angularvZ(interest2{b}(1),t) ~= 0
                if C_height(interest2{b}(1),t) < Mh && C_height(interest2{b}(1),t) >= mh&& C_height(interest2{b}(1),t) <= max(rx)
                    tempval(ind) = angularvZ(interest2{b}(1),t);
                    ind=ind+1;
                end
            end
        end
    end
    err=std(tempval/sqrt(length(tempval)));
    errorbar(((mh+Mh)/2),mean(tempval),err,'ob')
end


%%%%%


figure()
subplot(2,1,1)
rx1=0.5:.01:0.7;
ry=5:.1:15;
title('Angle_Z vs height all bact, moving down')%,num2str(min(ry)),'-',num2str(max(ry)),'°, ',num2str(min(rx)),'-',num2str(max(rx)),'h'])
xlabel('Height of c.o.m from Surface ({\mu}m)')
ylabel('Angle relative to surface (degrees)')
hold on
ang = zeros();
hei = zeros();
interest1=cell(1,1);
ind = 1;
ind2=1;
for b = 1 : length(newB(:,1))
    for t = 1 : T
        if Zangle(b,t) ~= 0
            ang(ind)=Zangle(b,t);
            hei(ind)=C_height(b,t);
            if Zangle(b,t) < max(ry) && Zangle(b,t) > min(ry)
                if C_height(b,t) <max(rx1) && C_height(b,t) >=min(rx1)
                    if isempty(C_vel{b,t}) == false
                        if C_vel{b,t}(3) < 0
                            interest1{ind2}=[b t];
                            ind2=ind2+1;
                        end
                    end
                end
            end
            ind=ind+1;
        end
    end
end
scatter(hei,ang,8,'o','black','filled')
plot(rx1, (max(ry))*(ones(size(rx1))),'-r','LineWidth',1)
plot(rx1, (min(ry))*(ones(size(rx1))),'-r','LineWidth',1)
plot((min(rx1))*(ones(size(ry))),ry,'-r','LineWidth',1)
plot((max(rx1))*(ones(size(ry))),ry,'-r','LineWidth',1)
%
rx=0.5:.01:0.7;
ry=20:.1:30;
ang = zeros();
hei = zeros();
interest2=cell(1,1);
ind = 1;
ind2=1;
for b = 1 : length(newB(:,1))
    for t = 1 : T
        if Zangle(b,t) ~= 0
            ang(ind)=Zangle(b,t);
            hei(ind)=C_height(b,t);
            if Zangle(b,t) < max(ry) && Zangle(b,t) > min(ry)
                if C_height(b,t) <max(rx) && C_height(b,t) >=min(rx)
                    if isempty(C_vel{b,t}) == false
                        if C_vel{b,t}(3) < 0
                            interest2{ind2}=[b t];
                            ind2=ind2+1;
                        end
                    end
                end
            end
            ind=ind+1;
        end
    end
end
plot(rx, (max(ry))*(ones(size(rx))),'-b','LineWidth',1)
plot(rx, (min(ry))*(ones(size(rx))),'-b','LineWidth',1)
plot((min(rx))*(ones(size(ry))),ry,'-b','LineWidth',1)
plot((max(rx))*(ones(size(ry))),ry,'-b','LineWidth',1)
%
hold off
subplot(2,1,2)
title('Averaged {\omega}_{Lateral} vs height, falling bact in region')
hold on
for r = 0:0.1:1.1
    mh=0+r;
    Mh=0.1+r;
    ind=1;
    tempval=zeros();
    tempval(:)=NaN;
    for b = 1 : length(interest1)
        for t = interest1{b}(2) : T
            if isempty(C_vel{interest1{b}(1),t}) == false && C_vel{interest1{b}(1),t}(3) < 0
                if C_height(interest1{b}(1),t) < Mh && C_height(interest1{b}(1),t) >= mh && C_height(interest1{b}(1),t) <= max(rx1)
                    tempval(ind) = angularvY(interest1{b}(1),t);
                    ind=ind+1;
                end
            end
        end
    end
    err=std(tempval)/sqrt(length(tempval));
    errorbar(((mh+Mh)/2),mean(tempval),err,'or')
end
%
for r = 0:0.1:1.1
    mh=0+r;
    Mh=0.1+r;
    ind=1;
    tempval=zeros();
    tempval(:)=NaN;
    for b = 1 : length(interest2)
        for t = interest2{b}(2) : T
            if isempty(C_vel{interest2{b}(1),t}) == false && C_vel{interest2{b}(1),t}(3) < 0
                if C_height(interest2{b}(1),t) < Mh && C_height(interest2{b}(1),t) >= mh&& C_height(interest2{b}(1),t) <= max(rx)
                    tempval(ind) = angularvY(interest2{b}(1),t);
                    ind=ind+1;
                end
            end
        end
    end
    err=std(tempval/sqrt(length(tempval)));
    errorbar(((mh+Mh)/2),mean(tempval),err,'ob')
end


%%%%%


%%%Average velocity versus height
figure()
title('Average Lateral Speed vs height from surface(0.1{\mu}m range)')
xlabel('Distance of c.o.m from Surface ({\mu}m)')
ylabel('Averaged Lateral Speed ({\mu}m/0.01 seconds)')
hold on
mh=0;
Mh=0.1;
longang=zeros();
longh=zeros();
err=zeros();
id2=1;
for in = 0:0.1:0.9
    tang = zeros();
    th = zeros();
    id=1;
    for l = 1 : length(newB(:,1))
        for t = 1 : T
            if C_height(l,t) <= Mh && C_height(l,t) >= mh
                if isempty(C_vel{l,t}) == false
                    if C_vel{l,t}(3) < 0
                        tang(id)=sqrt((C_vel{l,t}(1))^2 + (C_vel{l,t}(2))^2); %+(C_vel{l,t}(3))^2);
                        th(id) = (Mh+mh)/2;
                        id=id+1;
                    end
                end
            end
        end
    end
    id=id-1;
    longang(id2)=mean(tang);
    longh(id2)=mean(th);
    err(id2)=std(tang)/sqrt(length(tang));
    id2=id2+1;
    mh=in;
    Mh=in+0.1;
end
errorbar(longh,longang,err,'ok')


%%%%%


figure()
title('Average Vertical Speed vs height from surface (0.1{\mu}m range)')
xlabel('Distance of c.o.m from Surface ({\mu}m)')
ylabel('Averaged Vertical Speed ({\mu}m / 0.01 seconds)')
hold on
mh=0;
Mh=0.1;
longang=zeros();
longh=zeros();
err=zeros();
id2=1;
for in = 0:0.1:0.9
    tang = zeros();
    th = zeros();
    id=1;
    for l = 1 : length(newB(:,1))
        for t = 1 : T
            if C_height(l,t) <= Mh && C_height(l,t) >= mh
                if isempty(C_vel{l,t}) == false
                    if C_vel{l,t}(3) < 0
                        tang(id)=sqrt((C_vel{l,t}(3))^2);
                        th(id) = (Mh+mh)/2;
                        id=id+1;
                    end
                end
            end
        end
    end
    id=id-1;
    longang(id2)=mean(tang);
    longh(id2)=mean(th);
    err(id2)=std(tang)/sqrt(length(tang));
    id2=id2+1;
    mh=in;
    Mh=0.1+in;
end
ylim([0 0.2])
errorbar(longh,longang,err,'ok')



% figure()
% minang=30;
% maxang=50;
% title(['total speed vs height,', num2str(minang),'-',num2str(maxang),'°'])
% hold on
% speed = zeros();
% hei = zeros();
% ind = 1;
% for b = 1 : length(newB(:,1))
%     for t = 1 : 500
%         if Zangle(b,t) <= maxang
%             if Zangle(b,t) >= minang
%                 if isempty(C_vel{b,t}) == false && C_vel{b,t}(3) < 0
%                     speed(ind)=sqrt((C_vel{b,t}(1))^2 + (C_vel{b,t}(2))^2 + ((15.3)*C_vel{b,t}(3))^2);
%                     hei(ind)=C_height(b,t);
%                     if speed(ind)==0
%                         speed(ind)=[];
%                         hei(ind)=[];
%                         ind=ind-1;
%                     end
%                     ind=ind+1;
%                 end
%             end
%         end
%     end
% end
% scatter(hei,speed)

%%%%%

% figure()
% subplot(2,1,1)
% rx1=0.7:.01:0.8;
% ry=5:.1:25;
% title('{\omega}_{Vertical} vs height all bact, moving down')
% xlabel('Height of c.o.m from Surface ({\mu}m)')
% ylabel('{\omega}_{Vertical} (degrees / 0.01 seconds)')
% hold on
% ang = zeros();
% hei = zeros();
% interest1=cell(1,1);
% ind = 1;
% ind2=1;
% for b = 1 : length(newB(:,1))
%     for t = 1 : T
%         if Zangle(b,t) ~= 0 && angularvZ(b,t) ~= 0
%             ang(ind)=angularvZ(b,t);
%             hei(ind)=C_height(b,t);
%             
%             if abs(angularvZ(b,t)) < max(ry) && abs(angularvZ(b,t)) > min(ry)
%                 if C_height(b,t) <=max(rx1) && C_height(b,t) >=min(rx1)
%                     if isempty(C_vel{b,t}) == false
%                         if C_vel{b,t}(3) < 0
%                             interest1{ind2}=[b t];
%                             ind2=ind2+1;
%                         end
%                     end
%                 end
%             end
%             ind=ind+1;
%         end
%     end
% end
% scatter(hei,ang,8,'o','black','filled')
% plot(rx1, (max(ry))*(ones(size(rx1))),'-r','LineWidth',1)
% plot(rx1, (min(ry))*(ones(size(rx1))),'-r','LineWidth',1)
% plot((min(rx1))*(ones(size(ry))),ry,'-r','LineWidth',1)
% plot((max(rx1))*(ones(size(ry))),ry,'-r','LineWidth',1)
% %%%%%
% rx=0.5:.01:0.6;
% ry=-20:.1:0;
% ang = zeros();
% hei = zeros();
% interest2=cell(1,1);
% ind = 1;
% ind2=1;
% for b = 1 : length(newB(:,1))
%     for t = 1 : T
%         if Zangle(b,t) ~= 0 && angularvZ(b,t) ~= 0
%             ang(ind)=angularvZ(b,t);
%             hei(ind)=C_height(b,t);
%             
%             if angularvZ(b,t) < max(ry) && angularvZ(b,t) > min(ry)
%                 if C_height(b,t) <=max(rx) && C_height(b,t) >=min(rx)
%                     if isempty(C_vel{b,t}) == false
%                         if C_vel{b,t}(3) < 0
%                             interest2{ind2}=[b t];
%                             ind2=ind2+1;
%                         end
%                     end
%                 end
%             end
%             ind=ind+1;
%         end
%     end
% end
% plot(rx, (max(ry))*(ones(size(rx))),'-b','LineWidth',1)
% plot(rx, (min(ry))*(ones(size(rx))),'-b','LineWidth',1)
% plot((min(rx))*(ones(size(ry))),ry,'-b','LineWidth',1)
% plot((max(rx))*(ones(size(ry))),ry,'-b','LineWidth',1)
% hold off
% subplot(2,1,2)
% title('{\omega}_{Vertical} vs height of region')
% % xlabel('Height of c.o.m from Surface ({\mu}m)')
% % ylabel('change in theta_z (degrees/0.01 seconds)')
% hold on
% for r = 0:0.1:1.1
%     mh=0+r;
%     Mh=0.1+r;
%     ind=1;
%     tempval=zeros();
%     tempval(:)=NaN;
%     for b = 1 : length(interest1)
%         for t = interest1{b}(2) : T
%             if isempty(C_vel{interest1{b}(1),t}) == false && C_vel{interest1{b}(1),t}(3) < 0
%                 if C_height(interest1{b}(1),t) <= Mh && C_height(interest1{b}(1),t) >= mh && C_height(interest1{b}(1),t) < max(rx1)
%                     tempval(ind) = angularvZ(interest1{b}(1),t);
%                     ind=ind+1;
%                 end
%             end
%         end
%     end
%     err=std(tempval)/sqrt(length(tempval));
%     errorbar(((mh+Mh)/2),mean(tempval),err,'or')
% end
% %%%%%
% for r = 0:0.1:1.1
%     mh=0+r;
%     Mh=0.1+r;
%     ind=1;
%     tempval=zeros();
%     tempval(:)=NaN;
%     for b = 1 : length(interest2)
%         for t = interest2{b}(2) : T
%             if isempty(C_vel{interest2{b}(1),t}) == false && C_vel{interest2{b}(1),t}(3) < 0
%                 if C_height(interest2{b}(1),t) <= Mh && C_height(interest2{b}(1),t) >= mh && C_height(interest2{b}(1),t) < max(rx)
%                     tempval(ind) = angularvZ(interest2{b}(1),t);
%                     ind=ind+1;
%                 end
%             end
%         end
%     end
%     err=std(tempval)/sqrt(length(tempval)); %max(tempval)-min(tempval);
%     errorbar(((mh+Mh)/2),mean(tempval),err,'ob')
% end

%%%%%%

%This plot shows the delta-theta_Y versus height for the ensemble of
%bacteria that are moving down
% figure()
% subplot(2,1,1)
% rx=0.6:.01:0.7;
% ry=0:.1:60;
% title('{\omega}_{Lateral} vs height all bact')
% xlabel('Height of c.o.m from Surface ({\mu}m)')
% ylabel('{\omega}_{Lateral} (degrees / 0.01seconds)')
% hold on
% ang = zeros();
% hei = zeros();
% interest1=cell(1,1);
% ind = 1;
% ind2=1;
% for b = 1 : length(newB(:,1))
%     for t = 1 : T
%         if Yangle(b,t) ~= 0 && angularvZ(b,t) ~= 0
%             ang(ind)=angularvY(b,t);
%             hei(ind)=C_height(b,t);
%             
%             if angularvY(b,t) < max(ry) && angularvY(b,t) > min(ry)
%                 if C_height(b,t) <=max(rx) && C_height(b,t) >=min(rx)
%                     if isempty(C_vel{b,t}) == false
%                         if C_vel{b,t}(3) < 0
%                             interest1{ind2}=[b t];
%                             ind2=ind2+1;
%                         end
%                     end
%                 end
%             end
%             ind=ind+1;
%         end
%     end
% end
% scatter(hei,ang,8,'o','black','filled')
% plot(rx, (max(ry))*(ones(size(rx))),'-r','LineWidth',1)
% plot(rx, (min(ry))*(ones(size(rx))),'-r','LineWidth',1)
% plot((min(rx))*(ones(size(ry))),ry,'-r','LineWidth',1)
% plot((max(rx))*(ones(size(ry))),ry,'-r','LineWidth',1)
% %%%%%
% rx=0.4:.01:0.5;
% ry=-60:.1:-10;
% ang = zeros();
% hei = zeros();
% interest2=cell(1,1);
% ind = 1;
% ind2=1;
% for b = 1 : length(newB(:,1))
%     for t = 1 : T
%         if Yangle(b,t) ~= 0 && angularvY(b,t) ~= 0
%             ang(ind)=angularvY(b,t);
%             hei(ind)=C_height(b,t);
%             
%             if angularvY(b,t) < max(ry) && angularvY(b,t) > min(ry)
%                 if C_height(b,t) <=max(rx) && C_height(b,t) >=min(rx)
%                     if isempty(C_vel{b,t}) == false
%                         if C_vel{b,t}(3) < 0
%                             interest2{ind2}=[b t];
%                             ind2=ind2+1;
%                         end
%                     end
%                 end
%             end
%             ind=ind+1;
%         end
%     end
% end
% plot(rx, (max(ry))*(ones(size(rx))),'-b','LineWidth',1)
% plot(rx, (min(ry))*(ones(size(rx))),'-b','LineWidth',1)
% plot((min(rx))*(ones(size(ry))),ry,'-b','LineWidth',1)
% plot((max(rx))*(ones(size(ry))),ry,'-b','LineWidth',1)
% hold off
% subplot(2,1,2)
% title('{\omega}_{Lateral} vs height of region')
% % xlabel('Height of c.o.m from Surface ({\mu}m)')
% % ylabel('\Delta-theta_Y (degrees/0.01seconds)')
% hold on
% for r = 0:0.1:1.1
%     mh=0+r;
%     Mh=0.1+r;
%     ind=1;
%     tempval=zeros();
%     tempval(:)=NaN;
%     for b = 1 : length(interest1)
%         for t = interest1{b}(2) : T
%             if isempty(C_vel{interest1{b}(1),t}) == false && C_vel{interest1{b}(1),t}(3) > 0
%                 if C_height(interest1{b}(1),t) <= Mh && C_height(interest1{b}(1),t) >= mh
%                     tempval(ind) = angularvY(interest1{b}(1),t);
%                     ind=ind+1;
%                 end
%             end
%         end
%     end
%     err=std(tempval);
%     errorbar(((mh+Mh)/2),mean(tempval),err,'or')
% end
% %%%%%
% for r = 0:0.1:1.1
%     mh=0+r;
%     Mh=0.1+r;
%     ind=1;
%     tempval=zeros();
%     tempval(:)=NaN;
%     for b = 1 : length(interest2)
%         for t = interest2{b}(2) : T
%             if isempty(C_vel{interest2{b}(1),t}) == false && C_vel{interest2{b}(1),t}(3) > 0
%                 if C_height(interest2{b}(1),t) <= Mh && C_height(interest2{b}(1),t) >= mh
%                     tempval(ind) = angularvY(interest2{b}(1),t);
%                     ind=ind+1;
%                 end
%             end
%         end
%     end
%     err=std(tempval)/sqrt(length(tempval));
%     errorbar(((mh+Mh)/2),mean(tempval),err,'ob')
% end
end

