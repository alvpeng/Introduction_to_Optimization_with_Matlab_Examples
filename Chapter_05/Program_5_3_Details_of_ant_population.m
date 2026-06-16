% 例程 5.3  蚁群种群模型细节
%   模型参数与变量定义
A = 0.0131;
B = 0.000228;
dw = 0;
dq = 0;
w = zeros(150, 1);  q = zeros(150, 1);  u = zeros(150, 1);
y = zeros(150, 1);  H = zeros(150, 1);
w(1) = 1000;
aux = (1/B)*log(A/(A - B));
ts = 150 - round(aux);  %  切换时刻（取整近似）
kappa = exp(-(A - B)*ts);
k = (1 - (A*kappa))/A;
for  nn = 1: ts
    u(nn) = 1;
    y(nn) = k + (exp(-(A - B)*nn));
    H(nn) = (A - B)*y(nn)*w(nn);
    dw = (A*u(nn)*w(n)) - (B*w(nn));
    dq = (1 - u(nn))*w(nn);
    w(nn + 1) = w(nn) + dw;
    q(nn + 1) = q(nn) + dq;
end
for nn = ts:149
    u(nn) = 0;
    y(nn) = (1 - exp(-(B*(150 - nn))))/B;
    H(nn) = (1 - (B*y(nn)))*w(nn);
    dw = (A*u(nn)*w(nn)) - (B*w(nn));
    dq = (1 - u(nn))*w(nn);
    w(nn + 1) = w(nn) + dw;
    q(nn + 1) = q(nn) + dq;
end
figure(1)
subplot(2, 2, 1)
plot(w, 'b');
xlabel('天数');  ylabel('w(t)');
subplot(2, 2, 2)
plot(q, 'r');
xlabel('天数');  ylabel('q(t)');
subplot(2, 2, 3)
plot(y, 'k');
xlabel('天数');  ylabel('y(t)');
subplot(2, 2, 4)
plot(H, 'm');
xlabel('天数');  ylabel('H(t)');
