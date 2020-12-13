function  ShowPoints( points,regions)
%SHOWPOINTS �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%    global Handle_F;
%    if(ishghandle(Handle_F))
%    close(Handle_F);
%    end
   Handle_F=figure('Name','Segmentation Visualization','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
   color=MyGS.MYCOLOR;
   scatter3(points(:,1),points(:,2),points(:,3),10,[0.0 0.0 0], 'filled');
   hold on;
   for i=1:length(regions)
   I1=regions{i};
   scatter3(points(I1,1),points(I1,2),points(I1,3),10,color(i,:), 'filled');
   hold on;
   end
   axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-180,0);view3d ZOOM;
end

