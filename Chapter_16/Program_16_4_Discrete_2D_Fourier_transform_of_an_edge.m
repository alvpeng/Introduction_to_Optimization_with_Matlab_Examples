% 例程 16.4  边缘的二维离散傅里叶变换
%  简单边缘的离散傅里叶变换
fedg = [ones(256, 128), zeros(256, 128)];  %  生成简单边缘图像
Ffg = fftshift(fft2(fedg));  %  傅里叶变换
M = max(max(Ffg));  %  求取变换结果的最大值
sFfg = (256*Ffg/M);  %  归一化处理
figure(1)
subplot(1, 2, 1)
%  绘制带有简单边缘的二值图像
imshow(fedg);
ylabel('原始图像', 'FontSize', 14);
subplot(1, 2, 2)
imshow(abs(sFfg));  %  绘制傅里叶变换结果
ylabel('离散傅里叶变换结果', 'FontSize', 14);
