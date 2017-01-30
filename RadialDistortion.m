function [rectified_L,rectified_R] = RadialDistortion(img_L,img_R,c)% Program for Pincushion and Barrel distortion

    % c = [1    +0.0042 +0.0;1 +0.0    +0.000017];
    % c = [1    -0.003  -0.0;1 -0.0    -0.000012];
    % c = [0.60 +0.0011 +0.0;1 -0.0015 -0.0     ];
    % o0 = imread('2l.jpg');

    sz1 = min(size(img_L,1),size(img_R,1));
    sz2 = min(size(img_L,2),size(img_R,2));
    cen = [sz1 sz2]/2;
    r = zeros(sz1,sz2);
    m = zeros(sz1,sz2);
    
    for i=1:sz1
        for j=1:sz2
            r(i,j) = sqrt((i-cen(1))^2 + (j-cen(2))^2);     % radial distance
            m(i,j) = (j-cen(2)) / (i-cen(1)) ;              % slope
        end
    end
    
    % Left Image
    bound =[sz1 sz1 sz2 sz2]; % top bottom left right
    rc = c(1,1)*r + c(1,2)*(r.^2) + c(1,3)*(r.^3);
    o2 = zeros(sz1*2,sz2*2);
    for i=1:sz1
        for j=1:sz2
            if(i<cen(1) && j<cen(2))
                i2 = cen(1) - ceil(rc(i,j)/sqrt(1+m(i,j)^2));
                j2 = cen(2) - ceil(rc(i,j)*m(i,j)/sqrt(1+m(i,j)^2));
                o2(cen(1)+i2,cen(2)+j2) = img_L(i,j);
            elseif(i>cen(1) && j>cen(2))
                i2 = cen(1) + ceil(rc(i,j)/sqrt(1+m(i,j)^2));
                j2 = cen(2) + ceil(rc(i,j)*m(i,j)/sqrt(1+m(i,j)^2));
                o2(cen(1)+i2,cen(2)+j2) = img_L(i,j);
            elseif(i>cen(1) && j<cen(2))
                i2 = cen(1) + ceil(rc(i,j)/sqrt(1+m(i,j)^2));
                j2 = cen(2) + ceil(rc(i,j)*m(i,j)/sqrt(1+m(i,j)^2));
                o2(cen(1)+i2,cen(2)+j2) = img_L(i,j);
            elseif(i<cen(1) && j>cen(2))
                i2 = cen(1) - ceil(rc(i,j)/sqrt(1+m(i,j)^2));
                j2 = cen(2) - ceil(rc(i,j)*m(i,j)/sqrt(1+m(i,j)^2));
                o2(cen(1)+i2,cen(2)+j2) = img_L(i,j);
            else
                o2(cen(1)+i,cen(2)+j) = img_L(i,j);
            end
    
            if(cen(1)+i2 < bound(1))
                bound(1) = cen(1)+i2;
            end
            if(cen(1)+i2 > bound(2))
                bound(2) = cen(1)+i2;
            end
            if(cen(2)+j2 < bound(3))
                bound(3) = cen(2)+j2;
            end
            if(cen(2)+j2 > bound(4))
                bound(4) = cen(2)+j2;
            end
        end
    end
    rectified_L = uint8(o2(bound(1):bound(2),bound(3):bound(4)));


    % Right Image
    bound =[sz1 sz1 sz2 sz2]; % top bottom left right
    rc = c(1,1)*r + c(1,2)*(r.^2) + c(1,3)*(r.^3);
    o2 = zeros(sz1*2,sz2*2);
    for i=1:sz1
        for j=1:sz2
            if(i<cen(1) && j<cen(2))
                i2 = cen(1) - ceil(rc(i,j)/sqrt(1+m(i,j)^2));
                j2 = cen(2) - ceil(rc(i,j)*m(i,j)/sqrt(1+m(i,j)^2));
                o2(cen(1)+i2,cen(2)+j2) = img_R(i,j);
            elseif(i>cen(1) && j>cen(2))
                i2 = cen(1) + ceil(rc(i,j)/sqrt(1+m(i,j)^2));
                j2 = cen(2) + ceil(rc(i,j)*m(i,j)/sqrt(1+m(i,j)^2));
                o2(cen(1)+i2,cen(2)+j2) = img_R(i,j);
            elseif(i>cen(1) && j<cen(2))
                i2 = cen(1) + ceil(rc(i,j)/sqrt(1+m(i,j)^2));
                j2 = cen(2) + ceil(rc(i,j)*m(i,j)/sqrt(1+m(i,j)^2));
                o2(cen(1)+i2,cen(2)+j2) = img_R(i,j);
            elseif(i<cen(1) && j>cen(2))
                i2 = cen(1) - ceil(rc(i,j)/sqrt(1+m(i,j)^2));
                j2 = cen(2) - ceil(rc(i,j)*m(i,j)/sqrt(1+m(i,j)^2));
                o2(cen(1)+i2,cen(2)+j2) = img_R(i,j);
            end
    
            if(cen(1)+i2 < bound(1))
                bound(1) = cen(1)+i2;
            end
            if(cen(1)+i2 > bound(2))
                bound(2) = cen(1)+i2;
            end
            if(cen(2)+j2 < bound(3))
                bound(3) = cen(2)+j2;
            end
            if(cen(2)+j2 > bound(4))
                bound(4) = cen(2)+j2;
            end
        end
    end
    rectified_R = uint8(o2(bound(1):bound(2),bound(3):bound(4)));
end