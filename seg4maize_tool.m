function varargout = seg4maize_tool(varargin)
% SEG4MAIZE_TOOL MATLAB code for seg4maize_tool.fig
%      SEG4MAIZE_TOOL, by itself, creates a new SEG4MAIZE_TOOL or raises the existing
%      singleton*.
%
%      H = SEG4MAIZE_TOOL returns the handle to a new SEG4MAIZE_TOOL or the handle to
%      the existing singleton*.
%
%      SEG4MAIZE_TOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEG4MAIZE_TOOL.M with the given input arguments.
%
%      SEG4MAIZE_TOOL('Property','Value',...) creates a new SEG4MAIZE_TOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before seg4maize_tool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to seg4maize_tool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help seg4maize_tool

% Last Modified by GUIDE v2.5 13-Dec-2020 14:41:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @seg4maize_tool_OpeningFcn, ...
                   'gui_OutputFcn',  @seg4maize_tool_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before seg4maize_tool is made visible.
function seg4maize_tool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to seg4maize_tool (see VARARGIN)

% Choose default command line output for seg4maize_tool
handles.output = hObject;
handles.process=0;
I = imread('icon.png');
javaImage = im2java(I);%①
newIcon = javax.swing.ImageIcon(javaImage);
figFrame = get(handles.figure1,'JavaFrame'); %取得Figure的JavaFrame。
figFrame.setFigureIcon(newIcon); %修改图标

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes seg4maize_tool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = seg4maize_tool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in BatchProcess.
function BatchProcess_Callback(hObject, eventdata, handles)
% hObject    handle to BatchProcess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in phenotyping.
function phenotyping_Callback(hObject, eventdata, handles)
% hObject    handle to phenotyping (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.process<4)
  msgbox('please implement the fine segmentation firstly', 'warning'); 
  return;   
end
filter=[handles.filename '_traits.txt'];
[fileName, Path] = uiputfile(filter);

traitfile=[Path fileName];
global g_regions;
global g_P;

PhenotypicTrait(g_P.PA_Pts,g_regions,g_P.earIds,traitfile,false);
msgbox('done', 'warning'); 



% --- Executes on button press in Segment_Fine.
function Segment_Fine_Callback(hObject, eventdata, handles)
% hObject    handle to Segment_Fine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.process<3)
  msgbox('please implement the coase segmentation firstly', 'warning'); 
  return;   
end
global g_P;
global g_regions;
id=g_P.sub_skeletons{1}(1);
StemBottomPt=g_P.PA_Spls(id,:);
k1=5;
Beta=0;
Sigma=0;
g_regions=FineSegmentation(g_P.PA_Pts,StemBottomPt,g_P.Phi_O,g_P.Phi_U,g_P.PA_StopX,k1,k1,Beta,Sigma,false);
ShowPoints(g_P.pts,g_regions);
[g_P.earIds,g_regions]=IdentifyingOrgans(g_regions,g_P.PA_Pts,g_P.PA_Spls,g_P.sub_skeletons);
handles.process=4;
guidata(hObject, handles);

function edit_k1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_k1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_k1 as text
%        str2double(get(hObject,'String')) returns contents of edit_k1 as a double


% --- Executes during object creation, after setting all properties.
function edit_k1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_k1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Beta_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Beta as text
%        str2double(get(hObject,'String')) returns contents of edit_Beta as a double


% --- Executes during object creation, after setting all properties.
function edit_Beta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Delta_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Delta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Delta as text
%        str2double(get(hObject,'String')) returns contents of edit_Delta as a double


% --- Executes during object creation, after setting all properties.
function edit_Delta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Delta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Alpha_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Alpha as text
%        str2double(get(hObject,'String')) returns contents of edit_Alpha as a double


% --- Executes during object creation, after setting all properties.
function edit_Alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Segment_Coase.
function Segment_Coase_Callback(hObject, eventdata, handles)
% hObject    handle to Segment_Coase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(handles.process<2)
  msgbox('please extract the skeleton firstly', 'warning'); 
  return;   
