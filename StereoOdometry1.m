function pose = StereoOdometry(bot,time)
 pose = [0 0 0 1 0 0 0 0 0]; % location dirn PRY
% v = 5;
% for img = 1000 : 1100
img = 1078;

Lt0 = imread(['D:\IMPORTANT\Project\MTLB - Stereovision 2\aritra\alice1\Alice1-' num2str(img) '.jpeg']);
Lt1 = imread(['D:\IMPORTANT\Project\MTLB - Stereovision 2\aritra\alice1\Alice1-' num2str(img+1) '.jpeg']);

Rt0 = imread(['D:\IMPORTANT\Project\MTLB - Stereovision 2\aritra\alice2\Alice2-' num2str(img) '.jpeg']);
Rt1 = imread(['D:\IMPORTANT\Project\MTLB - Stereovision 2\aritra\alice2\Alice2-' num2str(img+1) '.jpeg']);

% disp('Creating Stereo-Disparity Map at time t');
 ag = Stereovision(Lt0,Rt0);
% disp('Creating Stereo-Disparity Map at time t+1');
 bg = Stereovision(Lt1,Rt1);
% load('dispdat.mat');
% disp('Harris Corner Detect');
c1 = corner((Lt0(:,:,1)+Lt0(:,:,2)+Lt0(:,:,3))/3);
c2 = corner((Lt1(:,:,1)+Lt1(:,:,2)+Lt1(:,:,3))/3);

matchs = matchFeatures(c1,c2,'Metric','SSD');
slope = zeros(size(matchs,1),1);
lined = zeros(size(slope));
for i = 1:size(matchs,1)
    slope(i) = atand((c1(matchs(i,1),2)- size(Lt0,1)+c2(matchs(i,2),2))/(c1(matchs(i,1),1) - c2(matchs(i,2),1)));
    lined(i) = sqrt((c1(matchs(i,1),2)- size(Lt0,1)+c2(matchs(i,2),2))^2 + (c1(matchs(i,1),1) - c2(matchs(i,2),1))^2);
    if(slope(i)< 0)
        slope(i) = slope(i) + 180;
    end
end

figure(2)
join = [ag ; bg];
colormap summer
subplot(1,3,1)
imshow(join)
subplot(1,3,2)
imshow(zeros(size(Lt0)))
subplot(1,3,3)
imshow(zeros(15*50,size(Lt0,2)))

