function nodeForceNew = transPres(node,elem,ndim,mnode)
% 将压强转化为等效节点力
% 单元受压为正
% 只记法向力,不计切向力
% 解析表达，可以用数值积分计算，会更简单
% mnode == 4
% 4----3
% |    |
% |    |
% 1----2
% mnode == 8
% 4--7--3
% |     |
% 8     6
% |     |
% 1--5--2
press = load('press.dat');
sumPre= size(press,1);
if ndim == 2
    if mnode == 4
        nodeForceNew = zeros(4*sumPre,3);
    else
        nodeForceNew = zeros(6*sumPre,3);
    end
end
elemP = press(:,1); % 单元编号
face  = press(:,2); % 面号
pres  = press(:,3); % 压力值，正值表示受压

if ndim == 2
    if mnode == 4
        faceNode = [1,2;2,3;3,4;4,1];
        for n = 1:sumPre
            bNode = elem(elemP(n),faceNode(face(n),:)); % 单元的边界节点
            nodeForceNew(4*n-3,1) = bNode(1);
            nodeForceNew(4*n-2,1) = bNode(1);
            nodeForceNew(4*n-1,1) = bNode(2);
            nodeForceNew(4*n-0,1) = bNode(2);
            nodeForceNew(4*n-3,2) = 1;
            nodeForceNew(4*n-2,2) = 2;
            nodeForceNew(4*n-1,2) = 1;
            nodeForceNew(4*n-0,2) = 2;
            nodeForceNew(4*n-3,3) = 0.5*pres(n)*(node(bNode(1),2)-node(bNode(2),2));
            nodeForceNew(4*n-2,3) = 0.5*pres(n)*(node(bNode(2),1)-node(bNode(1),1));
            nodeForceNew(4*n-1,3) = 0.5*pres(n)*(node(bNode(1),2)-node(bNode(2),2));
            nodeForceNew(4*n-0,3) = 0.5*pres(n)*(node(bNode(2),1)-node(bNode(1),1));
        end
    elseif mnode == 8
        faceNode = [1,2,5;2,3,6;3,4,7;4,1,8];
        for n = 1:sumPre
            bNode = elem(elemP(n),faceNode(face(n),:));
            nodeForceNew(6*n-5,1) = bNode(1);
            nodeForceNew(6*n-4,1) = bNode(1);
            nodeForceNew(6*n-3,1) = bNode(2);
            nodeForceNew(6*n-2,1) = bNode(2);
            nodeForceNew(6*n-1,1) = bNode(3);
            nodeForceNew(6*n-0,1) = bNode(3);
            nodeForceNew(6*n-5,2) = 1;
            nodeForceNew(6*n-4,2) = 2;
            nodeForceNew(6*n-3,2) = 1;
            nodeForceNew(6*n-2,2) = 2;
            nodeForceNew(6*n-1,2) = 1;
            nodeForceNew(6*n-0,2) = 2;
            nodeForceNew(6*n-5,3) = pres(n)*(1/2*node(bNode(1),2)+1/6*node(bNode(2),2)-2/3*node(bNode(3),2));
            nodeForceNew(6*n-4,3) = -pres(n)*(1/2*node(bNode(1),1)+1/6*node(bNode(2),1)-2/3*node(bNode(3),1));
            nodeForceNew(6*n-3,3) = -pres(n)*(1/6*node(bNode(1),2)+1/2*node(bNode(2),2)-2/3*node(bNode(3),2));
            nodeForceNew(6*n-2,3) = pres(n)*(1/6*node(bNode(1),1)+1/2*node(bNode(2),1)-2/3*node(bNode(3),1));
            nodeForceNew(6*n-1,3) = pres(n)*(2/3*node(bNode(1),2)-2/3*node(bNode(2),2));
            nodeForceNew(6*n-0,3) = -pres(n)*(2/3*node(bNode(1),1)-2/3*node(bNode(2),1));
        end
    end
end








