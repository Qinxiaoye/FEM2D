function J = jacobi2D(x,y,N_ks,N_yt)
% 求jacobi 矩阵
% 四节点四边形

% [N_ks,N_yt] = dfun2D(ks,yt); 在elemB中已经求得
J = [N_ks,N_yt]'*[x,y];
