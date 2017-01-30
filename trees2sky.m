clear all

m = imread('Alice2_1.jpeg');
n = m;
% RGBN Regions binary map (N - none, no clear winner)
% pr = (m(:,:,1)>1.04*m(:,:,2) & m(:,:,1)>1.04*m(:,:,3)) | (m(:,:,1)>180); 
% pg = (m(:,:,2)>m(:,:,3) & m(:,:,2)>m(:,:,1));
% pb = (m(:,:,3)>1.08*m(:,:,1) & m(:,:,3)>1.33*m(:,:,2) & m(:,:,3)>170);
pr = (m(:,:,1)>m(:,:,2) & m(:,:,1)>m(:,:,3));
pg = (m(:,:,2)>m(:,:,3) & m(:,:,2)>m(:,:,1));
pb = (m(:,:,3)>m(:,:,1) & m(:,:,3)>m(:,:,2));
pn = (pr==0 & pg==0 & pb==0);

% Binary map to actual intensity value maps
nr = n;
nr(:,:,1) = double(nr(:,:,1)).*pr;
nr(:,:,2) = double(nr(:,:,2)).*pr;
nr(:,:,3) = double(nr(:,:,3)).*pr;

ng = n;
ng(:,:,1) = double(ng(:,:,1)).*pg;
ng(:,:,2) = double(ng(:,:,2)).*pg;
ng(:,:,3) = double(ng(:,:,3)).*pg;

nb = n;
nb(:,:,1) = double(nb(:,:,1)).*pb;
nb(:,:,2) = double(nb(:,:,2)).*pb;
nb(:,:,3) = double(nb(:,:,3)).*pb;

nn = n;
nn(:,:,1) = double(nn(:,:,1)).*pn;
nn(:,:,2) = double(nn(:,:,2)).*pn;
nn(:,:,3) = double(nn(:,:,3)).*pn;

figure(1)
subplot(2,3,1)
imshow(nr)
subplot(2,3,2)
imshow(ng)
subplot(2,3,3)
imshow(nb)
subplot(2,3,4)
imshow(nn)

skyR = imhist(nb(:,:,1));
skyG = imhist(nb(:,:,2));
skyB = imhist(nb(:,:,3));
% save('sky_hist_R.mat','skyR');
% save('sky_hist_G.mat','skyG');
% save('sky_hist_B.mat','skyB');
% load('sky_hist_R.mat')
% load('sky_hist_G.mat')
% load('sky_hist_B.mat')

% Histogram matching
% nng(:,:,1) = double(histeq(ng(:,:,1),skyR)).*(pb==0).*(pr==0).*(pn==0);
% nng(:,:,2) = double(histeq(ng(:,:,2),skyG)).*(pb==0).*(pr==0).*(pn==0);
% nng(:,:,3) = double(histeq(ng(:,:,3),skyB)).*(pb==0).*(pr==0).*(pn==0);
% 
% nnn(:,:,1) = double(histeq(nn(:,:,1),skyR)).*(pb==0).*(pr==0).*(pg==0);
% nnn(:,:,2) = double(histeq(nn(:,:,2),skyG)).*(pb==0).*(pr==0).*(pg==0);
% nnn(:,:,3) = double(histeq(nn(:,:,3),skyB)).*(pb==0).*(pr==0).*(pg==0);

% Whitewash all except Red field
nng(:,:,1)=(ng(:,:,1)>0).*245;
nng(:,:,2)=(ng(:,:,2)>0).*248;
nng(:,:,3)=(ng(:,:,3)>0).*255;
nnn(:,:,1)=(nn(:,:,1)>0).*245;
nnn(:,:,2)=(nn(:,:,2)>0).*248;
nnn(:,:,3)=(nn(:,:,3)>0).*255;
nb(:,:,1) =(nb(:,:,1)>0).*245;
nb(:,:,2) =(nb(:,:,2)>0).*248;
nb(:,:,3) =(nb(:,:,3)>0).*255;

m2 = uint8(nng)+uint8(nnn)+nr+nb;
subplot(2,3,5)
imshow(n)
subplot(2,3,6)
imshow(m2)
imwrite(m2,'Aritra2_1.jpg','jpg');