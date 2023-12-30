function [J,B] = elemB2D8(x,y,ks,yt)
% 返回单元B矩阵，适应于四节点四边形有限元
B = zeros(3,16);
[N_ks,N_yt] = dfun2D(ks,yt,8);
J = jacobi2D(x,y,N_ks,N_yt);

for n = 1:8
    N_cor = J\[N_ks(n);N_yt(n)];
    B(1,2*n-1) = N_cor(1);
    B(2,2*n) = N_cor(2);
    B(3,2*n) = N_cor(1);
    B(3,2*n-1) = N_cor(2);
end
