% A.13(P11.5) 蚁群算法求解旅行商问题（TSP）示例
%  简易蚁群优化算法（ACO）示例
%  求解旅行商问题（TSP），主程序调用3个辅助函数
%  TSP问题初始化
Nc = 15;  %  城市数量
x = zeros(Nc, 1);
y = zeros(Nc, 1);
%  随机生成城市坐标
for jj = 1:Nc
    x(jj) = rand*30;
    y(jj) = rand*30;
end
%  绘制TSP问题地图
figure(1)
plot(x, y, 'r*', 'MarkerSize', 12);
hold on;
xlabel('x');  ylabel('y');
%  生成城市间距离矩阵
D = zeros(Nc, Nc);
for i = 1: Nc
    for j = 1: Nc
        D(i, j) = sqrt((x(i) - x(j))^2 +(y(i) - y(j))^2);
    end
end
%  蚁群算法（ACO）开始
%  初始化
S = zeros(Nc, Nc);  %  能见度矩阵
for i = 1: Nc
    for j = 1: Nc
        if(D(i, j) == 0)
            S(i, j) = 0;
        else
            S(i, j) = 1/D(i, j);
        end
    end
end
Na = 30;  %  蚂蚁数量
niter = 20;  %  迭代次数
alpha = 1;  %  能见度影响因子
beta = 4;  %  信息素影响因子
t = 0.0001*ones(Nc);  %  初始信息素浓度
elim = 0.97;  %  通用距离修正系数
ev = 0.15;  %  信息素蒸发系数
Ip = zeros(Na, Nc);  %  记录蚂蚁在城市中的位置
%  主迭代过程
for  jj = 1:niter
    %  初始化蚂蚁位置（分配到不同城市）
    for i = 1:Na
        Ip(i, 1) = fix(1 + rand*(Nc - 1));  %  随机分配初始城市
    end
    %  为每只蚂蚁生成路径，调用antTour函数
    [tour] = antTour(Ip, Na, Nc, S, t, alpha, beta);
    %  路径闭合
    tour = horzcat(tour, tour(:, 1));
    %  计算每只蚂蚁路径总长度（调用calcDist函数）
    [dist, f] = calcDist(Na, Nc, D, tour, elim);
    %  更新信息素（调用traceUpdt函数）
    [t] = traceUpdt(Na, Nc, t, tour, f, ev);
    mean_dist(jj) = mean(dist);
    %  提取本轮最优路径
    [min_dist(jj), best_index] = min(dist);
    best_tour(jj, :) = tour(best_index, :);
    itercount(jj) = jj;
end
%  结果展示，绘制最优路径
[K, L] = min(min_dist);
for i = 1:(Nc + 1)
    aux = best_tour(L, i);
    X(i) = x(aux);
    Y(i) = y(aux);
end
plot(X, Y, '--bo');
xlabel('X');  ylabel('Y');
disp('最优路径总长度')
num2str(K)
%  搜索过程可视化
figure(2)
plot(itercount, mean_dist, 'm');
xlabel('迭代次数');  ylabel('平均距离');

%  函数定义
%  生成蚂蚁路径
function [new_places] = antTour(Ip, Na, Nc, S, t, alpha, beta)
for  i = 1: Na
    mS = S;
    for j = 1:(Nc - 1)
        c = Ip(i, j);
        mS(:, c) = 0;
        aux = (t(c, :).^beta).*(mS(c, :).^alpha);
        sm = (sum(aux));
        p = (1/sm).*aux;
        r = rand;
        sm = 0;
        for  k = 1: Nc
            sm = sm + p(k);
            if r <= sm
                Ip(i, j + 1) = k;
                break;
            end
        end
    end
end
new_places = Ip;
end

%  路径长度计算
function [dist, f] = calcDist(Na, Nc, D, atour, elim)
for i = 1: Na
    aux = 0;
    for j = 1: Nc
        aux = aux + D(atour(i, j), atour(i, j + 1));
    end
    f(i) = aux;
end
dist = f;
f = f -(elim*min(f));
end

%  信息素更新
function [t] = traceUpdt(Na, Nc, t, tour, f, ev)
for i = 1: Na
    for j = 1: Nc
        dt = 1/f(i);
        aux1 = tour(i, j);
        aux2 = tour(i, j + 1);
        t(aux1, aux2) = dt + ((1 - ev)*t(aux1, aux2));
    end
end
end
