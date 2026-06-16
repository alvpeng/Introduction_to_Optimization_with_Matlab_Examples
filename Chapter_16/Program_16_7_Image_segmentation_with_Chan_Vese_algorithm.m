% 例程 16.7  基于陈-维塞算法的图像分割
I = imread('hooper1.jpg');  %  读取黑白图像
I = double(I);
[m, n] = size(I);
lambda = 100;  %  可调参数
%  初始化框内值为1，边界值为-1
Phi = ones(m,n);
Phi(1, 1: n) = -1;
Phi(m, 1: n) = -1;
Phi(1: m, 1) = -1;
Phi(1: m, n) = -1;
%  准备循环
disp(' working... ');
a = 0.01;  %  避免除零错误
epl = 0.2;  %  小常数
T = 5;
dt = 0.1;
for  t = 0: dt: T
    ax2 = 2*Phi;
    P1 = Phi(:, [2: n, n]);
    P2 = Phi([2:m, m], :);
    P3 = Phi(:, [1, 1:n - 1]);
    P4 = Phi([1, 1:m - 1], :);
    %  偏导数（近似计算）
    Phi_x = (P1 - P3)/2;
    Phi_y = (P2 - P4)/2;
    Phi_xx = P1 - ax2 + P3;
    Phi_yy = P2 - ax2 + P4;
    Q1 = Phi([2: m, m], [2:n, n]);
    Q2 = Phi([1, 1:m - 1], [1, 1:n - 1]);
    Q3 = Phi([1 ,1:m -1] ,[2:n,n ]);
    Q4 = Phi([2: m, m], [1, 1:n - 1]);
    Phi_xy = (Q1 + Q2 - Q3 - Q4)/4;
    %  全变差（TV）项
    Num = (Phi_xx.*Phi_y.^2) - (2*Phi_x.*Phi_y.*Phi_xy) + (Phi_yy.*Phi_x.^2);
    Den = (Phi_x.^2 + Phi_y.^2).^(3/2) + a;
    %  计算平均值
    c_in = sum([Phi > 0].*I )/(a + sum([Phi > 0]));
    c_out = sum([ Phi < 0].*I)/(a + sum([ Phi < 0]));
    %  更新水平集函数
    aux = (Num./Den - lambda*(I - c_in).^2  + lambda*(I - c_out).^2);
    Phi = Phi + dt*epl./(pi*(epl^2 + Phi.^2)).*aux;
end
%  结果显示
figure(1)
imagesc(I);
title('原始图像');
colormap gray;
figure(2)
imagesc(Phi);
title('水平集');
colormapcool;
figure(3)
title('陈-维塞分割');
aux = zeros(m, n);
for i = 1:m
    for j = 1:n
        aux(i, j) = Phi(m + 1 - i, j);
    end
end
contour(aux, 12, 'LineWidth', 2);
colormap gray;
