function d = disparity1(I1,I2)
    % References:
    % [1] K. Konolige, "Small Vision Systems: Hardware and Implementation,"
    %     Proceedings of the 8th International Symposium in Robotic Research,
    %     pages 203-212, 1997.
    % [2] G. Bradski and A. Kaehler, "Learning OpenCV : Computer Vision with
    %     the OpenCV Library," O'Reilly, Sebastopol, CA, 2008.
    
    %   Steps:
    %   (1) Compute a measure of contrast of the image by using the Sobel filter 
    %   (2) Compute the disparity for each of the pixels by using block matching and sum of absolute differences (SAD)
    %   (3) Optionally, mark the pixels for which disparity was not computed reliably with -REALMAX('single').
    
    % Parameters accessible from the main interface
    opt.preFilterCap        = int32(floor(63 * 0.5));
    opt.SADWindowSize       = int32(15);
    opt.minDisparity        = int32([0 64]);
    opt.numberOfDisparities = int32(64);
    opt.textureThreshold    = int32(255 * 0.0002 * 15^2);
    opt.uniquenessRatio     = int32(15);
    opt.disp12MaxDiff       = int32(-1);
    opt.roi1                = int32([1 1 0 0]) - int32([1 1 0 0]);
    opt.roi2                = int32([1 1 0 0]) - int32([1 1 0 0]);
    
    % Other OpenCV parameters which are not exposed in the main interface
    opt.preFilterType       = int32(1);    % Fixed to CV_STEREO_BM_XSOBEL
    opt.preFilterSize       = int32(15);
    opt.speckleWindowSize   = int32(0);
    opt.speckleRange        = int32(0);
    opt.trySmallerWindows   = int32(0);
    
    % Compute disparity
    if ~isa(I1, 'uint8')
        I1 = im2uint8(I1);
        I2 = im2uint8(I2);
    end
    
    d = ocvDisparityBM(I1, I2,opt);
    
end
