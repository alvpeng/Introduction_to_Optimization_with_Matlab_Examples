% 例程 4.15  基于符号计算 MATLAB 的有限元法示例
%  读取STL文件（几何模型）
oPDE = createpde(1);
importGeometry(oPDE, 'Block.STL');
figure(1)
pdegplot(oPDE, 'FaceLabels', 'on', FaceAlpha = 0.3);
%  偏微分方程系数（热传导拉普拉斯方程）
c = 1e-1;
a = 0;
f = 0;
%  边界条件设置
%  外界环境温度
extTemp = 10;
%  对流换热系数
hc = 0.3;
%  需设置对流边界的侧面（2-5号面）
sideFace = 2:5;
protrusionFace = oPDE.Geometry.NumFaces;
%  施加对流边界条件
oPDE.applyBoundaryCondition('Face', ...
[sideFace, protrusionFace], 'q', hc, 'g', extTemp);
%  存在热源的面（1号和6号面）
inpFaces = [1, 6];
%  为热源面设置单位热通量边界条件
oPDE.applyBoundaryCondition('Face', inpFaces, 'g', 1);
%  网格划分
oPDE.generateMesh('hmax', 5);
%  求解
result = assempde(oPDE, c, a, f);
%  结果显示
figure(2)
pdeplot3D(oPDE, 'colormapdata', result);
