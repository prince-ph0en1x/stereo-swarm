function [img_L,img_R] = ReadImgPair(bot,time)  %   Read sent stereoimages from defined folder with next time stamp
    %% Online Mode for Scout Bot
    if (bot<3)
        %     Extra Useful Commands
        %     imgPath = 'D:\IMPORTANT\Sem VIII\Project\MTLB - Stereovision 2\'; 
        %     dCell = dir([imgPath strcat('Img_',bot,'_*.png')]);
        %     for d = 1:length(dCell)
        %         if 
        %         img_L = imread([imgPath dCell(d).name]);
        %         img_R = imread([imgPath dCell(d).name]);
        %         end
        %     end
        %     resultsPath = './results/';
        %     if ~isdir(resultsPath)
        %         mkdir(resultsPath);
        %     end
        %     datestr(clock,30)
        
        path = 'D:\IMPORTANT\Project\MTLB - Stereovision 2\readings\';
        img_L = imread(strcat(path,'Img_',num2str(bot),'_',num2str(time),'_L.jpg'));
        img_R = imread(strcat(path,'Img_',num2str(bot),'_',num2str(time),'_R.jpg'));
    else
        %% Offline Mode for Beacon Bot
        %     cam1 = videoinput('winvideo',2,'YUY2_320x240');
        %     preview(cam1)
        %     set(cam1,'ReturnedColorSpace','rgb');
        %     pause(cam1)
        %     img_L = getsnapshot(cam1);
        %     delete(cam1);
        %     
        %     cam2 = videoinput('winvideo',3,'YUY2_320x240');
        %     preview(cam2)
        %     set(cam2,'ReturnedColorSpace','rgb');
        %     pause(cam2)
        %     img_R = getsnapshot(cam2);
        %     delete(cam2);
    end
end