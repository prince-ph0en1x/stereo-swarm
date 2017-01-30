% ALGORITHM

% For each time step
%   For each Scout Robot

%       Read sent stereoimages from defined folder with next time stamp
%       Rectify images
%       Process stereo images, create local elevation map
%       Intregate local elevation map in Global Elevation Map based on position,orientation of bot
%       Process local mapped terrain and give commands for next movement
%       Calculate odometric/deadreckoning movement
%   Move Beacon Robot
%   Update global coordinates, orientations of all Robots
% Goto next time step unless map region > required area

% IMPLEMENTATION

% Constants
nbots = 1;  % Number of scout bots
max_area = 1000000; % Total database size to be built

%   Initializations
pose = [1 0 0 1 0 0 0 0 0   % Orientation vector --> (Previous - Current) Position 
        0 1 0 0 1 0 0 0 0   % (nbots+1,9) --> (x,y,z),(orientation vector),(pitch,roll,yaw) for each robot
        0 0 0 1 0 0 0 0 0]; % last row --> Beacon Bot
current_area = 0;   % Current mapped area
time = 0; % ** If LR coorelation is too low, repeat time snapshot

while(current_area < max_area)                      % For each time step unless map region > required area
    for bot = 1 : nbots                                 %   For each Scout Robot
        tic
        disp('Reading Image Pair');
        [img_L img_R] = ReadImgPair(bot,time);               %   Read sent stereoimages from defined folder with next time stamp
        disp('Rectifying Images');
        [rectified_L,rectified_R] = Rectify(img_L,img_R);   %   Rectify images
        disp('Create Disparity Map');
        [localMap] = Stereovision(rectified_L,rectified_R); %   Process stereo images, create local elevation map
        
        figure(1)
        mesh(im2double(localMap),'FaceColor','interp','FaceLighting','phong')
        camlight headlight
        
        disp('Update Global Map');
        UpdateGMap(localMap,pose(bot,:));                   %   Intregate local elevation map in Global Elevation Map based on position,orientation of bot
        disp('Find Region of Interest');
        [reqd_pose] = FindROI(bot,pose(bot,:));             %   Process local mapped terrain and give commands for next movement
        disp('Move Rovers');
        Move(bot,pose(bot,:),reqd_pose);                    %   Give commands to Linux Terminal for movement
        disp('Odometry Tracking');
        pose(bot,:) = Tracking(bot,time,pose(bot,:));       %   Calculate odometric/deadreckoning movement
        toc
    end
%     [reqd_pose] = FindROI(nbots+1,pose(nbots+1,:));     %   Move Beacon Robot
%     Move(nbots+1,reqd_pose);
%     pose = Update(pose);                                %   Update global coordinates, orientations of all Robots
    time = time + 1;
    current_area = max_area;
end