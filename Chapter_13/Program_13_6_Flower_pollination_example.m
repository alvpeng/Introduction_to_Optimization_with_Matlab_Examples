% 例程 13.6  花朵授粉算法示例
%  花朵授粉算法示例
n = 20;  %  种群规模，通常取值10至25
p = 0.8;  %  切换概率
N_iter = 200;  %  迭代总次数
d = 2;  %  搜索空间维度
Lb = -5*ones(1, d);
Ub = 5*ones(1, d);
Rfbest = zeros(1, round(N_iter/20));
Sol = zeros(n, d);
%  初始化种群/解
for i = 1:n
    Sol(i, :) = ((Ub - Lb).*rand(1, d)) + Lb;
    Fitness(i) = F_Fun(Sol(i, :));
end;
%  为目标函数绘图准备数据
[vx1, vx2] = meshgrid(-5: 0.2: 5, -5: 0.2: 5);
y = (vx1.^2) + (vx2.^2) + (25*((sin(vx1)).^2)) + (25*((sin(vx2)).^2));
%  绘制初始种群分布图
figure(1)
colormap('jet');
contour(vx1, vx2, y, 15);
hold on;
plot(Sol(:, 1), Sol(:, 2), 'k*');
%  找到当前最优解
[fmin, I]= min(Fitness);
best = Sol(I, :);
S = Sol;
Rfbest(1) = fmin;
Ntw = 0;
Mc = 1;
%  主循环
for iter = 1: N_iter
    for i = 1: n
        if rand > p
            L = F_Levy(d);
            dS = L.*(Sol(i, :) - best);
            S(i, :) = Sol(i, :) + dS;
            %  边界检查/约束
            S(i, :) = F_simplebounds(S(i, :), Lb, Ub);
            %  否则，执行相邻花朵的局部授粉操作
        else
            epsilon = rand;
            %  随机选择邻域内的花朵
            JK = randperm(n);
            %  若为同/近源物种花朵，则进行授粉；否则不操作
            S(i, :) = S(i, :) + epsilon*(Sol(JK(1), :) - Sol(JK(2), :));
            %  检查是否符合边界约束
            S(i, :) = F_simplebounds(S(i, :), Lb, Ub);
        end
        %  评估新解的适应度
        Fnew = F_Fun(S(i, :));
        %  若适应度提升（找到更优解），则更新
        if (Fnew <= Fitness(i))
            Sol(i, :) = S(i, :);
            Fitness(i) = Fnew;
        end
        %  更新当前全局最优解
        if Fnew <= fmin
            best = S(i, :);
            fmin = Fnew;
        end
    end
    %  每20次迭代保存一次最优值
    Ntw = Ntw + 1;
    if Ntw == 20
        Ntw = 0;
        Mc = Mc + 1;
        Rfbest(Mc) = fmin;
    end
end
%  输出结果
disp(['总评估次数：', num2str(N_iter*n)]);
disp(['最优解 = ', num2str(best), 'fmin = ', num2str(fmin)]);
%  绘制最终种群分布图
figure(2)
colormap('jet');
contour(vx1, vx2, y, 15);
hold on;
plot(Sol(:, 1), Sol(:, 2), 'k*');
figure(3)
nn = 0: 1: Mc - 1;
plot(nn, log10(Rfbest(nn + 1)), 'm');
xlabel('迭代次数 / 20');  ylabel('log10(最优结果) ')

%  莱维飞行步长生成函数
function L = F_Levy(d)
%  生成n个莱维飞行样本
%  莱维指数和系数
beta = 3/2;
sigma = (gamma(1 + beta)*sin(pi*beta/2)/ ...
    (gamma((1 + beta)/2)*beta*2^((beta - 1)/2)))^(1/beta);
u = randn(1, d)*sigma;
v = randn(1, d);
step = u./abs(v).^(1/beta);
L = 0.01*step;
end

%  边界约束函数
function s = F_simplebounds(s, Lb, Ub)
%  应用简单的边界约束
%  应用下界约束
ns_tmp = s;
I = ns_tmp < Lb;
ns_tmp(I) = Lb(I);
%  应用上界约束
J = ns_tmp > Ub;
ns_tmp(J) = Ub(J);
%  更新新的解
s = ns_tmp;
end

%  目标函数（蛋箱函数）
function z = F_Fun(u)
%  蛋箱函数（egg - crate）
z = (u(1)^2) + (u(2)^2) + (25*(sin(u(1))^2)) + (25*(sin(u(2))^2));
end
