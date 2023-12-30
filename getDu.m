function stress= getDu(B,D,u,elem,ndim,sumNode,sumElem,mnode)


if ndim == 2
    nip = 4;
else
    nip = 8;
end
ndimB = ndim*3-3;  % 单元B矩阵的维数，二维为3，三维为6
s = zeros(sumElem*nip*4,1);

% [nodeNdfID,~,rst] = find(u);
% u = zeros(ndim*sumNode,1);
% u(nodeNdfID) = rst;
% u = reshape(u,ndim,[]);

dbu = zeros(nip*4,1);

for n = 1:sumElem
    elemU = u(:,elem(n,:));
    elemU = [elemU(1,:);zeros(ndim,mnode);elemU(2,:)];
    elemU = reshape(elemU,ndim,[]);
    BU = B(ndimB*nip*(n-1)+1:ndimB*nip*n,:)*elemU';
    for m = 1:nip
        dbu((m-1)*4+1:m*4) = [BU(m*3-2,1);BU(m*3-1,2);BU(m*3,1);BU(m*3,2)]; % u_x;v_y;u_y;v_x
    end
    s(4*nip*(n-1)+1:4*nip*n) = dbu;
end

s = reshape(s,4,[])';
if ndim == 2
        a = 1+sqrt(3)/2;b = -1/2;c = 1-sqrt(3)/2;
        invs = [a,b,b,c;b,a,c,b;c,b,b,a;b,c,a,b];
        % invs = [1,0,0,0;0,1,0,0;0,0,0,1;0,0,1,0];
end

for n = 1:sumElem
    s(nip*(n-1)+1:nip*n,:) = invs*s(nip*(n-1)+1:nip*n,:);  % 按单元排序的应力值
end

stress = zeros(sumNode,4);
nodeMes = zeros(sumNode,1);
for n = 1:sumElem
    nodeMes(elem(n,:)) = nodeMes(elem(n,:))+1;
    stress(elem(n,1:nip),:) = stress(elem(n,1:nip),:)+s(nip*(n-1)+1:nip*n,:);
end

stress = stress./nodeMes;
if ndim == 2
    if mnode == 8
        stress(elem(:,5),:) = (stress(elem(:,1),:)+stress(elem(:,2),:))/2;
        stress(elem(:,6),:) = (stress(elem(:,2),:)+stress(elem(:,3),:))/2;
        stress(elem(:,7),:) = (stress(elem(:,3),:)+stress(elem(:,4),:))/2;
        stress(elem(:,8),:) = (stress(elem(:,4),:)+stress(elem(:,1),:))/2;
    end
end

% mises = zeros(sumNode,1);
% smax = (stress(:,1)+stress(:,2))./2+sqrt(((stress(:,1)-stress(:,2))./2).^2+stress(:,3).^2);
% smin = (stress(:,1)+stress(:,2))./2-sqrt(((stress(:,1)-stress(:,2))./2).^2+stress(:,3).^2);
% 
% 
% mises = sqrt((smax.^2+smin.^2+(smax-smin).^2)./2);


