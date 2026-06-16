% 例程 6.5  不稳定极限环
%  极坐标形式
%  初始状态
rho_0 = 1.03;  %  半径
theta_0 = 3*pi/4;  %  弧度
rho_1 = 0.97;  %  半径
theta_1 = -pi/4;  %  弧度
figure(1)
%  绘制坐标轴
plot([-2.5, 2.5], [0, 0], 'k');
hold on;
plot([0, 0], [-2.5, 2.5], 'k');
%  绘制初始点
polar(theta_0, rho_0, 'ko');
polar(theta_1, rho_1,'ko');
%  绘制极限环
dt = 0.1;
t = 0;
rho = 1;
theta = 0;
%  欧拉积分法
while (t < 8)
    polar(theta, rho, 'k.');
    dtheta = -dt;
    drho = (rho*((rho^2) - 1))*dt;
    rho = rho + drho;
    theta = theta + dtheta;
    t = t + dt;  %  时间增量
end
dt = 0.02;
t = 0;
rho = rho_0;
theta = theta_0;
%  欧拉积分法
while (t < 3)
    polar(theta, rho, 'r.');
    dtheta = -dt;
    drho = (rho*((rho^2) - 1))*dt;
    rho = rho + drho;
    theta = theta + dtheta;
    t = t + dt;  %  时间增量
end
t = 0;
rho = rho_1;
theta = theta_1;
%  欧拉积分法
while (t < 5)
    polar(theta, rho, 'b.');
    dtheta = -dt;
    drho = (rho*((rho^2) - 1))*dt ;
    rho = rho + drho;
    theta = theta + dtheta;
    t = t + dt;  %  时间增量
end
axis([-2.5, 2.5, -2.5, 2.5]);
xlabel('x1');  ylabel('x2');
