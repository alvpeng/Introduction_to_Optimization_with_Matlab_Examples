% 例程 5.2  工蚁与蚁后种群数量模型（种群演化依赖于模型参数）
%  模型参数与变量定义
A = 0.0131;
B = 0.000228;
dw = 0;
dq = 0;
w = zeros(150, 1);  q = zeros(150, 1);  u = zeros(150, 1);  y = zeros(150, 1);
w(1) = 1000;
for nn = 1:149
    u(nn) = 0.99;
    dw = (A*u(nn)*w(nn)) - (B*w(nn));
    dq = (1 - u(nn))*w(nn);
    w(nn + 1) = w(nn) + dw;
    q(nn + 1) = q(nn) + dq;
end
aux = (1/B)*log(A/(A - B))
figure(1)
plot(w, 'b');
hold  on;
plot(q, 'r');
xlabel('days');  ylabel('w(t), q(t)');
grid on;
