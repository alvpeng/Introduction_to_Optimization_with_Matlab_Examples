% 例程 15.5  投影次梯度法示例
%  生成数据
n = 100;
m = 100;
A = randn(m, n);
u = sprandn(n, 1, 0.1);
b = A*u;
%  初始化
xcur = zeros(n, 1);
maxiter = 200;
fvals = 0.5*norm(b)^2;
fmin = fvals;
xmin = xcur;
%  保存每次迭代的最小目标函数值
fminvals = zeros(maxiter, 1);
%  主循环
for i = 1:maxiter
    alpha = 0.025/sqrt(i);
    res = (A*xcur - b);
    subg = A'*res;
    %  目标函数的（次）梯度，向正卦限投影（非负约束）
    xcur = max(0, xcur - alpha*subg);
    %  计算当前目标函数值
    fcur = 0.5*norm(res)^2;
    if (fcur < fmin)
        fmin = fcur;
        xmin = xcur;
    end
    fminvals(i) = fmin;
end
%  结果展示
figure(1)
plot(fminvals);
xlabel('迭代次数');  ylabel('Fmin');
figure(2)
stem(xmin);
ylabel(' x 轴坐标');
