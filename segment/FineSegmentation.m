function [ Regions ] = FineSegmentation( points,bottomStem,leafSeeds,unSegment,StopX,sample1,sample2,coeff1,coeff2,DebugShow )
%FINESEGMENTATION 此处显示有关此函数的摘要
%   此处显示详细说明
 leafNum=length(leafSeeds);
 UnSegPts=points(unSegment,:);
% EFF=UnSegPts(:,3)+0.5*UnSegPts(:,1)+0.5*UnSegPts(:,2);
% EFF=UnSegPts(:,3)+0.0*UnSegPts(:,1)+0.0*UnSegPts(:,2);
 EFF=sum((UnSegPts-bottomStem).*(UnSegPts-bottomStem),2);
 %EFF=EFF1;
 [sortZ, SortIndices]=sort(EFF,'descend');
 for i=1:size(SortIndices,1)
       index=SortIndices(i); 
       pt=UnSegPts(index,:);
       Dis1=zeros(leafNum,1); 
       a1=1.0;a2=coeff1;SampleNum=sample1;SampleNum2=sample2; a3=7;     
       for j=1:leafNum
          ids=leafSeeds{j};
          s_x=StopX(j);
          if(pt(3)<s_x)
             Dis1(j)=Inf;
             continue;
          end
          leafPts=points(ids,:);      
          Dis1(j)=caldis1(leafPts,pt,SampleNum); 
       end
     [sortDis1,SortIndices1]=sort(Dis1,'ascend');
     s1=SortIndices1(1); s2=SortIndices1(2);
     d1=sortDis1(1);     d2=sortDis1(2);

      if(abs(d2-d1)/(d1)>coeff2)
          min_id=s1; 
      else
         ids=leafSeeds{s1};
         leafPts=points(ids,:);
         %d1_2=caldis2(leafPts,nts,pt,nt,SampleNum2);  
         d1_2=caldis2(leafPts,pt,SampleNum2);  
         ids=leafSeeds{s2};
         leafPts=points(ids,:);
         %d2_2=caldis2(leafPts,nts,pt,nt,SampleNum2);
         d2_2=caldis2(leafPts,pt,SampleNum2);
         if(d1_2==Inf||d2_2==Inf)
             sd1=a1*d1;  sd2=a1*d2;
         else 
            sd1=a1*d1+a2*d1_2;  sd2=a1*d2+a2*d2_2;
         end
         if(sd1>sd2)
               min_id=s2;
         else
             min_id=s1;
         end
      end
     temp=leafSeeds{min_id};
     temp=[temp;unSegment(index)];
     leafSeeds{min_id}=temp;
   end
%    zvalues=zeros(length(leafSeeds),1);
%    zvalues(1)=-inf;
%    for i=2:length(leafSeeds)
%       ids=leafSeeds{i};
%       ptsZ=points(ids,3);
%       zvalues(i)=min(ptsZ);
%    end
%    [dis,indices2]=sort(zvalues);
%    Regions=cell(length(leafSeeds),1);
%    for i=1:length(indices2)
%      Regions{i}=leafSeeds{indices2(i)};  
%    end
Regions=leafSeeds';
   

end



function [min_dis]= caldis2(points,pt,SampleNum)
   vs=points-pt;
   rad=sqrt(sum(vs.*vs,2));
  % rad=abs(vs(:,3))+1.5*abs(vs(:,1))+1.5*abs(vs(:,2));
   [sortr,sortIndices]=sort(rad);
   num=size(sortr,1);
   sampleNum=SampleNum;
   if(num<sampleNum)
       sampleNum=num;
   end
   indices=sortIndices(1:sampleNum);
   samplePts=points(indices,:);
   [coeff,~,~]=pca(samplePts);
    projd=Inf;
    if(size(coeff,2)==3)
    normal=coeff(:,3)';
    Spt=mean(samplePts);
    %Spt=samplePts(1,:);
    pjs=find_ProjCoord_mt(normal,Spt,pt);
  %  pjs2=find_ProjCoord_mt(normal,Spt,samplePts);
  %  vs=pjs2-samplePts;
  %  projds=sqrt(sum(vs.*vs,2));
  %  mprojds=mean(projds);
    v=pjs-pt;projd=sqrt(v(1)*v(1)+v(2)*v(2)+v(3)*v(3));
  %  projd=abs(projd-mprojds);
    projd=abs(projd);
    end
   min_dis=projd;
end


function [min_dis]= caldis3(points,nts,pt,nt,SampleNum)
   vs=points-pt;
   rad=sqrt(sum(vs.*vs,2));
   [sortr,sortIndices]=sort(rad);
   num=size(sortr,1);
   sampleNum=SampleNum;
   if(num<sampleNum)
       sampleNum=num;
   end
   indices=sortIndices(1:sampleNum);
   nts_=nts(indices,:);
   ndotn=nts_.*nt;
   ndotn=abs(sum(ndotn,2));
   min_dis=mean(ndotn);
end


function [min_dis]= caldis1(points,pt,SampleNum)
   vs=points-pt;
   rad=sqrt(sum(vs.*vs,2));
  % rad=abs(vs(:,3))+1.5*abs(vs(:,1))+1.5*abs(vs(:,2));
   [sortr,sortIndices]=sort(rad);
   num=size(sortr,1);
   sampleNum=SampleNum;
   if(num>sampleNum)
   min_dis=mean(sortr(1:sampleNum));
   else
   min_dis=mean(sortr(1:num)); 
   end
end

