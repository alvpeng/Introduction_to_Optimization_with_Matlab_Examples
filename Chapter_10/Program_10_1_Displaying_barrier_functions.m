% 例程 10.1  障碍函数的绘制
%  对数障碍函数的绘图
x = 0.01: 0.05: 3;
figure(1)
for nn = 1:6
    mhu = nn*0.1;
    z = -mhu*log(x);
    plot(x, z, 'b');
    hold on;
end
xlabel('x');
grid;
