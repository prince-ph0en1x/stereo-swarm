function [rectified_L,rectified_R] = Rectify(img_L,img_R)%       Rectify images   
    roll = 0;
    asprat = 4/3;
    dstr = [+0.9000 +0.0004 +0.000];
    % Rectifications :
    % Trees to Ground conversion for Earth
    [rectified_L rectified_R] = GreyscaleConv(img_L,img_R);             % Greyscale Conversion
    [rectified_L rectified_R] = RadialDistortion(rectified_L,rectified_R,dstr);     % Pinhole/Cushion effect
    [rectified_L rectified_R] = RotateCrop(rectified_L,rectified_R,roll);           % Rotations and Cropping 
    [rectified_L rectified_R] = AspectRatio(rectified_L,rectified_R,asprat);        % Aspect Ratio preservation
    [rectified_L rectified_R] = BrightnessContrast(rectified_L,rectified_R);        % Contrast and Brightness equalization
    % Resize
    % Removing vertical disparity
end