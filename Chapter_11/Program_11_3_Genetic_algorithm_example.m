% 例程 11.3  遗传算法示例
%  目标函数可视化
[vx1, vx2] = meshgrid(-1.2: 0.02: 1.2, -1.2: 0.02: 1.2);
figure(1)
y = The_problem(vx1, vx2);  %  调用函数实现可视化
contour(vx1, vx2, y, 11);  hold on;
xlabel('x1');  ylabel('x2');
%  算法参数设置
Ncr = 100;  %  染色体数量
Ngen = 300;  %  进化代数
x1min = -1.2;  x1max =1.2;
x2min = -1.2;  x2max =1.2;
%  算法初始化
chr = zeros(2, Ncr);  %  存储染色体
child = zeros(2, 1);  %  存储子代染色体
z = zeros(1, Ncr);  %  存储每个染色体的适应度值
hcr = zeros(2, Ngen);   %  记录每一代最优染色体的进化历史
hz = zeros(1, Ngen);  %  记录每一代最优适应度值
%  生成初始种群，并计算每个染色体的适应度
for  nn = 1: Ncr
    chr(1, nn) = x1min + ((x1max - x1min)*rand(1));
    chr(2, nn) = x2min + ((x2max - x2min)*rand(1));
    %  调用fit()函数计算适应度
    z(nn) = fit(chr(1, nn), chr(2, nn));
end
%  绘制初始种群
plot(chr(1, :), chr(2, :), 'ko');
zaux = z;
%  开始进化迭代
for gg = 1: Ngen
    %  对染色体按适应度排序
    [zaux, indx] = sort(z);
    ib = indx(1);
    hcr(:, gg) = chr(:, ib);  %  记录当前代最优染色体
    hz(gg) = fit(chr(1, ib), chr(2, ib));  %  记录当前代最优适应度值（fit()最小值）
    %  1. 通过交叉产生1个子代，随机选择父代
    naux = Ncr - 1;
    p1 = 1 + round(naux*rand(1));
    p2 = 1 + round(naux*rand(1));
    child(1, 1) = chr(1, p1);
    child(2, 1) = chr(2, p2);
    %  用新子代替换最差个体
    iw = indx(Ncr);
    chr(:, iw) = child(:);
    %  对1个染色体进行变异，以一定概率触发
    if  rand(1) < 0.2
        pm = 1 + round(naux*rand(1));
        chr(1, pm) = x1min + ((x1max - x1min)*rand(1));
        chr(2, pm) = x2min + ((x2max - x2min)*rand(1));
    end
    %  评估新种群的适应度
    for  nn = 1: Ncr
        %  调用fit()函数计算适应度
        z(nn) = fit(chr(1, nn), chr(2, nn));
    end
end
hz(Ngen)
hcr(:, Ngen)
%  绘制最优染色体的进化历史
figure(2)
y = The_problem(vx1, vx2);  %  调用函数实现可视化
contour(vx1, vx2, y, 11);
hold on;
xlabel('x1');  ylabel('x2');
plot(hcr(1, :), hcr(2, :), 'ro');
figure(3)
plot(hz, 'm');
xlabel('进化代数');  ylabel('目标函数值');
%  用于绘制目标函数等高线的函数
function  y = The_problem(vx1, vx2)
y = 0.2 + (vx1.^2) + (vx2.^2) - (0.1*cos(6*pi*vx1)) - (0.1*cos(6*pi*vx2));
end
%  适应度评估函数
function  objv = fit(x1, x2)
objv = 0.2 + (x1^2) + (x2^2) - (0.1*cos(6*pi*x1)) - (0.1*cos(6*pi*x2));
end
