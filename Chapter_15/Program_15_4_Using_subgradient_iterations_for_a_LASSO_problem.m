% 例程 15.4  次梯度迭代法求解 LASSO 问题
%  生成数据
n = 1024;
m = 512;
A = randn(m, n);
u = sprandn(n, 1, 0.1);
b = A*u;
%  参数设置
s = 0.00028;
maxiter = 300;
count_num = 6;
count_alpha = 10;
%  初始化
Frec = zeros(1, maxiter*count_num);
lambda = 1e-3;
x0 = rand(n, 1);
ATA = A'*A;
ATb = A'*b;
lambdai = lambda*count_alpha^(count_num - 1);
x = x0;
Ni = 1;
%  主循环
for i = 1: count_num
    for j = 1: maxiter
        x = x - s*g(x, ATA, ATb, lambdai);
        Frec(Ni) = F(x, A, b, lambdai);
        Ni = Ni + 1;
    end
    if i < count_num
        lambdai = lambdai/count_alpha;
    end
end
%  结果展示
figure(1)
plot(log(Frec(1:10:end)), 'r.');
xlabel('num - iter/10');  ylabel('log(F)');
out.val = F(x, A, b, lambdai);
out.s = s;
out.lambda = lambdai;
out
