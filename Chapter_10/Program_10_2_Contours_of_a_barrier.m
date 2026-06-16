% 例程 10.2  障碍函数的等高线
%  障碍函数的二维等高线绘制
v = 0:0.1:1;
[vx1, vx2] = meshgrid(v);
y = ((vx1 + 1).^2) + ((vx2 + 1).^2);
figure(1)
mhu = 0.7;
z = ((vx1 + 1).^2) + ((vx2 + 1).^2) - (mhu*log(vx1)) - (mhu*log(vx2));
contour(vx1, vx2, z, 20);
hold on;
xlabel('x1');  ylabel('x2');
