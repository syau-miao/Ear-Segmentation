function [ earid,AutoRegions] = IdentifyingOrgans( AutoRegions,Pts,spls,organ_subskeleton)
%IDENTIFYINGORGANS 此处显示有关此函数的摘要
%   此处显示详细说明
     maxZ=max(Pts(:,3));
     minZ=min(Pts(:,3));
     Para=zeros(length(AutoRegions)-1,4);
     for i=2:length(AutoRegions)
        ids=AutoRegions{i};
        organPts=Pts(ids,:);
        oz=max(organPts(:,3));
        if(length(ids)>30)
        OBB=find_OBB_mt(organPts,1,1,1,false);
        Para(i-1,:)=[OBB.ExtentLen' oz];
        else
          Para(i-1,:)=[[Inf Inf Inf] oz];  
        end
     end
   ids=find(Para(:,4)<(minZ+2*(maxZ-minZ)/3));
    skeLen=zeros(length(organ_subskeleton)-1,1);
    cosV=zeros(length(organ_subskeleton)-1,1);
for i=2:length(organ_subskeleton)
   indices= organ_subskeleton{i};
   if(isempty(indices))continue;end;
   vi_end=indices(2);
   vi_mid=indices(1);
   v_end=spls(vi_end,:);
   v_mid=spls(vi_mid,:);
   dv=(v_mid-v_end)./norm(v_mid-v_end);
   cosV(i-1)=dv(3);
   skeLen(i-1)=length(indices);
end
ids3=find(cosV>0); 
%skeLen=Para(:,1);
%skeLen_=skeLen(skeLen~=Inf);
ids=intersect(ids3,ids);
%ids4=find(skeLen<0.5*mean(skeLen_));
ids4=find(skeLen<mean(skeLen));
ids=intersect(ids,ids4);
ids=ids+1;
earid=ids;
if(length(ids)>1)
    earid=[];
    earNum=[];
    features=[];
  for i=1:length(ids)
    I1=AutoRegions{ids(i)};
    earPts=Pts(I1,:);
    ptCloud=pointCloud(earPts);
    feature=0;
    earNum=[earNum;length(I1)];
    if(length(I1)<30)continue;end;
   for j=1:size(earPts,1)
     pt=earPts(j,:);
     [indices,~]=findNearestNeighbors(ptCloud,pt,32);
     n_pts=earPts(indices,:);
     [~,~,coffes]= pca(n_pts,'Algorithm','eig');  
     e1=coffes(1)/sum(coffes);e2=coffes(2)/sum(coffes);e3=coffes(3)/sum(coffes);
   % features(i)=(e1-e2)/(e1);
     feature=feature+(e3)/(e2);
   end
    features=[features;feature/length(I1)];
    if(feature/length(I1)<0.18)continue;end
    earid=[earid;ids(i)];
  end
   if(isempty(earid))
     [~,id]=sort(earNum,'descend'); 
     earid=ids(id);
   end
end
   
  
%     stemPts=points(StemIndices,:);
%     ptCloudIn=pointCloud(stemPts);
%     num=size(stemPts,1);
%     if(num>32)
%     [newpts,inlierIndices,outlierIndices] = pcdenoise(ptCloudIn,'NumNeighbors',32,'Threshold', 0.8);
%     uindex=StemIndices(outlierIndices);
%     UnSegmentIndices=[UnSegmentIndices;uindex];
%     StemIndices=setdiff(StemIndices,uindex);
%     else
%     UnSegmentIndices=[UnSegmentIndices;StemIndices];
%     StemIndices=[];    
%     end

  
     
%    global Handle_F;
%    if(ishghandle(Handle_F))
%    close(Handle_F);
%    end
  % Handle_F=figure('Name','bang Visualization','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
   figure('Name','bang Visualization','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
   color=MyGS.MYCOLOR;
%  scatter3(Pts(:,1),Pts(:,2),Pts(:,3),5,[0.0 0.0 0], 'filled');
%  hold on;
  for i=1:length(earid)
     I1=AutoRegions{earid(i)};
     scatter3(Pts(I1,1),Pts(I1,2),Pts(I1,3),5,color(i,:), 'filled');
     hold on;
   end
   axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-180,0);view3d ZOOM;  
end

