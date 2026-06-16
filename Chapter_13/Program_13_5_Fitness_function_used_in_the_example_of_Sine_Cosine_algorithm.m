% 例程 13.5  正弦余弦算法示例中使用的适应度函数
%  函数定义
function  fitness = objFit(x)
fitness = x(1)^2 + x(2)^2 + (25*(sin(x(1))^2 + sin(x(2))^2));
end
