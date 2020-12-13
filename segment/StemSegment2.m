function [ StemRegions,UnSegmentRegions] = StemSegment2( points,unknowns,spls,stem_skeleton,beta,PA_StartX,JN)
%STEMSEGMENT_MT 此处显示有关此函数的摘要
%   此处显示详细说明
%estimate searchR
  stemPts=points(unknowns,:);
  stemZ=stemPts(:,3);mz=median(stemZ);
  bottomIndices=find(stemZ<mz/20);
   bottomStemPts=stemPts(bottomIndices,:);
   [res]=fitline_r(bottomStemPts);
    center=[res(1) res(2) res(3)]; 
    dir=[res(4) res(5) res(6)];
    total=[];
    for i=1:size(stemPts,1)
        pt=stemPts(i,:);
    [dis,~ ]=P2LineDistance(center,dir,pt);
    total=[total;dis];
    end
    SearchR=beta*median(total(bottomIndices));

%%%%%%%%%%%%%%%%%%%%%%
StemRegions=[];
UnSegmentRegions=[];
  upts=points(unknowns,:);
  for i=1:length(stem_skeleton)
     sp=spls(stem_skeleton(i),:);
     ptCloud = pointCloud(upts);  
    [indices,~]= findNeighborsInRadius(ptCloud,sp,SearchR);  
    StemRegions=[StemRegions;unknowns(indices)];
  end
  StemRegions=unique(StemRegions);
  
  temp=sort(unique(PA_StartX));
  StopZ=temp(end);
  if(length(temp)>JN)
  StopZ=temp(end-JN);
  end
  
  StemZ=points(StemRegions,3);
  uindex=find(StemZ<StopZ);
  StemRegions=StemRegions(uindex);
  UnSegmentRegions=setdiff(unknowns,StemRegions);
%  
% if(false)   
%     figure('Name','Distance constraint','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
%     scatter3(pts(:,1),pts(:,2),pts(:,3),5,[0.0 0.0 0], 'filled');
%     hold on 
%     scatter3(points(StemIndices,1),points(StemIndices,2),points(StemIndices,3),10,[1 0 0], 'filled');
%     hold on
%     axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(0,0);view3d rot;      
% end
    %%%%%%%%DEBUG  可视化%%%%%%%%%%%%%%%%%%%%%%%%  

end

