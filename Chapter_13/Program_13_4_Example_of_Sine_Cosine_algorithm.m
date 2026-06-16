% 例程 13.4  正弦余弦算法示例
%  正弦余弦算法（SCA）示例
Nsa = 50;  %  搜索代理数量（种群规模）
max_iteration = 20;
dim = 2;  %  搜索空间维度
Lb = -5;  Ub = 5;  %  变量上下边界
X = Lb + (rand(Nsa, dim).*(Ub - Lb));  %  初始化代理位置
Dest_pos = zeros(1, dim);
Dest_fit = inf;
BestVal = zeros(1, max_iteration);
objV = zeros(1, size(X, 1));
%  计算初始种群的适应度值，并找到最优个体
for i = 1: size(X, 1)
    objV(1, i) = objFit(X(i, :));
    if i == 1
        Dest_pos = X(i, :);
        Dest_fit = objV(1, i);
    elseif objV(1, i) < Dest_fit
        Dest_pos = X(i, :);
        Dest_fit = objV(1, i);
    end
end
BestVal(1) = Dest_fit;
%  主循环
iter = 2;  %  迭代计数器（第1次迭代已用于初始化）
while iter <= max_iteration
    a = 2;
    %  r1 从a线性递减至0：
    r1 = a - iter*((a)/max_iteration);
    %  相对于目标位置更新所有解的位置
    for i = 1: size(X, 1)  %  遍历第i个解
        for j = 1:size(X, 2)  %  遍历第j个维度
            %  更新随机参数 r2, r3, r4
            r2 = (2* pi)*rand(1);
            r3 = 2*rand(1);
            r4 = rand(1);
            if r4 < 0.5
                X(i, j) = X(i, j) + (r1*sin(r2)*abs(r3*Dest_pos(j) - X(i, j)));
            else
                X(i, j) = X(i, j) + (r1*cos(r2)*abs(r3*Dest_pos(j) - X(i, j)));
            end
        end
    end
    for i = 1: size(X, 1)
        %  若解超出边界，则拉回边界内
        Flag4ub = X(i, :) > Ub;
        Flag4lb = X(i, :) < Lb;
        X(i, :) = (X(i, :).*(~(Flag4ub + Flag4lb))) + Ub.*Flag4ub + Lb.*Flag4lb;
        %  计算目标函数值
        objV(1, i) = objFit(X(i, :));
        %  若找到更优解，更新目标位置（最优位置）
        if objV(1, i) < Dest_fit
            Dest_pos = X(i, :);
            Dest_fit = objV(1, i);
        end
    end
    BestVal(iter) = Dest_fit;
    iter = iter + 1;
end
Dest_fit
Dest_pos
figure(1)
colormap('jet');
[xx, yy] = meshgrid(Lb: 0.2: Ub, Lb: 0.2: Ub);
zz = xx.^2 + yy.^2 + (25*(sin(xx).^2 + sin(yy).^2));
contour(xx, yy, zz, 26);
hold on;
for  i = 1: Nsa
    plot(X(i, 1), X(i, 2), 'ko');
end
xlabel('X');  ylabel('Y');
figure(2)
plot(0: 1: max_iteration - 1, BestVal(:), 'm');
xlabel('迭代次数');  ylabel('最优结果');

%  函数定义
function  fitness = objFit(x)
fitness = x(1)^2 + x(2)^2 + (25*(sin(x(1))^2 + sin(x(2))^2));
end
