function [ Phi_O,Phi_U,Phi_S] = CoaseSegBySkeleton( points,corresp,sub_skeletons,joints,K,show_results )
%COASESEGBYSKELETON 此处显示有关此函数的摘要
%   此处显示详细说明
Phi_U=[];
Phi_O=[];
AllPhi=[];
for i=1:length(sub_skeletons)-1 
  indices=sub_skeletons{i};
  Phi_O{i}=[];
  for j=1:length(indices)-1
    indices1=find(corresp==indices(j));
    Phi_O{i}=[Phi_O{i};indices1];
    AllPhi=[AllPhi;indices1];
  end
end
AllIndices=1:length(points);
Phi_U=setdiff(AllIndices,AllPhi)';

 indices=sub_skeletons{end};
 Phi_S=[];
 for j=1:20
    indices1=find(corresp==indices(j));
    Phi_S=[Phi_S;indices1];
 end

% indices=sub_skeletons{end};
% for j=1:length(indices)
%    indices1=find(corresp==indices(j));
%         %Phi_O{1}=[Phi_O{1};indices1];
%    Phi_U=[Phi_U;indices1];
% end
%     if(i==length(sub_skeletons))
%       indices=sub_skeletons{i};
%       for j=1:length(indices)
%        indices1=find(corresp==indices(j));
%         Phi_U=[Phi_U;indices1];
%       end
%       for j=1:length(joints)
%         indices1=find(corresp==joints(j));
%         Phi_U=[Phi_U;indices1];
%       end
       




if false
    figure('Name','CoaseSegBySkeleton','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
   color=MyGS.MYCOLOR;
  for i=1:length(Phi_O)
       indices=Phi_O{i};
       scatter3(points(indices,1),points(indices,2),points(indices,3),5,color(i,:), 'filled');
       hold on;
   end
   indices=Phi_U;
   scatter3(points(indices,1),points(indices,2),points(indices,3),5,[0 0 0], 'filled');
   hold on;
   axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-180,0);view3d rot;
end

end