end
global g_P;
alpha=1.0;
%JN=str2num(get(handles.edit_jointNum,'string'));
g_P.mainskeleton=FindMainSkeleton(g_P.pts,g_P.spls, g_P.joints,g_P.roots, g_P.spls_adj,g_P.corresp);
%return;
[sub_skeletons]=SkeletonDecomposition2(g_P.mainskeleton,g_P.spls, g_P.joints,g_P.roots, g_P.spls_adj,g_P.corresp,g_P.features,true);
%return;

[Phi_O,Phi_U,Phi_S]= CoaseSegBySkeleton(g_P.pts,g_P.corresp,sub_skeletons,g_P.joints,3,false);
%%%% transform global coordinate axis to plant coordinate axis
%[SearchR,SeedPoint,StopPoint]= preStemSeg(g_P.pts,g_P.spls,sub_skeletons{end},g_P.joints,g_P.corresp,alpha,JN);
%[Phi_S,Phi_U]=RegionGrowingSegment(g_P.pts,Phi_U,SeedPoint,SearchR,StopPoint);
[PA_Pts,PA_Spls]= ConstructPlantAxis(g_P.pts,g_P.spls,Phi_S,sub_skeletons);
[PA_StopX,PA_StartX]= FindLeafStopZ(sub_skeletons,g_P.joints,PA_Spls);  
%[Phi_S,Phi_U]=StemSegment(PA_Pts,Phi_U,PA_StartX,alpha,JN);
[Phi_S,Phi_U]=StemSegment2(PA_Pts,Phi_U,PA_Spls,sub_skeletons{end},alpha,PA_StartX,2);
%Phi_O=flip(Phi_O);
Phi_O{end+1}=Phi_S;
 PA_StopX(end+1)=-inf;
 PA_StopX=flip(PA_StopX);
Phi_O=flip(Phi_O);
sub_skeletons=flip(sub_skeletons);
g_P.PA_Pts=PA_Pts;
g_P.PA_Spls=PA_Spls;
g_P.Phi_U=Phi_U;
g_P.Phi_O=Phi_O;
g_P.sub_skeletons=sub_skeletons;
g_P.PA_StopX=PA_StopX;
ShowPoints(g_P.PA_Pts,Phi_O);
handles.process=3;
guidata(hObject, handles);

% --- Executes on button press in CoaseSeg_Interactive.
function CoaseSeg_Interactive_Callback(hObject, eventdata, handles)
% hObject    handle to CoaseSeg_Interactive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in SkeletonExtraction.
function SkeletonExtraction_Callback(hObject, eventdata, handles)
% hObject    handle to SkeletonExtraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global g_P;
% skeleton_mst(g_P.pts);
% return;

if(handles.process<1)
  msgbox('please load a ply file firstly', 'warning'); 
  return;   
end
Parameters.t1 = 0.1; % for inner branch nodes
Parameters.a1 = pi*5.0/7.0; % for inner branch nodes, 
Parameters.t2 = 0.0;   
Parameters.t3 = 3; % for small cycles;
Parameters.KnnNum=str2num(get(handles.edit_k,'string'));
Parameters.sampleScale=0.02;
global g_P;
g_P=skeleton_laplacian(g_P,Parameters);

ShowSkeletons(g_P);
handles.process=2;
guidata(hObject, handles);


function edit_k_Callback(hObject, eventdata, handles)
% hObject    handle to edit_k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_k as text
%        str2double(get(hObject,'String')) returns contents of edit_k as a double


% --- Executes during object creation, after setting all properties.
function edit_k_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_t2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_t2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_t2 as text
%        str2double(get(hObject,'String')) returns contents of edit_t2 as a double


% --- Executes during object creation, after setting all properties.
function edit_t2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_t2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in LoadPly.
function LoadPly_Callback(hObject, eventdata, handles)
% hObject    handle to LoadPly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile('.ply','Select the ply point cloud file');  
if(filename==0)
   return; 
end
global g_regions;
g_regions=[];
global g_P;
g_P=[];
pccloud=pcread([pathname filename]);
g_P.pts=double(pccloud.Location);
g_points=g_P.pts(:,1:3);
ShowPoints(g_points,g_regions);
 g_P.features=computerFeature_mt(g_points,32);
