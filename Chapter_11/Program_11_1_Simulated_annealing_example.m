% 例程 11.1  模拟退火算法示例
%  目标函数可视化
[vx1, vx2 ] = meshgrid(-1.2: 0.02: 1.2, -1.2: 0.02: 1.2);
y = 0.2 + (vx1.^2) + (vx2.^2) - (0.1*cos(6*pi*vx1)) - (0.1*cos(6*pi*vx2));
%  函数可视化
figure(1)
contour(vx1, vx2, y, 11); hold on;
xlabel('x1');  ylabel('x2');
%  搜索参数设置
T = 1000;  %  初始温度
Tmin = 0.001;  %  终止温度
%  每个温度阶段的最大迭代次数
Nmax = 1000;
Ct = 0.9;  %  降温速率
x1min = -1.2;
x1max = 1.2;
x2min = -1.2;
x2max = 1.2;
sigma1 = (x1max - x1min)/6;
sigma2 = (x2max - x2min)/6;
x1n = 0;
x2n = 0;
dE = 0;
r = 0;
P = 0;  %  辅助变量
vT = zeros(1, 200);
vy = zeros(1, 200);
%  初始点
x1 = -1;
x2 = 1;
plot(x1, x2, 'm*', 'MarkerSize', 12);
xlabel('x1');  ylabel('x2');
%  退火过程开始
jj = 0;  %  温度步数计数器
while (T > Tmin)
    for  nn = 1: Nmax
        %  基于正态分布生成新候选解
        x1n = x1 + (sigma1^2)*randn(1);
        x2n = x2 + (sigma2^2)*randn(1);
        if ((x1n <= x1max) & (x1n >= x1min) & (x2n <= x2max) & (x2n >= x2min))
            y = 0.2 + (x1^2) + (x2^2) - (0.1*cos(6*pi*x1)) - (0.1*cos(6*pi*x2));
            yn = 0.2 + (x1n^2) + (x2n^2) - (0.1*cos(6*pi*x1n)) - (0.1*cos(6*pi*x2n));
            dE = yn - y;
            %  判断是否接受新解
            if dE < 0
                x1 = x1n; x2 = x2n;  %  接受新点
            else
                r = rand(1);
                P = exp(-dE/T);  %  玻尔兹曼概率
                if (r <= P)
                    x1 = x1n; x2 = x2n;  %  接受新点
                end
            end
        end
    end
    jj = jj + 1;
    plot(x1, x2, 'ro');
    y = 0.2 + (x1^2) + (x2^2) - (0.1*cos(6*pi*x1)) - (0.1*cos(6*pi*x2));
    vT(jj) = T;
    vy(jj) = y;  %  保存迭代过程数据
    T = T*Ct;  %  降低温度
end
x1
x2
y = 0.2 + (x1^2) + (x2^2) - (0.1*cos(6*pi*x1)) - (0.1*cos(6*pi*x2))
figure(2)
subplot(2, 1, 1);
plot(vT(1: jj));
xlabel('温度步长');  ylabel('温度');
subplot(2, 1, 2);
plot(vy(1: jj));
xlabel('温度步长');
ylabel('目标函数');
