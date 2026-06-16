% 例程 4.12  沿最速降线的勒让德条件
%  最速降线曲线
%  及勒让德条件验证
X0 = 1;  Y0 = 10;  %  坐标原点偏移量
t = 0: 0.1: 2;
K1 = 8;
K2 = 2;
g = 9.8; 
y = (K1/2)*(1 - cos(2*t));
x = (K1/2)*((2*t) - sin(2*t)) + K2;
aux = sqrt(2*g*K1)*K1;
lg = (1/aux)*y;
%  绘图展示
subplot(2, 1, 1)
plot([0, 25], [0, 0], 'k');
hold on;
plot([0, 0], [0, 12], 'k');
axis([0, 25, 0, 12]);
plot(X0 + x, Y0 - y, 'r');
xlabel('x');  ylabel('最速降线');
subplot(2, 1, 2)
plot([0, 25], [0, 0], 'k');
hold on;
plot([0, 0], [0, 0.2], 'k');
plot(X0+x, lg, 'b');
xlabel('x');  ylabel('勒让德条件值');
