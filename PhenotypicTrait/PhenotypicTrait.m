function [PlantHeight,PlantDiameter,Skeletons]=PhenotypicTrait(points, g_regions,earIds,txtName,DebugShow)
%PHENOTYPICTRAIT 此处显示有关此函数的摘要
%   此处显示详细说明
 PhenoTraits=zeros(length(earIds),4);
 minZ=min(points(:,3));
 %StemSkeleton;
  for i=1:length(earIds)
      indices=g_regions{earIds(i)};
      earPoints=points(indices,:);
      ptCloud=pointCloud(earPoints);
      Temp=pcdenoise(ptCloud,'NumNeighbors',8,'Threshold',1);
      earPoints=Temp.Location;  
      minZ_=min(earPoints(:,3));
      maxZ=max(earPoints(:,3));
      OBB=find_OBB_mt(earPoints,1,1,1,true);
      earlen=OBB.ExtentLen(1);
      eardiameter=OBB.ExtentLen(3);
      earheight=minZ_- minZ;
      earheight2=maxZ-minZ;
      PhenoTraits(i,:)=[earlen eardiameter earheight earheight2];
  end
  %%%%%%%%%%%%%%%%%存文件%%%%%%%%%%%%%%%%%%
  fid=fopen(txtName,'w');
  zs=PhenoTraits(:,4);
  [~,ids]=sort(zs,'descend');
  for i=1:size(PhenoTraits,1)
  LeafLen=PhenoTraits(i,1);
  LeafWidth=PhenoTraits(i,2);
  LeafHeight=PhenoTraits(i,3); 
  id=ids(i);
  fprintf(fid,'ear%d_length %f\r\n',id,LeafLen);
  fprintf(fid,'ear%d_diameter %f\r\n',id,LeafWidth);
  fprintf(fid,'ear%d_height %f\r\n',id,LeafHeight);
  fprintf(fid,'ear%d_tipheight %f\r\n',id,PhenoTraits(i,4));
  %fprintf(fid,'Leaf%d leafArea %f\r\n',i,LeafArea);  
  %fprintf(fid,'Leaf%d_leafAngle %f\r\n',i-1,LeafAngle);
  end
  fclose(fid);

end

