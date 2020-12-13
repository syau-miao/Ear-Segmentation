function [searchR,startPoint,stopPoint] = preStemSeg(points,spls,stem_skeleton,joints,corresp,alpha,JN)
%PRESTEMSEG 此处显示有关此函数的摘要
%   此处显示详细说明
   StemIds=[];
   %sta
   for i=1:length(stem_skeleton)
      id=stem_skeleton(i);  
      ids=find(corresp==id);
      StemIds=[StemIds;ids];
      if(i==1)
         startPoint=spls(id,:);
         continue;
      else
        if(ismember(id,joints))
%          id_1=stem_skeleton(i-1);  
%          startPoint=spls(id_1,:);
         stopPoint=spls(id,:);
         break;
        end
      end
   end
   stemPts=points(StemIds,:);
   startPoint=median(stemPts);
   
  % dir=(stopPoint-startPoint)./norm(stopPoint-startPoint);
     [res]=fitline_r(stemPts);
    dir=[res(4) res(5) res(6)];
    center=startPoint; 
   % dir=[res(4) res(5) res(6)];
    total=[];
%     for i=1:size(stemPts,1)
%         pt=stemPts(i,:);
    [total,~ ]=P2LineDistance(center,dir,stemPts);
%     total=[total;dis];
%     end
    searchR=alpha*median(total); 
     count=0;
     for i=length(stem_skeleton):-1:1
        id=stem_skeleton(i);        
        if(ismember(id,joints))
          count=count+1; 
        end
        if(count==JN)
           stopPoint=spls(id,:);
           break;
        end
     end
end

