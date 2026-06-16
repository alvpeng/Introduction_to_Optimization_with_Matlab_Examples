% 例程 16.3  灰度图像的高通滤波
%  拉普拉斯滤波器
%  将图像文件读取到矩阵中
cpic = imread('APnewyork.jpg');
fil = fspecial('laplacian', 0.3);  %  滤波器模板
fc = filter2(fil, cpic);
%  转换为无符号8位整数
bfc = uint8(round(abs(fc)));
abfc = imadjust(bfc, [0.1, 0.7], []);  %  图像对比度调整
figure(1)
imshow(abfc);
