% 例程 1.4  带标注的等高线
m = -3: 0.05: 3;
[vx1, vx2] = meshgrid(m);
z = (vx1.^2) + (vx2.^2);
[C, H] = contour(vx1, vx2, z);
figure(1)
clabel(C, H, 'FontSize', 12);
xlabel('x1');
ylabel('x2');
