function [rectified_L,rectified_R] = AspectRatio (img_L,img_R,reqd_ratio)
    sz1 = min(size(img_L,1),size(img_R,1));
    sz2 = min(size(img_L,2),size(img_R,2));
    
    img_ratio = sz1/sz2;
    
    if(img_ratio < reqd_ratio)
        rectified_L = imresize(floor(img_L),[sz2/reqd_ratio sz2]);
        rectified_R = imresize(floor(img_R),[sz2/reqd_ratio sz2]);
    else
        rectified_L = imresize(floor(img_L),[sz1 sz1*reqd_ratio]);
        rectified_R = imresize(floor(img_R),[sz1 sz1*reqd_ratio]);
    end
end