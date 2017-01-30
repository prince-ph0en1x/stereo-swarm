function [g] = Stereovision(leftI3chan,rightI3chan)

%     leftI3chan  = imread('D:\IMPORTANT\Project\MTLB - Stereovision 2\2l.jpg');
%     rightI3chan = imread('D:\IMPORTANT\Project\MTLB - Stereovision 2\2r.jpg');

    leftI = uint8(sum(leftI3chan,3)/3);
    % leftI = uint8(leftI3chan(:,:,1)*0.2989 + leftI3chan(:,:,2)*0.5870 + leftI3chan(:,:,3)*0.1140 );
    % leftI = uint8(leftI3chan(:,:,1)*0.2126 + leftI3chan(:,:,2)*0.7152 + leftI3chan(:,:,3)*0.0722 );
    
    rightI = uint8(sum(rightI3chan,3)/3);
    % rightI = uint8(rightI3chan(:,:,1)*0.2989 + rightI3chan(:,:,2)*0.5870 + rightI3chan(:,:,3)*0.1140 );
    % rightI = uint8(rightI3chan(:,:,1)*0.2126 + rightI3chan(:,:,2)*0.7152 + rightI3chan(:,:,3)*0.0722 );

    %% Basic block template matching
    sz1 = min(size(leftI,1),size(rightI,1));
    sz2 = min(size(leftI,2),size(rightI,2));
    Dbasic = double(disparity_OCV(leftI,rightI));
    Dbasic = Dbasic.*(Dbasic>2).*(Dbasic<15)+(Dbasic<1)*4.5;
    
    %% Vertical Smoothing
    newfimg3 = zeros(sz1,sz2);
    svprm = 0; % Smoothing parameter
    for j = 1 : sz2
        for i = svprm+1 : sz1-svprm
            newfimg3(i,j) = sum(Dbasic(i-svprm:i+svprm,j))/(svprm*2 + 1);
        end
    end
        
    %% Horizontal Smoothing
    newfimg4 = zeros(sz1,sz2);
    shprm = 3; % Smoothing parameter
    for i = 1 : sz1
        for j = shprm+1 : sz2-shprm
            newfimg4(i,j) = sum(newfimg3(i,j-shprm:j+shprm))/(shprm*2 + 1);
        end
    end

    %% Add camera slope
%     mval = sum(sum(newfimg4))/(sz1*sz2);
%     slope = zeros(sz1,sz2);
%     for i = 1 : sz1
%           slope(i,:) = i;%(sz1-i)*mval/sz1;
%     end
%     newfimg4 = newfimg4 -(newfimg4 < 0).* newfimg4;
    
    %% Remove above horizon map
%     [p,~,~] = AutoThresh1(leftI3chan,rightI3chan);
    
    %% Intregate final elevation map
%     g = flipud(1-p).*flipud(newfimg4).*flipud(slope);
    g = flipud(newfimg4);
    
%     figure(40)
%     mesh(im2double(g),'FaceColor','interp','FaceLighting','phong')
%     camlight headlight
end