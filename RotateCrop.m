function [rectified_L rectified_R] = RotateCrop(img_L,img_R,roll)
    img_L = imrotate(img_L,roll,'bicubic','crop');
    img_R = imrotate(img_R,roll,'bicubic','crop');
    
    sz1 = min(size(img_L,1),size(img_R,1));
    sz2 = min(size(img_L,2),size(img_R,2));
    
    rectified_L = img_L(end-sz1+1:end,1:sz2,:);
    rectified_R = img_R(1:sz1,1:sz2,:);
end