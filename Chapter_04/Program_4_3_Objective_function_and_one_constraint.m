% 例程 4.3  目标函数与一条约束条件
%  目标函数与约束条件
x3 = 26;
z = 378.5;
N = 140;
vx1 = zeros(1, N);
vx2 = zeros(1, N);
for nn =1: N
x1 = 6.4 + (0.1*nn);
vx1(nn) = x1;
aux = (27*x1) - (x1^2) - (z + 260);
x2 = (45 - sqrt(45^2 + (4*aux)))/2;
vx2(nn) = x2;
end;
figure(1)
%  绘制约束曲线
plot([0, 16], [26, 10], 'k');
hold on;
%  绘制z = 378.5时的目标函数曲线
plot(vx1, vx2, 'r');
%  标注最优解
plot([8.5, 8.5], [10, 17.5], 'b--');
plot(8.5, 17.5, 'k*');
xlabel('x1');  ylabel('x2');
