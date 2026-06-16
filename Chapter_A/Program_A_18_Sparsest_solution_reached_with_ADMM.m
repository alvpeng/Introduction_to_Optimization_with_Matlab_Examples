% A.18(P16.13) 通过 ADMM 得到的最稀疏解
%  求解 Ax=b 的最稀疏解
%  分别使用ADMM求解基追踪（BP）问题，以及ISTA求解Lasso问题
n = 20;
m = 14;
A = randn(m, n);
b = randn(m, 1);
%  基于ADMM的基追踪（BP）算法，用于寻找最稀疏解
niter = 30;
x = zeros(n, 1);
z = zeros(n, 1);
u = zeros(n, 1);
rob = zeros(niter, 1);
alpha = 1.0;
mu = 1.0;
uA = inv(A*A');
aux1 = eye(n) - (A'*uA*A);
aux2 = A'*uA*b;
for nn = 1: niter
    % 更新x
    x = (aux1*(z - u)) + aux2;
    %  更新z
    zo = z;
    xe = (alpha*x) + ((1 - alpha)*zo);
    aux = xe + u;
    imu = 1/mu;
    %  软阈值收缩操作
    z = max(0, aux - imu) - max(0, -aux - imu);
    %  更新u
    u = u + (xe - z);
    %  记录当前x的L1范数
    rob(nn) = norm(x, 1);
end
BPx = x;  %  ADMM-BP得到的解
BProb = rob;  %  ADMM-BP迭代过程中L1范数的变化
%  输出结果
disp('ADMM求解基追踪（BP）：');
disp('x的L1范数：');
norm(x, 1)
disp('残差b - Ax的L2范数：');
V = b - (A*x);
norm(V, 2)
%  基于ISTA的Lasso算法，用于寻找最稀疏解
niter = 60;
J = zeros(1, niter);  %  记录目标函数值
x = 5*randn(n, 1);  %  初始化x
lambda = 0.1;  %  L1正则项系数
alpha = 40;  %  步长参数
T = lambda/2;  %  软阈值阈值
for k = 1: niter
    q = A*x;
    J(k) = sum(abs(b(:) - q(:)).^2) + lambda*sum(abs(x(:)));
    p = x + (A'*(b - q))/alpha;
    %  逐元素软阈值操作
    for  j = 1: n
        if abs(p(j)) <= T
            x(j) = 0;
        else
            if p(j) > T
                x(j) = p(j) - T;
            else
                x(j) = p(j) + T;
            end
        end
    end
end
Lx = x;  %  Lasso-ISTA得到的解
Lrob = J;  %  ISTA迭代过程中目标函数值的变化
%  输出结果
disp('ISTA算法：');
disp('x的L1范数：');
norm(x, 1)
disp('残差b-Ax的L2范数：');
V = b - (A*x);
norm(V, 2)
%  结果可视化
figure(1)
subplot(2, 2, 1)
stem(BPx, 'k');
hold on;
plot([0, 20], [0, 0], 'b');
xlabel('解向量维度');  ylabel('基追踪（BP）');
subplot(2, 2, 2)
plot(BProb, 'r', 'LineWidth', 2);
xlabel('迭代次数');
subplot(2, 2, 3)
stem(Lx, 'k');
hold  on;
plot([0, 20], [0, 0], 'b');
xlabel('解向量维度');  ylabel('ISTA');
subplot(2, 2, 4)
plot(log10(Lrob), 'r', 'LineWidth', 2);
xlabel('迭代次数');
