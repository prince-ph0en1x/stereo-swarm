 vid1 = videoinput('winvideo',1,'YUY2_640x480');
 set (vid1,'ReturnedColorSpace','grayscale');
 preview(vid1);
 pause(1)
 fprintf('Video 1 started\n')
 
 vid2 = videoinput('winvideo',2,'YUY2_640x480');
 set (vid2,'ReturnedColorSpace','grayscale');
 preview(vid2);
 fprintf('Video 2 started\n');
 fprintf('Waiting for 7 seconds for cameras to adjust\n');
 pause(7)
 
 fprintf('Camera Status : Both On\n')

 input('start\n')

 im_left_original =(getsnapshot(vid2));
 fprintf('First_Image_captured\n');
 im_right_original =(getsnapshot(vid1));
 fprintf('Second_Image_captured\n');
 
 for i=1:1000
i
     im_left_original =(getsnapshot(vid2));
 fprintf('First_Image_captured\n');
 im_right_original =(getsnapshot(vid1));
 fprintf('Second_Image_captured\n');

     
     i_left_name=strcat('aritra1\','Aritra1_',num2str(i),'.jpeg');
imwrite(im_left_original,i_left_name);

     i_right_name=strcat('aritra2\','Aritra2_',num2str(i),'.jpeg');
imwrite(im_right_original,i_right_name);

     
 fprintf('%d Images written in directory \n\n',i);
 Go=input('Go??')

 end

closepreview(vid1)
closepreview(vid2)
  