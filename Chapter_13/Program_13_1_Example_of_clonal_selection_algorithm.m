% 例程 13.1  克隆选择算法示例
Np = 50;  %  种群规模
gen = 30;  %  迭代代数
pm = 0.1;  %  突变概率
d = 0.1;  %  种群随机重置比例
beta = 0.1;  %  克隆比例
%  生成抗体种群（二进制串）
AB = 2.*rand(Np, 44) - 1;
for i = 1: Np
    for j = 1:44
        if AB(i, j) >0
            AB(i, j) = 1;
        else
            AB(i, j) = 0;
        end
    end
end
%  初始参数设置
Lb = -32;  %  下界
Ub = 32;  %  上界
fbest = 0;  %  全局最优目标函数值（最小值）
%  目标函数绘图（调用函数）
x = meshgrid(linspace(Lb, Ub, 61));
y = meshgrid(linspace(Lb, Ub, 61))';
vxp = x;
vyp = y;
vzp = Fobj([x(:), y(:)]);
vzp = reshape(vzp, size(x));
figure(1)
contour(vxp, vyp, vzp, 20);
hold on;
%  解码（调用函数）
x = Dcod(AB(:, 1:22), Lb, Ub);
y = Dcod(AB(:, 23: end), Lb, Ub);
fit = Fobj([x(:), y(:)]);
%  绘制初始种群
plot3(x, y, fit', 'k*');
%  高频突变参数
pma = pm;  %  初始值
pmr = 0.8;  %  突变率控制系数
itpm = gen;  %  突变率恢复迭代间隔
vfx = zeros(gen, 1);
figure(2)
contour(vxp, vyp, vzp, 20);
hold on;
%  主循环
for iter = 1: gen
    %  解码
    x = Dcod(AB(:, 1: 22), Lb, Ub);
    y = Dcod(AB(:, 23: end), Lb, Ub);
    fit = Fobj([x(:), y(:)]);
    % 绘制当前解
    plot3(x, y, fit', 'b. ');
    %  选择操作
    [a, ix] = sort(fit);
    valx = x(ix);
    valy = y(ix);
    %  克隆操作
    T = [];
    cs = zeros(Np, 1);
    pcs = zeros(Np, 1);
    for  i = 1:Np
        cs(i) = round(beta*Np);
        pcs(i) = sum(cs);
        T = [T; ones(cs(i), 1)*AB(ix(end - i + 1), :)];
    end
    %  高频突变操作
    M = rand(size(T, 1), 44) <= pm;
    T = T - 2.*(T.*M) + M;
    T(pcs, :) = AB(fliplr(ix), :);
    %  解码
    x = Dcod(T(:, 1:22), Lb, Ub);
    y = Dcod(T(: , 23: end), Lb, Ub);
    fit = Fobj([x(:), y(:)]);
    %  重选择操作
    aux = [0, pcs'];
    pcs = aux';
    for  i = 1: Np
        [aux, index] = min(fit(pcs(i) + 1:pcs(i + 1)));
        bcs(i) = index;
        bcs(i) = bcs(i) + pcs(i);
    end
    %  插入操作（更新种群）
    AB(fliplr(ix), :) = T(bcs, :);
    %  受体库更新（随机重置部分种群）
    nedit = round(d*Np);
    %  生成新的随机抗体
    ZB = 2.*rand(nedit, 44) - 1;
    for i = 1: nedit
        for j = 1:44
            if ZB(i, j) > 0
                ZB(i, j) = 1;
            else
                ZB(i, j) = 0;
            end
        end
    end
    AB(ix(end - (nedit - 1): end), :) = ZB;
    if rem(iter, itpm) == 0
        pm = pm*pmr;
        if rem(iter, 10*itpm) == 0
            pm = pma;
        end
    end
    vfx(iter) = a(1);
    %  主循环结束
end
%  结果展示
figure(3)
Lb = -5;
Ub = 5;
nx = meshgrid(linspace(Lb, Ub, 61));
ny = meshgrid(linspace(Lb, Ub, 61))';
vxp = nx;
vyp = ny;
vzp = Fobj([nx(:), ny(:)]);
vzp = reshape(vzp, size(nx));
colormap('jet');
contour(vxp, vyp, vzp, 30);
hold on;
plot3(x, y, fit', 'r*');
figure(4)
plot(vfx);
xlabel('迭代次数');  ylabel('最优函数值 f(x,y)');
%  数值结果输出
x = valx(1)
y = valy (1)
fx = vfx(end)

%  解码函数
function  z = Dcod(AB, Lb, Ub)
AB = fliplr(AB);
s = size(AB);
aux = 0:1:21;
aux = ones(s(1), 1)*aux ;
x1 = sum((AB.*2.^ aux), 2);
%  将值映射到上下界之间
z = Lb + x1'.*(Ub - Lb) / (2^22 - 1);
end

%  目标函数（Ackley函数）
function z = Fobj(xx)
d = size(xx, 2);
z = -20*exp( -0.2*sqrt(1/d*sum(xx.^2, 2))) - ...
    exp(1/d*sum(cos(2*pi*xx), 2)) + 20 + exp(1);
end