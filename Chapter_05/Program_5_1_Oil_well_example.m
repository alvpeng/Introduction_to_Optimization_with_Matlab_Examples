% 例程 5.1  油井实例
%  说明：下标从 1 到 4 运行，而非数学公式中的 0 到 3
%  初始化变量
u = zeros(4, 1);  x = zeros(4, 1);  v = zeros(4, 1);
x(1) = 1000;  %  初始原油储量
%  设定各年油价
p = [20; 22; 30; 25];
%  定义符号变量与符号函数
syms  su  sx  vv  mxu;
sV = zeros(4, 1);
sV = sym(sV);
sq = zeros(3, 1);
sq = sym(sq);
%  符号函数求解核心逻辑
sV(4) = (p(4)*sx) - (0.05*(sx^2));
%  逆向求解 sV(3) 至 sV(1)（对应数学公式中V2至V0）
for nn = 3: -1: 1
    vv = subs(sV(nn + 1), sx, sx - su);
    sq(nn) = (p(nn)*su) - (0.05*(su^2)) + (0.9*vv);
    dq = diff(sq(nn), su);
    mxu(nn) = solve(dq, su );  %  求解导数为零的点，即最优开采量su
    sV(nn) = subs(sq(nn), su, mxu(nn));
end
%  计算数值结果
for m = 1: 3
    u(m) = subs(mxu(m), sx, x(m));
    v(m) = subs(sV(m), sx, x(m));
    x(m + 1) = x(m) - u(m);
end
v(4) = subs(sV(4), sx, x(4));
u(4) = x(4);
figure(1)
plot(u, 'rx-');
hold on;
plot(x, 'bd-');
xlabel('年份');
grid on;
figure(2)
plot(v, 'ko-');
xlabel('年份');
grid on;
