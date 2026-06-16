% 例程 15.8  邻近点方法示例
m = 50;  %  样本数量
n = 100;  %  特征数量
%  生成数据
x0 = sprandn(n, 1, 0.05);
A = randn(m, n);
%  列归一化
A = A*spdiags(1./sqrt(sum(A.^2))', 0, n, n);
v = sqrt(0.001)*randn(m, 1);
b = A*x0 + v;
gamma_max = norm(A'*b, 'inf');
gamma = 0.1*gamma_max;
ATA = A'*A;
ATb = A'*b;
maxiter = 50;
%  目标函数值轨迹
Fty = zeros(maxiter, 1);
lambda = 1;
beta = 0.5;
x = zeros(n, 1);
for  k = 1: maxiter
    while 1
        grad_x = ATA *x - ATb;
        %  邻近映射操作
        z = prox_l1(x - lambda*grad_x, lambda*gamma);
        qaux = (z - x).^2;
        if pf(A, z, b) <= pf(A, x, b) + grad_x'*(z - x) + (1/(2*lambda))*sum(qaux)
            break;
        end
        lambda = beta*lambda;
    end
    Fty(k, 1) = pf(A, x, b);
    x = z;
end
%  结果展示
figure(1)
plot(log(Fty(:, 1)));
xlabel('迭代次数');  ylabel ('目标函数F的对数值');
figure(2)
stem(x)
xlabel('x的分量');

% 邻近算子
function  x = prox_l1(v, lambda)
%  l1范数的邻近算子
x = max(0, v - lambda) - max(0, -v - lambda);
end


function  [f] = pf(A, x, b)
aux = (A*x - b);
f = 0.5*sum(aux.^2);
end
