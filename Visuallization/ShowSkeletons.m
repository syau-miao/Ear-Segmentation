function  ShowSkeletons( P )
%SHOWSKELETONS 此处显示有关此函数的摘要
%   此处显示详细说明
   global Handle_F;
     if(ishghandle(Handle_F))
   close(Handle_F);
   end
   
   Handle_F= figure('Name','Visulazation Skeleton','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
    plot_skeleton(P.spls, P.spls_adj);hold on;
    scatter3(P.spls(P.joints,1),P.spls(P.joints,2),P.spls(P.joints,3),40,[0,0,1], 'filled');
    scatter3(P.spls(P.roots,1),P.spls(P.roots,2),P.spls(P.roots,3),40,[1,0,1], 'filled');
    scatter3(P.spls(P.branches,1),P.spls(P.branches,2),P.spls(P.branches,3),20,[0,1,0],'filled');
    scatter3(P.pts(:,1),P.pts(:,2),P.pts(:,3),2,[0,0,0],'filled');
    axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-180,0);view3d rot;
end

