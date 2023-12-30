function outputRes(u,s,mises,sumNode,sumElem,node,elem,shapeChangeRat,mnode,ndim)
% 输出结果和云图至文件
% 稳态问题

fout = fopen('solution.txt','w+');
fplt = fopen('solution.plt','w+');

% 判断是否计算了应力
haveS = length(s)>1;
if ndim == 2
    ndimB = 3;
else
    ndimB = 6;
end


a = repmat(' ',1,6);
fprintf(fout,'**The result of the problem\n*disp:');
if ndim == 2
    fprintf(fout,[a,'UX',a,a,a,'UY\n']);
else
    fprintf(fout,[a,'UX',a,a,a,'UY',a,a,a,'UZ\n']);
end



% [nodeNdfID,~,rst] = find(u);
% 
% u = zeros(ndim*sumNode,1);
% u(nodeNdfID) = rst;
% u = reshape(u,ndim,[]);

node(:,1:ndim) = node(:,1:ndim)+shapeChangeRat*u';

% 输出结果至文本文件
fprintf(fout,[repmat('%20.10E',1,ndim),'\n'],u);
if haveS
    if ndim == 2
        fprintf(fout,'*stress:');
        fprintf(fout,[a,'SXX',a,a,'SYY',a,a,a,'SXY','   ',a,a,'VON-MISES\n']);
        fprintf(fout,'%20.10E%20.10E%20.10E%20.10E\n',[s,mises]');
    else
        fprintf(fout,[a,'SXX',a,a,a,'SYY',a,a,a,'SXY\n']);
    end
end

% 输出至云图
if ndim == 2
    fprintf(fplt,'TITLE     = "Finite-Element Data"\n');
    fprintf(fplt,'VARIABLES = "X"\n"Y"\n"X Displacement"\n"Y Displacement"\n');
    if haveS
        fprintf(fplt,'"XX Stress"\n"YY Stress"\n"XY Stress"\n"von-mises"\n');
    end
    fprintf(fplt,'ZONE T="Step 1 Incr 1"\n STRANDID=1, SOLUTIONTIME=1\n');
    fprintf(fplt,' Nodes=%8d, Elements=%8d, ZONETYPE=FEQuadrilateral\n',...
        sumNode,sumElem);
    fprintf(fplt,' DATAPACKING=BLOCK\n DT=(DOUBLE DOUBLE DOUBLE DOUBLE)\n');
else
    fprintf(fplt,'TITLE     = "Finite-Element Data"\n');
    fprintf(fplt,'VARIABLES = "X"\n"Y"\n"Z"\n"X Displacement"\n"Y Displacement"\n"Z Displacement"\n');
    fprintf(fplt,'ZONE T="Step 1 Incr 1"\n STRANDID=1, SOLUTIONTIME=1\n');
    fprintf(fplt,' Nodes=%8d, Elements=%8d, ZONETYPE=FEBrick\n',...
        sumNode,sumElem);
    fprintf(fplt,' DATAPACKING=BLOCK\n DT=(DOUBLE DOUBLE DOUBLE DOUBLE)\n');
end
a = rem(sumNode,5); % 该变量判断是否换行，无实际意义
for n =1:ndim
    fprintf(fplt,'%20.10E%20.10E%20.10E%20.10E%20.10E\n',node(:,n));
    if a > 0
        fprintf(fplt,'\n');
    end
end
for n = 1:ndim
    fprintf(fplt,'%20.10E%20.10E%20.10E%20.10E%20.10E\n',u(n,:));
    if a > 0
        fprintf(fplt,'\n');
    end
end
if haveS
    for n = 1:ndimB
        fprintf(fplt,'%20.10E%20.10E%20.10E%20.10E%20.10E\n',s(:,n));
        if a > 0
            fprintf(fplt,'\n');
        end
    end
    fprintf(fplt,'%20.10E%20.10E%20.10E%20.10E%20.10E\n',mises);
    if a > 0
        fprintf(fplt,'\n');
    end
end


if ndim == 2
    if mnode == 4
        fprintf(fplt,'%8d%8d%8d%8d\n',elem');
    else
        elem(:,5:8) = [];
        fprintf(fplt,'%8d%8d%8d%8d\n',elem');
    end
else
    if mnode == 8
        fprintf(fplt,'%8d%8d%8d%8d%8d%8d%8d%8d\n',elem');
    elseif mnode == 20
        elem(:,9:end) = [];
        fprintf(fplt,'%8d%8d%8d%8d%8d%8d%8d%8d\n',elem');
    elseif mnode == 27
        elem =elem(:,[1,3,9,7,19,21,27,25]);
        fprintf(fplt,'%8d%8d%8d%8d%8d%8d%8d%8d\n',elem');
    end
end

fclose(fout);
fclose(fplt);


