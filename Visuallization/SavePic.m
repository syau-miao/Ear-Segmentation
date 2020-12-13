function SavePic( points,regions,filename)
%SAVEPIC 此处显示有关此函数的摘要
%   此处显示详细说明
   h=figure('visible','off');set(gcf,'color','white');movegui('southwest');
   color=MyGS.MYCOLOR;
   scatter3(points(:,1),points(:,2),points(:,3),5,[0.0 0.0 0], 'filled');
   hold on;
   for i=1:length(regions)
   I1=regions{i};
   scatter3(points(I1,1),points(I1,2),points(I1,3),5,color(i,:), 'filled');
   hold on;
   end
   axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-180,0);view3d ZOOM;
  % filename=['test' num2str(i) '.jpg'];
   saveas(h,filename);
end

