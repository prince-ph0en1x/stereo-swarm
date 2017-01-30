function [rectified_L rectified_R] = BrightnessContrast(img_L,img_R)

    sz1 = min(size(img_L,1),size(img_R,1));
    sz2 = min(size(img_L,2),size(img_R,2));

    % Equalize Brightness
    a = hist(double(reshape(img_L,1,sz1*sz2)),255);
    [~,hL] = findpeaks(a,'SORTSTR','descend','NPEAKS',1);
    a = hist(double(reshape(img_L,1,sz1*sz2)),255);
    [~,hR] = findpeaks(a,'SORTSTR','descend','NPEAKS',1);
    hmean = (hL-hR)/2;
    rectified_L = img_L - (hL - hmean);
    rectified_R = img_R - (hR + hmean);
end



