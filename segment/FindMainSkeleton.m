function [ MainSkeleton ] = FindMainSkeleton(pts,spls,joints,roots, spls_adj,corresp )
%FINDMAINSKELETON 此处显示有关此函数的摘要
%   此处显示详细说明
   resultSet=BFSDivideGraph(spls_adj);
   graphNum=length(resultSet);
   maxId=-1;maxV=0;
   otherSkeleton=[];
   for i=1:graphNum
       temp=resultSet(i).graph;
     vnum=length(temp);   
     if(vnum>maxV)
        maxId=i;maxV=vnum; 
     end
   end
   MainSkeleton=resultSet(maxId).graph;
%    for i=1:graphNum
%      if(i==maxId) continue;end;
%       temp=resultSet(i).graph;
%       otherSkeleton=[otherSkeleton;temp];
%    end
%    u_pts=pts(corresp==otherSkeleton);
%    u_spls
   
end

