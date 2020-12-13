function [ axis_points] = findStemByFeatures( points,patches,patch_adj,features )
%FINDSTEMBYFEATURES 此处显示有关此函数的摘要
%   此处显示详细说明
%     f_sum=zeros(length(patches),1);
%     dir=fitline(points);
%     center=mean(points);
%     dis=P2LineDistance(center,dir,points);  
    for i=1:length(patches)
       ids=patches{i};
       pts=points(ids,:);
    %   obb=find_OBB_mt(pts,1,1,1,false);
      % f_sum(i)=obb.ExtentLen(3)/obb.ExtentLen(2);
       f_sum(i)=sum(features(ids,:))/length(ids);
    end
    [~,mid]=max(f_sum);
    
    %%%%%%%estimate the growth direction
    [idx, centers] = kmeans(f_sum', 2);
    Lid=[];Sid=[];
    if(centers(1)>centers(2))
      Sid=find(idx==1);
      Lid=find(idx==2);
    else
      Sid=find(idx==2);
      Lid=find(idx==1);
    end
    TempIds=[];
    for i=1:length(Sid)
    TempIds=[TempIds;patches{Sid(i)}'];
    end
    TempPts=points(TempIds,:);
    inliers=[];
    while(isempty(inliers))
    inliers=ransacline(TempPts,20);
    inliers(inliers<=0)=[];
    end
    inliers=TempIds(inliers);
    
    linePts=points(inliers,:);
    [center,linedir]=fitline(linePts);
    [distance,t0]=P2LineDistance(center,linedir,points);  
    a=patches{mid};
    [maxt,maxid]=max(t0);[mint,minid]=min(t0);
    tm=max(t0(a));
    bottomPt=points(minid,:);
    if(abs(tm-maxt)<abs(tm-mint))
        linedir=-linedir;
        t0=-t0;bottomPt
        bottomPt=points(maxid,:);
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
%%%%%%%%%%%%%%debug visulization%%%%%%%%%%%%%%%%%%%%%%    
    indices=patches{mid};
     figure('Name','2 class','NumberTitle','off');set(gcf,'color','white');movegui('southwest'); 
    scatter3(points(:,1),points(:,2),points(:,3),5,[0 0 0], 'filled');
    hold on;
   for i=1:length(patches)
   indices=patches{i}; 
   type=idx(i);
   if(type==1)
       color=[1,0,0];
   else
       color=[0 1 0];
   end
   if(mid==i)
      color=[1 0 1]; 
   end
  %  scatter3(points(indices,1),points(indices,2),points(indices,3),5,[1 0 0], 'filled');
 %  color=[f_sum(i),f_sum(i),f_sum(i)];
   scatter3(points(indices,1),points(indices,2),points(indices,3),5,color, 'filled');
   hold on;
   end   
   scatter3(points(inliers,1),points(inliers,2),points(inliers,3),5,[0 0 1], 'filled');
   hold on;
   scatter3(bottomPt(1),bottomPt(2),bottomPt(3),40,[0 0 0], 'filled');
   hold on;
   axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-90,0);view3d rot;    

   
%     figure('Name','root patch','NumberTitle','off');set(gcf,'color','white');movegui('southwest'); 
%     scatter3(points(:,1),points(:,2),points(:,3),5,[0 0 0], 'filled');
%     hold on;
%    for i=1:length(patches)
%    indices=patches{i}; 
%    ids=patch_adj{i};
%    if(length(ids)==1)
%        color=[1 0 0];
%    else
%        color=[0 1 0];
%    end
%    scatter3(points(indices,1),points(indices,2),points(indices,3),5,color, 'filled');
%    hold on;
%    end
%   axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-90,0);view3d rot;    
%    
   %*******************************************************************************************************************
%    figure('Name','findstembyfeatures','NumberTitle','off');set(gcf,'color','white');movegui('southwest'); 
%     scatter3(points(:,1),points(:,2),points(:,3),5,[0 0 0], 'filled');
%     hold on;
%    for i=1:length(patches)
%    indices=patches{i}; 
%   %  scatter3(points(indices,1),points(indices,2),points(indices,3),5,[1 0 0], 'filled');
%    color=[f_sum(i),f_sum(i),f_sum(i)];
%    scatter3(points(indices,1),points(indices,2),points(indices,3),5,color, 'filled');
%    hold on;
%    end
%%%%%%%%%%%%%************************************************************************
%    for i=1:length(mid)
%   % indices=patches{mid(i)}; 
%   %  scatter3(points(indices,1),points(indices,2),points(indices,3),5,[1 0 0], 'filled');
%    color=[f_sum(i),f_sum(i),f_sum(i)];
%    scatter3(points(indices,1),points(indices,2),points(indices,3),5,color, 'filled');
%    hold on;
%    end
    
end