mc1 = c1(matchs(:,1),:); % pixel coordinates of matching feature points
dc1 = dist(mc1'); % euclidian distance between each matching feature points in image 1
mc2 = c2(matchs(:,2),:);
dc2 = dist(mc2');
avs = zeros(size(slope));
avl = zeros(size(slope));
count = 0;
pitch = [];
yaw = [];

for i = 1:size(matchs,1)
    matchs(i,1); % point in image 1
    neb = dc1(i,:) < 45; % neigbour feature points
    avs(i) = mean(slope(neb));
    avl(i) = mean(lined(neb));
        
    matchs(i,2); % point in image 1
    neb = dc2(i,:) < 45; % neigbour feature points
    avs(i) = (avs(i)+mean(slope(neb)))/2;
    avl(i) = (avl(i)+mean(lined(neb)))/2;
    
    if((abs(slope(i) - avs(i)) < 0.5))
        if( sqrt((c1(matchs(i,1),1)-c2(matchs(i,2),1))^2+(c1(matchs(i,1),2)-c2(matchs(i,2),2))^2) < 20)
            subplot(1,3,1)
            hold on
            plot(c1(matchs(i,1),1),c1(matchs(i,1),2),'or','MarkerSize',ag(c1(matchs(i,1),2),c1(matchs(i,1),1))+1);
            plot(c2(matchs(i,2),1),size(Lt0,1)+c2(matchs(i,2),2),'og','MarkerSize',bg(c2(matchs(i,2),2),c2(matchs(i,2),1))+1);
%             scatter(c2(matchs(i,2),1),size(Lt0,1)+c2(matchs(i,2),2),5,'r');
%             scatter(c1(matchs(i,1),1),c1(matchs(i,1),2),5,'r');
            line([c1(matchs(i,1),1) c2(matchs(i,2),1)],[c1(matchs(i,1),2) size(Lt0,1)+c2(matchs(i,2),2)]);
            
            count = count + 1;
            subplot(1,3,2)
            hold on
            diff = bg(c2(matchs(i,2),2),c2(matchs(i,2),1)) - ag(c1(matchs(i,1),2),c1(matchs(i,1),1));
            if(diff < 0) 
                plot(c1(matchs(i,1),1),c1(matchs(i,1),2),'sm','MarkerSize',abs(diff)*5+3);
            elseif(diff > 0) % came nearer
                plot(c1(matchs(i,1),1),c1(matchs(i,1),2),'sc','MarkerSize',abs(diff)*5+3); 
            end
%             plot(c1(matchs(i,1),1),c1(matchs(i,1),2),'or','MarkerSize',abs(diff)+1); 
%             scatter(c1(matchs(i,1),1),c1(matchs(i,1),2),5,'r');
            line([c1(matchs(i,1),1) c2(matchs(i,2),1)],[c1(matchs(i,1),2) c2(matchs(i,2),2)]);
            pitch = [pitch (c1(matchs(i,1),2)-c2(matchs(i,2),2))];
            yaw = [yaw (c1(matchs(i,1),1)-c2(matchs(i,2),1))];
            
            subplot(1,3,3)
            hold on
            plot(c1(matchs(i,1),1),(ag(c1(matchs(i,1),2),c1(matchs(i,1),1))+1)*50,'xr','MarkerSize',c1(matchs(i,1),2)/48);
            plot(c2(matchs(i,2),1),(bg(c2(matchs(i,2),2),c2(matchs(i,2),1))+1)*50,'xg','MarkerSize',c2(matchs(i,2),2)/48);
            line([c1(matchs(i,1),1) c2(matchs(i,2),1)],[(ag(c1(matchs(i,1),2),c1(matchs(i,1),1))+1)*50 (bg(c2(matchs(i,2),2),c2(matchs(i,2),1))+1)*50]);
            finals(count,:) = [c1(matchs(i,1),1) c1(matchs(i,1),2) c2(matchs(i,2),1) c2(matchs(i,2),2)];
            finals1(count,:) = [c1(matchs(i,1),1) (ag(c1(matchs(i,1),2),c1(matchs(i,1),1))+1)*50 c2(matchs(i,2),1) (bg(c2(matchs(i,2),2),c2(matchs(i,2),1))+1)*50];
        end
    end
end
% refline(polyfit(finals(:,1),finals(:,2),1))
% refline(polyfit(finals(:,3),finals(:,4),1))

p = polyfit(finals(:,1),finals(:,2),7);
for i = 1:size(Lt0,2)
    y = 0;
    for j = 1:size(p,2)
        y = y + p(j)*i.^(size(p)-j);
    end
    plot(i,y,'-r')
%     plot(i,p(1)*i.^2 + p(2)*i + p(3))
end

p = polyfit(finals(:,3),finals(:,4),7);
for i = 1:size(Lt0,2)
    y = 0;
    for j = 1:size(p,2)
        y = y + p(j)*i.^(size(p)-j);
    end
    plot(i,y,'-g')
%     plot(i,p(1)*i.^2 + p(2)*i + p(3))
end

disp(['Number of Final Match Points ' num2str(count)]);
% pitch = sum(pitch) / count
pitch = trimmean(pitch,50);
% disp(['Pitch ' num2str(pitch)]);
% yaw = sum(yaw) / count
yaw = trimmean(yaw,50);
% disp(['Yaw ' num2str(yaw)]);
% Localization
% pitch yaw <-- no roll needed for monocular 
end