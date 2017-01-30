function [alpha beta gamma] = StereoOdometry3(bot,time,pose,ag,bg)

% time = 30;
% pose = [0 0 0 0 0 0 0 0 ];
% ag = imread(strcat('F:\Dataset1\','I1','_',sprintf('%6.6d',25),'.png'));
% bg = imread(strcat('F:\Dataset1\','I1','_',sprintf('%6.6d',26),'.png'));

%  pose = [0 0 0 1 0 0 0 0 0]; % location dirn PRY
% v = 5;
% for img = 1000 : 1100
% img = 1078;

%     path = 'F:\Dataset1\';
%     Lt0 = imread(strcat(path,'I1','_',sprintf('%6.6d',time),'.png'));
%     Lt1 = imread(strcat(path,'I1','_',sprintf('%6.6d',time+1),'.png'));
%     
%     Rt0 = imread(strcat(path,'I2','_',sprintf('%6.6d',time),'.png'));
%     Rt1 = imread(strcat(path,'I2','_',sprintf('%6.6d',time+1),'.png'));

% disp('Creating Stereo-Disparity Map at time t');
% ag = Stereovision(Lt0,Rt0);
% disp('Creating Stereo-Disparity Map at time t+1');
% bg = Stereovision(Lt1,Rt1);

c1 = corner(ag,2000);
c2 = corner(bg,2000);
matchs = matchFeatures(c1,c2,'Metric','SSD');
slope = zeros(size(matchs,1),1);
lined = zeros(size(slope));
for i = 1:size(matchs,1)
    slope(i) = atand((c1(matchs(i,1),2)- size(ag,1)-c2(matchs(i,2),2))/(c1(matchs(i,1),1) - c2(matchs(i,2),1)));       % Slope angle between matches
    lined(i) = sqrt((c1(matchs(i,1),2)- size(ag,1)-c2(matchs(i,2),2))^2 + (c1(matchs(i,1),1) - c2(matchs(i,2),1))^2);  % Line distance between matches
    if(slope(i)< 0)
        slope(i) = slope(i) + 180;
    end
end

% TEST CODE
pitch_test = [];
yaw_test = [];
trans_test = [];
figure(3)
join = [ag ; bg];
subplot(1,2,1)
% hstslp = hist(slope',[0:18:180]);
hstslp = histc(slope',[0:10:180]);
hstnew = zeros(1,19);
for i=2 : 18
hstnew(i) = sum(hstslp(i-1:i+1))/3;
end
hstslp = hstnew;
% plot(hstslp);

imshow([ag;bg],[0 255])
for i = 1:size(matchs,1)
    line([c1(matchs(i,1),1) c2(matchs(i,2),1)],[c1(matchs(i,1),2) size(ag,1)+c2(matchs(i,2),2)]);
end
[~,jj] = findpeaks(hstslp,'SORTSTR','descend','NPEAKS',1);
subplot(1,2,2) % best global consensus
imshow(join,[0 255])
count_test = 0;
% jj=jj+2;
for i = 1:size(matchs,1)
    
    if(abs(slope(i)-jj*10)<2 )%&& abs(c1(matchs(i,1),2)-c2(matchs(i,2),2)) < 3)
        line([c1(matchs(i,1),1) c2(matchs(i,2),1)],[c1(matchs(i,1),2) size(ag,1)+c2(matchs(i,2),2)]); 
        pitch_test = [pitch_test (c1(matchs(i,1),2)-c2(matchs(i,2),2))];
        yaw_test = [yaw_test (c1(matchs(i,1),1)-c2(matchs(i,2),1))]; 
        trans_test = [trans_test ag(c1(matchs(i,1),2),c1(matchs(i,1),1))-bg(c2(matchs(i,2),2),c2(matchs(i,2),1))];
        
        count_test = count_test + 1;
        x1(count_test,:) =  [c1(matchs(i,1),1) c1(matchs(i,1),2) ag(c1(matchs(i,1),2),c1(matchs(i,1),1))];
        x2(count_test,:) =  [c2(matchs(i,2),1) c2(matchs(i,2),2) bg(c2(matchs(i,2),2),c2(matchs(i,2),1))];
    end
end
disp(['Number of Final Match Points ' num2str(count_test)]);
pitch_testm = mean(pitch_test);
yaw_testm = mean(yaw_test);
trans_testm = -mean(trans_test);

if (yaw_testm > 3)
    yaw_testm = 3;
elseif (yaw_testm < -3)
    yaw_testm = -3;
end
if (count_test < 5)
    yaw_testm = pose(8)/2;
end
disp(['Timestamp   : ' num2str(time+1)]);
disp(['Pitch       : ' num2str(pitch_testm)]);
disp(['Yaw         : ' num2str(yaw_testm)]);
disp(['Translation : ' num2str(trans_testm)]);

[H nmax]=computeHomography(x1(:,1:2)',x2(:,1:2)',10,1);
[R t s]=computeOrientation(x1',x2','absolute');
if(R(1,1)~=0 && R(3,3)~=0)
    alpha = atan(R(2,1)/R(1,1));
    beta = atan(-R(3,1)/sqrt(R(3,2)^2 + R(3,3)^2));
    gamma = atan(R(3,2)/R(3,3));
    disp(['Pitch         : ' num2str(beta)]);
    disp(['Roll          : ' num2str(gamma)]);
    disp(['Yaw           : ' num2str(alpha)]);
    disp(['Translation   : ' num2str(t(1)) 'i + ' num2str(t(2)) 'j + ' num2str(t(3)) 'k']);
    
else
    disp('YPR Angles cannot be calculated');
end

end