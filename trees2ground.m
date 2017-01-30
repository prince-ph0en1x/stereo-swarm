clear all

m = imread('rgb.jpg');
n = m;
pr = (m(:,:,1)>m(:,:,2) & m(:,:,1)>m(:,:,2));
pg = (m(:,:,2)>m(:,:,1) & m(:,:,2)>m(:,:,3));
pb = (m(:,:,3)>m(:,:,1) & m(:,:,3)>m(:,:,1));

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

figure(1)
subplot(1,3,1)
imshow(nr)
subplot(1,3,2)
imshow(ng)
subplot(1,3,3)
imshow(nb)

figure(2)
nng(:,:,1) = double(histeq(ng(:,:,1),imhist(nr(:,:,1)))).*(pb==0);
nng(:,:,2) = double(histeq(ng(:,:,2),imhist(nr(:,:,2)))).*(pb==0);
nng(:,:,3) = double(histeq(ng(:,:,3),imhist(nr(:,:,3)))).*(pb==0);

subplot(1,2,1)
imshow(n)
subplot(1,2,2)
imshow(uint8(nng)+nr+nb)