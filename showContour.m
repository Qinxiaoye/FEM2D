function showContour(node,elem,value)

% figure
patch('Faces',elem(:,1:4),'Vertices',node,'FaceVertexCData',value,'FaceColor','interp');
colorbar
title({['max value: ',num2str(max(value))],['min value: ',num2str(min(value))]})