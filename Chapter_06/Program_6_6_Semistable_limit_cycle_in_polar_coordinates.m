% 例程 6.6  极坐标下的半稳定极限环
%  极坐标形式
%  初始状态
rho_0 = 1.8;  %  半径
theta_0 = 3*pi/4;  %  弧度
rho_1 = 0.9;  %  半径
theta_1 = -pi/4;  %  弧度
figure(1)
%  绘制坐标轴
plot([-2.5, 2.5], [0, 0], 'k');
hold  on;
plot([0, 0], [-2.5, 2.5], 'k');
%  绘制初始点
polar(theta_0, rho_0, 'ko');
polar(theta_1, rho_1, 'ko');
dt = 0.02;
t = 0;
rho = rho_0;
theta = theta_0;
%  欧拉积分法
while (t < 10)
    polar(theta, rho, 'r.');
    dtheta = -dt;
    drho = (-rho*((rho^2) - 1)^2)*dt;
    rho = rho + drho;
    theta = theta + dtheta;
    t = t + dt;  %  时间增量
end
t = 0;
rho = rho_1;
theta = theta_1;
%  欧拉积分法
while (t < 6)
    polar(theta, rho, 'b.');
    dtheta = -dt;
    drho = (-rho*((rho^2) - 1)^2)*dt;
    rho = rho + drho;
    theta = theta + dtheta;
    t = t + dt;  %  时间增量
end 
axis([-2.5, 2.5, -2.5, 2.5]);
xlabel('x1');  ylabel('x2');
