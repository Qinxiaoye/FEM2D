% function  main()
clear;
tic
% read the element and boundary condation 
fprintf(1,'read the modal\n')
node = load('NLIST.DAT');
sumNode = size(node,1);
elem = load('ELIST.DAT');
sumElem = size(elem,1);
fixNode = load('fixNode.dat');
nodeForce = load('nodeForce.dat'); % 节点力
nodeForce(1,:) = [];

% -------------------------------------------------------------------------
mat = [200000,0.3;]; % 弹性模量、泊松比, 多种材料需要换行
ndim = 2;isStress = 1; % 平面应力还是平面应变，为1时为平面应力

h = 1;   % 应用于二维问题，默认是1

matID  = elem(:,2); % elem的第二列为材料编号
EX = mat(matID,1); % 每个单元的杨氏模量
mu = mat(matID,2); % 每个单元的泊松比

elem(:,1:2) = [];
node(:,1)   = [];
node = node(:,1:ndim);

mnode = size(elem,2);  % 单元类型

if mnode == 4
    reduce = 0;  % 是否采用减缩积分，为1表示就采用减缩积分，0表示全积分。
else
    reduce = 1;  
end

% ---------------------------转化压强---------------------------------------
if exist('press.dat','file')
    fprintf(1,'trans the pressure\n')
    nodeForceNew = transPres(node,elem,ndim,mnode);
    nodeForce = [nodeForce;nodeForceNew];
end

% ----------------------------形成总体刚度阵--------------------------------
fprintf(1,'sort the global K\n')
if ndim == 2
    [GK_u,GK_v,GK_a,B,D] = globalK2D(EX,mu,h,elem,node,isStress,reduce,mnode);
end
% ----------------------------第一类边界条件-----------------------------------
fprintf(1,'boundary condition\n')

% 对角元改1法施加第一类边界条件
[GK,force] = boundary_chang_one(GK_u,GK_v,GK_a,fixNode,nodeForce,sumNode,ndim);

% ----------------------------求解方程--------------------------------------
fprintf(1,'solve the equation\n')
u = GK\force;
% 将计算所得结果改成非稀疏形式
[nodeNdfID,~,rst] = find(u);
u = zeros(ndim*sumNode,1);
u(nodeNdfID) = rst;
u = reshape(u,ndim,[]);
if mnode == 4 && reduce == 0
    [s,mises] = getStress(B,D,u,elem,ndim,sumNode,sumElem,mnode);
elseif mnode == 8 && reduce == 1
    [s,mises] = getStress(B,D,u,elem,ndim,sumNode,sumElem,mnode);
else
    fprintf(1,'不计算应力\n')
end
u = u';

% 显示结果
% ux
figure
axis equal;
showContour(node,elem,u(:,1));
axis off;
% uy
figure
axis equal;
showContour(node,elem,u(:,2));
axis off;
% von-Mises stress
figure
axis equal;
showContour(node,elem,mises);
axis off;
disp('solution is done')