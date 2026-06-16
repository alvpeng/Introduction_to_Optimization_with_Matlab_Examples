% 例程 2.26  高斯-牛顿方法
%  模型拟合
%  待拟合数据（列向量）
t = [1, 2, 4, 5, 8]';
y = [3, 4, 6, 11, 20]';
%  预分配内存
N = length(t);
f = zeros(N, 1);
J = zeros(N, 2);
%  模型为 y = x1*exp(x2*t)
%  模型参数的初始值
x1 = 6;
x2 = 0.1;
%  迭代步骤
for M = 1:6
    %  计算残差函数值
    for n = 1: N
        f(n) = y(n) - (x1*exp(x2*t(n)));  %  残差
    end
    %  计算雅可比矩阵值
    for n =1: N
        J(n, 1) = -exp(x2*t(n));
        J(n, 2) = -(x1*t(n))*exp(x2*t(n));
    end
    %  高斯-牛顿步计算
    delta = (J'*J)\(-J'*f);
    x1 = x1 + delta(1);
    x2 = x2 + delta(2);
end
%  模型拟合结果可视化
figure(1)
%  绘制原始数据
plot(t, y, 'rx');
hold on;
%  绘制拟合模型曲线
tm = 0: 0.2: 10;
ym = x1*exp(x2*tm);
plot(tm, ym, 'k');
xlabel('t');  ylabel('y');
