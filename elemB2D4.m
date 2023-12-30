function [J,B] = elemB2D4(x1,y1,x2,y2,x3,y3,x4,y4,ks,yt)
% 返回单元B矩阵，适应于四节点四边形有限元
B = zeros(3,8);
x = [x1,x2,x3,x4]';
y = [y1,y2,y3,y4]';
[N_ks,N_yt] = dfun2D(ks,yt,4);
J = jacobi2D(x,y,N_ks,N_yt);

for n = 1:4
    N_cor = J\[N_ks(n);N_yt(n)];
    B(1,2*n-1) = N_cor(1);
    B(2,2*n) = N_cor(2);
    B(3,2*n) = N_cor(1);
    B(3,2*n-1) = N_cor(2);
end
