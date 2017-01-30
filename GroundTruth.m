a = fopen('F:\Dataset1\insdata.txt')
d = fscanf(a,'%f',inf);
g = reshape(d,10, 1424);
h = g';
%  Columns : timestamp  lat     lon     alt     x   y   z   roll    pitch   yaw

x_ori = h(1,5);
y_ori = h(1,6);
figure(23)
% plot([h(1,5) h(1,5)],[h(1,6) h(1,6)]);
for i = 2:1424
    hold on
    plot([h(i-1,5)-x_ori h(i,5)-x_ori],[h(i-1,6)-y_ori h(i,6)-y_ori]);
    axis equal
%     axis([min(min(h(:,5)))-1000 max(max(h(:,5)))+1000 min(min(h(:,6)))-1000 max(max(h(:,6)))+1000])
    pause(0.01)
end
fclose(a)
