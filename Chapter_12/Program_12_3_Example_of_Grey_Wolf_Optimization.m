% 例程 12.3  灰狼优化算法示例
Npar = 2;
VarLow = [-5, -5];
VarHigh = [5, 5];
%  算法参数
WolfSize = 50;
MaxIter = 30;
%  初始化最优解（alpha狼）为随机值
alpha.Position = rand(1, Npar).*(VarHigh - VarLow) + VarLow;
alpha.Fit = objFit(alpha.Position);
GB = alpha.Fit;
%  预分配内存空间（存储狼群位置和适应度）
X = repmat(struct('Position', zeros(1, Npar), 'Fit', zeros(1, Npar)), WolfSize, 1);
%  绘制二维等高线图的准备工作
[xx, yy] = meshgrid(VarLow(1): 0.1: VarHigh(1), VarLow(2): 0.1: VarHigh(2));
zz = xx.^2 + yy.^2 + (25* sin(xx).^2 + sin(yy).^2);
%  初始化狼群
X(1) = alpha;  %  第一只狼设为初始alpha狼
for  nn = 2: WolfSize
    %  初始化狼群中其他狼的位置
    X(nn).Position = rand(1, Npar).*(VarHigh - VarLow) + VarLow;
    %  计算初始解的适应度
    X(nn).Fit = objFit(X(nn).Position);
    %  更新alpha狼（保留最优解）
    if (X(nn).Fit < alpha.Fit)
        alpha.Position = X(nn).Position;
        alpha.Fit = X(nn).Fit;
    end
end
%  绘制狼群初始位置
figure(1)
contour(xx, yy, zz, 20);
hold on;
for i = 1: WolfSize
    plot(X(i).Position(1), X(i).Position(2), 'or');
end
xlabel('X');  ylabel('Y');
%  按适应度升序排序狼群（适应度越小越优）
[nnx, sortind] = sort([X.Fit]);
X = X(sortind);
%  初始化alpha、beta、delta狼（前三优个体）
alpha = X(1);
Beta = X(2);
delta = X(3);
%  初始化A和C向量（GWO核心系数）
a = 2*ones(1, Npar);
A1 = 2*rand(1, Npar).*a - a;
A2 = 2*rand(1, Npar).*a - a;
A3 = 2*rand(1, Npar).*a - a;
C1 = 2*rand(1, Npar);
C2 = 2*rand(1, Npar);
C3 = 2*rand(1, Npar);
%  主循环
for  jj = 1:MaxIter
    for  ii = 1:WolfSize
        %  计算包围向量（当前狼与alpha/beta/delta狼的距离）
        Da = abs(C1.*alpha.Position - X(ii).Position);
        Db = abs(C2.*Beta.Position - X( ii).Position);
        Dd = abs(C3.*delta.Position - X(ii).Position);
        %  更新狼的位置
        X1 = alpha.Position - A1.*Da;
        X2 = Beta.Position - A2.*Db ;
        X3 = delta.Position - A3.*Dd;
        X(ii).Position = (X1 + X2 + X3)/3;
        %  约束检查（确保位置在变量上下界内）
        X(ii).Position = limiter(X(ii).Position, VarHigh, VarLow);
        %  更新当前狼的适应度
        X(ii).Fit = objFit(X(ii).Position);
        %  更新alpha狼（若当前狼更优）
        if  X(ii).Fit < alpha.Fit
            alpha = X(ii);
        end
    end
    %  按适应度重新排序狼群
    [nnx, sortind] = sort([X.Fit]);
    X = X(sortind);
    %  更新beta和delta狼
    Beta = X(2);
    delta = X(3);
    %  更新A和C向量（a随迭代线性衰减）
    a = 2*(1 - jj/MaxIter);
    A1 = 2*rand(1, Npar).*a - a;
    A2 = 2*rand(1, Npar).*a - a;
    A3 = 2*rand(1, Npar).*a - a;
    C1 = 2*rand(1, Npar);
    C2 = 2*rand(1, Npar);
    C3 = 2*rand(1, Npar);
    %  记录每次迭代的全局最优适应度
    GB = [GB, alpha.Fit];
end;
fprintf('最优值为');
alpha.Position
alpha.Fit
%  绘制狼群最终位置
figure(2)
[xx, yy] = meshgrid(VarLow(1): 0.1: VarHigh(1), VarLow (2): 0.1: VarHigh(2));
zz = xx.^2 + yy.^2 + (25*(sin(xx).^2 + sin(yy).^2));
contour(xx, yy, zz, 20);
hold on;
for i = 1:WolfSize
    plot(X(i).Position(1), X(i).Position(2), 'or');
end
xlabel('X');  ylabel('Y');
%  绘制最优适应度迭代曲线
figure(3)
plot(0: MaxIter, GB, 'm');
xlabel('迭代次数');  ylabel('目标函数');
%  子函数：目标函数（计算适应度）
function  fitness = objFit(x)
fitness = x(1)^2 + x(2)^2 + (25*(sin(x(1))^2 + sin(x(2))^2));
end