% setappdata(handles.axes1,'points',points);
%setappdata(0,'points',points);
handles.process=1;
handles.filename=filename(1:end-4);
handles.pathname=pathname;
guidata(hObject, handles);
% --- Executes on button press in OpenFolder.
function OpenFolder_Callback(hObject, eventdata, handles)
% hObject    handle to OpenFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
isSavePic=true;
if(get(handles.checkbox_SavePhoto,'Value')==0)
    isSavePic=false;
end
[FileName_,PathName,FilterIndex] = uigetfile('*.ply','MultiSelect','on');
if(FilterIndex==0)
    return; 
end
if(iscell(FileName_))
   FileName=FileName_;
else
   FileName{1}=FileName_; 
end
numfiles = size(FileName,2);
for ii = 1:numfiles
filename=FileName{ii};
global g_regions;
g_regions=[];
global g_P;
g_P=[];
pccloud=pcread([PathName filename]);
g_P.pts=double(pccloud.Location);
g_P.pts=g_P.pts(:,1:3);
handles.process=1;
handles.filename=filename(1:end-4);
Parameters.t1 = 0.1; % for inner branch nodes
Parameters.a1 = pi*5.0/7.0; % for inner branch nodes, 
Parameters.t2 = str2num(get(handles.edit_t2,'string'));   
Parameters.t3 = 30; % for small cycles;
Parameters.KnnNum=str2num(get(handles.edit_k,'string'));
Parameters.sampleScale=0.02;
g_P=skeleton_laplacian(g_P,Parameters);
alpha=str2num(get(handles.edit_Alpha,'string'));
JN=str2num(get(handles.edit_jointNum,'string'));
[sub_skeletons,g_P.spls]=SkeletonDecomposition(g_P.spls, g_P.joints,g_P.roots, g_P.spls_adj,g_P.corresp,g_P.featrues,false);
[Phi_O,Phi_U]=CoaseSegBySkeleton(g_P.pts,g_P.corresp,sub_skeletons,g_P.joints,3,false);
%%%% transform global coordinate axis to plant coordinate axis
[PA_Pts,PA_Spls]= ConstructPlantAxis(g_P.pts,g_P.spls,Phi_U,sub_skeletons);
[PA_StopX,PA_StartX]= FindLeafStopZ(sub_skeletons,g_P.joints,PA_Spls);  
[Phi_S,Phi_U]=StemSegment(PA_Pts,Phi_U,PA_StartX,alpha,JN);
Phi_O=flip(Phi_O);
Phi_O{end+1}=Phi_S;
PA_StopX(end+1)=-inf;
PA_StopX=flip(PA_StopX);
Phi_O=flip(Phi_O);
g_P.PA_Pts=PA_Pts;
g_P.PA_Spls=PA_Spls;
g_P.Phi_U=Phi_U;
g_P.Phi_O=Phi_O;
g_P.sub_skeletons=sub_skeletons;
id=g_P.sub_skeletons{end}(1);
StemBottomPt=g_P.PA_Spls(id,:);
k1=str2num(get(handles.edit_k1,'string'));
Beta=str2num(get(handles.edit_Beta,'string'));
Sigma=str2num(get(handles.edit_Delta,'string'));
g_regions=FineSegmentation(g_P.PA_Pts,StemBottomPt,g_P.Phi_O,g_P.Phi_U,k1,k1,Beta,Sigma,false);
if(isSavePic)
    picName=[PathName handles.filename '_pic.jpg'];
    SavePic(g_P.pts,g_regions,picName);
end
    
filter=[handles.filename '_label.txt'];
fid=fopen([PathName filter],'w');
%data=zeros(length(g_P.pts),4);
for i=1:length(g_regions)
    ids=g_regions{i};
    for j=1:length(ids)
       pt=g_P.pts(ids(j),:);
       label=i;
      fprintf(fid,'%f %f %f %d\r\n',pt(1),pt(2),pt(3),label);
    end
end
fclose(fid);

filter=[handles.filename '_traits.txt'];
traitfile=[PathName filter];
PhenotypicTrait(g_P.PA_Pts,g_regions,traitfile,false);
end  
 msgbox('Done', 'warning'); 


% --- Executes on button press in SaveLabels.
function SaveLabels_Callback(hObject, eventdata, handles)
% hObject    handle to SaveLabels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.process<4)
    msgbox('please implement fine segmentation firstyly', 'warning'); 
    return;
