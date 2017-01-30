function [pose_new] = Tracking(bot,time,pose)
%       Calculate odometric/deadreckoning movement

    % Odometry
	% pose_new = StereoOdometry1(bot,time);
    pose_new = StereoOdometry2(bot,time);
	
	% DR
	% Add DR/INS correction if required for application
end