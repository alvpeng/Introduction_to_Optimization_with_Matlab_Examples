% 例程 15.1  函数的LFT可视化
syms  x  a
%  在下方输入待变换的函数
f = sqrt(x);  %  可编辑
Df = diff(f, x);
g = finverse(Df);
h = subs(g, a);  %  得到 x(a) 的显式表达式
m = subs(f, h);  %  将 x(a) 代入原函数，得到 f(x(a))
L = (a*h) - m;
seq = char(L);  %  将符号表达式转换为字符串格式
%  绘图展示
fplot(seq, [0.1, 0.9]);
xlabel('a');