end
handles.filename
%filter = {'*.txt'};
filter=[handles.filename '_label.txt'];
[fileName, Path] = uiputfile(filter);
fid=fopen([Path fileName],'w');
global g_regions;
global g_P;
%data=zeros(length(g_P.pts),4);
for i=1:length(g_regions)
    ids=g_regions{i};
    for j=1:length(ids)
       pt=g_P.pts(ids(j),:);
       label=i;
      fprintf(fid,'%f %f %f %d\r\n',pt(1),pt(2),pt(3),label);
    end
end
fclose(fid);



function edit_jointNum_Callback(hObject, eventdata, handles)
% hObject    handle to edit_jointNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_jointNum as text
%        str2double(get(hObject,'String')) returns contents of edit_jointNum as a double


% --- Executes during object creation, after setting all properties.
function edit_jointNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_jointNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_SavePhoto.
function checkbox_SavePhoto_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_SavePhoto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_SavePhoto


% --- Executes on button press in OpenLabel.
function OpenLabel_Callback(hObject, eventdata, handles)
% hObject    handle to OpenLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile('.txt','Select the label txt file');  
if(filename==0)
   return; 
end
data=load([pathname filename]);
% if(size(data,2)~=4)
%     msgbox('please load label file ', 'warning'); 
%     return;   
% end
pts=data(:,1:3);
labels=data(:,4);
num=max(labels);
regions=[];
for i=1:num
   regions{i}=find(labels==i); 
end
ShowPoints(pts,regions);


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in SkeletonOptimization.
function SkeletonOptimization_Callback(hObject, eventdata, handles)
% hObject    handle to SkeletonOptimization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global g_P;
global g_regions;
[OrganSkeleton,newSpls,new_Spls_Adj]=refineSkeleton(g_regions,g_P.PA_Pts,g_P.PA_Spls,g_P.corresp,g_P.spls_adj,[],false);


% --- Executes on button press in LoadFolder.
function LoadFolder_Callback(hObject, eventdata, handles)
% hObject    handle to LoadFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[selpath] = uigetdir(path);
if(selpath==0)
    return;
end
filepath=[selpath '\'];
[points,labels]=loadFolder( filepath );
global g_regions;
g_regions=[];
global g_P;
global g_points;
g_P=[];
g_P.pts=points;
g_P.labels=labels;
g_points=g_P.pts(:,1:3);
 ShowPoints(g_points,g_regions);
 g_P.features = computerFeature_mt(g_points,16);

 %patches=wseg(g_points,16,32);
 %StemIndices=findStemByFeatures(g_points,patches,[]);

%g_P.BottomIds=StemIndices;


ind=strfind(selpath,'\');
filename=selpath(ind(end)+1:end);
pathname=selpath(1:ind(end));
handles.process=1;
handles.filename=filename;
handles.pathname=pathname;
guidata(hObject, handles);


% --- Executes on button press in Verification.
function Verification_Callback(hObject, eventdata, handles)
% hObject    handle to Verification (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global g_P;
if(isempty(g_P.labels))
    return;
end
maxLabel=max(g_P.labels);
trueRegions=cell(maxLabel+1,1);
for i=1:maxLabel+1
   trueRegions{i}=find(g_P.labels==i-1); 
end

maxLabel=length(g_P.earIds);
global g_regions;
autoRegions=cell(maxLabel+1,1);
er=[];
 for i=1:length(g_P.earIds)
   id=g_P.earIds(i); 
   autoRegions{i+1}=g_regions{id}; 
   er=[er;g_regions{id}];
 end
 all=1:length(g_P.pts);
 autoRegions{1}=setdiff(all,er)';
 IdName=handles.filename;
 [Precison,Recall,Micro_F1,Macro_F1,OA,Precisons,Recalls,F1s,RegionsCorresp]=Verification_mt(g_P.pts, trueRegions, autoRegions,IdName,false);
 


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global g_points;
global g_P;
[patches,patch_adj]=wseg(g_points,16,60);
 StemIndices=findStemByFeatures(g_points,patches,patch_adj,g_P.features);
