function [rectified_L rectified_R] = GreyscaleConv(img_L,img_R,method)
    if(method==1)
        rectified_L = uint8(sum(img_L,3)/3);
        rectified_R = uint8(sum(img_R,3)/3);
    elseif(method==2)
        sort_img_L = sort(img_L,3);
        rectified_L = (sort_img_L(:,:,1) + sort_img_L(:,:,3))/2;
        sort_img_R = sort(img_R,3);
        rectified_R = (sort_img_R(:,:,1) + sort_img_R(:,:,3))/2;
    elseif(method==3)
        rectified_L = uint8(img_L(:,:,1)*0.2989 + img_L(:,:,2)*0.5870 + img_L(:,:,3)*0.1140 );
        rectified_R = uint8(img_R(:,:,1)*0.2989 + img_R(:,:,2)*0.5870 + img_R(:,:,3)*0.1140 );
    elseif(method==4)
        rectified_L = uint8(img_L(:,:,1)*0.2126 + img_L(:,:,2)*0.7152 + img_L(:,:,3)*0.0722 );
        rectified_R = uint8(img_R(:,:,1)*0.2126 + img_R(:,:,2)*0.7152 + img_R(:,:,3)*0.0722 );
    else
        disp('Invalid Option for Parameter : Greyscale Conversion Method');
    end
end