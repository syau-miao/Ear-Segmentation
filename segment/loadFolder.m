function [PtCloud,Labels] = loadFolder( filedir )
%LOADFOLDER �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
fileFolder=fullfile(filedir);
dirOutput=dir(fullfile(fileFolder,'*.ply'));
FileNames={dirOutput.name};
Length_Names = size(FileNames,2);    % ��ȡ����ȡ�����ļ��ĸ���
Indices=zeros(Length_Names,1);
PtCloud=[];
kname=1;
Labels=[];
for k = 1 : Length_Names
    % ����·�����ļ����õ��������ļ�·��
    K_Trace = strcat(fileFolder, FileNames(k));
    fn=FileNames{k}(1);        
    pccloud=pcread(K_Trace{1});
    cloud=double(pccloud.Location);
    lab=zeros(length(cloud),1);
    if(fn=='e')
    lab(lab==0)=kname;
    kname=kname+1;
    end
    PtCloud=[PtCloud; cloud];
    Labels=[Labels;lab];
end

if(false)
    figure('Name','segment cloud','NumberTitle','off');set(gcf,'color','white');movegui('southwest');
   % hold on;
   
   % scatter3(Apts(:,1),Apts(:,2),Apts(:,3),5,[0 1 0]);
    scatter3(Apts(:,1),Apts(:,2),Apts(:,3),5,[0 1 0]);
    hold on
    scatter3(Axis_pts(:,1),Axis_pts(:,2),Axis_pts(:,3),3,[1 0 0], 'filled');
    axis off; axis equal; camorbit(0,0,'camera'); axis vis3d; view(-90,0);view3d ZOOM;
  
end


end

