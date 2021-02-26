function varargout = mainFile(varargin)
% MAIN MATLAB code for mainFile.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mainFile_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mainFile_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mainFile

% Last Modified by GUIDE v2.5 15-May-2020 21:31:19

%% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @mainFile_OpeningFcn, ...
    'gui_OutputFcn',  @mainFile_OutputFcn, ...
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

%% --- Executes just before main is made visible.
function mainFile_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for main
handles.output = hObject;

% define constant values
handles.folder_name = 'annots';
handles.image_path= './Left-Ventricle-Database2/images/';
handles.evaluation_image_path= './EvaluationImages/';
handles.mask_path = './Left-Ventricle-Database2/masks/';
handles.annot_path = './Left-Ventricle-Database2/annots/';

movegui(gcf,'center');
logoImage = imread('.\icons\UBFC_logo.jfif');
axes(handles.logo_axes);
imshow(logoImage);


nextImage = imread('.\icons\next.jpeg');
set(handles.pushbuttonNext,'CData',nextImage);

previousImage = imread('.\icons\previous.jpeg');
set(handles.previous_pushbutton,'CData',previousImage);
handles.imageCounts = 0;

set(handles.semi_auto_raido,'Value',1);
set(handles.auto_raido,'Value',0);
set(handles.convert_nifti_pushbutton,'Enable','off');
set(handles.load_pushbutton,'Enable','off');
set(handles.elipse_radiobutton,'Enable','off');
set(handles.polygon_radiobutton,'Enable','off');
set(handles.free_hand_radiobutton,'Enable','off');
set(handles.start_training_pushbutton,'Enable','off');
set(handles.evaluate_single_pushbutton,'Enable','off');
set(handles.evaluate_multi_pushbutton,'Enable','off');
set(handles.systolic_pushbutton,'Enable','off');
set(handles.diastolic_pushbutton,'Enable','off');

set(handles.pushbuttonDiastol,'Enable','on');
set(handles.pushbuttonSystolePhase,'Enable','on');
set(handles.pushbuttonDiastolePhase,'Enable','on');
handles.output = hObject;
handles.index = 0;
handles.slices = 0;
handles.segment = 0;

% Update handles structure
guidata(hObject, handles);

%% --- Outputs from this function are returned to the command line.
function varargout = mainFile_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --- Executes on button press in semi_auto_raido.
function semi_auto_raido_Callback(hObject, eventdata, handles)
try
    resetMessage(handles.info_text);
    set(handles.auto_raido,'Value',0);
    set(handles.metricsBox, 'String', '');
    delete(get(handles.display,'Children'));
    delete(get(handles.systolewindow,'Children'));
    delete(get(handles.diastolewindow,'Children'));
    
    set(handles.convert_nifti_pushbutton,'Enable','off');
    set(handles.load_pushbutton,'Enable','off');
    set(handles.elipse_radiobutton,'Enable','off');
    set(handles.polygon_radiobutton,'Enable','off');
    set(handles.free_hand_radiobutton,'Enable','off');
    set(handles.start_training_pushbutton,'Enable','off');
    set(handles.evaluate_single_pushbutton,'Enable','off');
    set(handles.evaluate_multi_pushbutton,'Enable','off');
    set(handles.systolic_pushbutton,'Enable','off');
    set(handles.diastolic_pushbutton,'Enable','off');
    
    set(handles.pushbuttonDiastol,'Enable','on');
    set(handles.pushbuttonSystolePhase,'Enable','on');
    set(handles.pushbuttonDiastolePhase,'Enable','on');
    
    guidata(hObject, handles);
catch ME
    showMessage(handles.info_text,'error',' Error: An unexpected error has occured!');
    disp(ME);
end
% --- Executes on button press in auto_raido.
function auto_raido_Callback(hObject, eventdata, handles)
try
    resetMessage(handles.info_text);
    set(handles.semi_auto_raido,'Value',0);
    set(handles.metricsBox, 'String', '');
    delete(get(handles.display,'Children'));
    delete(get(handles.systolewindow,'Children'));
    delete(get(handles.diastolewindow,'Children'));
    
    set(handles.convert_nifti_pushbutton,'Enable','on');
    set(handles.load_pushbutton,'Enable','on');
    set(handles.elipse_radiobutton,'Enable','on');
    set(handles.polygon_radiobutton,'Enable','on');
    set(handles.free_hand_radiobutton,'Enable','on');
    set(handles.start_training_pushbutton,'Enable','on');
    set(handles.evaluate_single_pushbutton,'Enable','on');
    set(handles.evaluate_multi_pushbutton,'Enable','on');
    set(handles.systolic_pushbutton,'Enable','on');
    set(handles.diastolic_pushbutton,'Enable','on');
    
    
    set(handles.pushbuttonDiastol,'Enable','off');
    set(handles.pushbuttonSystolePhase,'Enable','off');
    set(handles.pushbuttonDiastolePhase,'Enable','off');
    guidata(hObject, handles);
catch ME
    showMessage(handles.info_text,'error',' Error: An unexpected error has occured!');
    disp(ME);
end

%% ---------------------------------KMEANS-----------------------------%%

%% --- Executes on button press in pushbuttonDiastol.
function pushbuttonDiastol_Callback(hObject, eventdata, handles)
set(handles.metricsBox, 'String', '');
delete(get(handles.display,'Children'));
delete(get(handles.systolewindow,'Children'));
delete(get(handles.diastolewindow,'Children'));
Folder = uigetdir('Image Folder');
FileList = dir(fullfile(Folder, '*.nii.gz'));

slices = [];

for i = 1 : length(FileList)
    A1 = strfind(FileList(i).name, 'gt');
    if isempty(A1)
        A2 = strfind(FileList(i).name, '4d');
        if isempty(A2)
            tmp = FileList(i);
            slices = [slices;  tmp];
        end
    end
end


%  reading the systolic phase
name1 = slices(1).name;
path1 = FileList(1).folder;
fullfilenames1 = fullfile(path1, name1);
systole = niftiread(fullfilenames1);

cine1 = zeros(size(systole));
sz = size(cine1);

for j = 1:sz(3)
    cine1(:,:,j) = uint8(systole(:,:,j));
end

handles.cine1 = cine1;
%  Segmentation of the Systolic phase
LVlocal1 = cineLVLocalize(cine1);
cine1Smoothed = adaptiveSmoothing(cine1);
kInfo1 = getKClusters(cine1Smoothed,22);
combinedClusters1 = kMeansClusterCombine(kInfo1);
cine1LVseg = finalClusterCombine(combinedClusters1,LVlocal1);
handles.systoleSeg = cine1LVseg;


%  reading Diastolic phase
name2 = slices(2).name;
path2 = FileList(2).folder;
fullfilenames2 = fullfile(path2, name2);
diastole = niftiread(fullfilenames2);

cine2 = zeros(size(diastole));
sz = size(cine2);

for j = 1:sz(3)
    cine2(:,:,j) = uint8(diastole(:,:,j));
end

handles.cine2 = cine2;

%  Segmentation of the Diastolic phase
LVlocal2 = cineLVLocalize(cine2);
cine1Smoothed = adaptiveSmoothing(cine2);
kInfo2 = getKClusters(cine1Smoothed,22);
combinedClusters2 = kMeansClusterCombine(kInfo2);
cine2LVseg = finalClusterCombine(combinedClusters2,LVlocal2);
handles.diastoleSeg = cine2LVseg;

DV = cardiacStatistics(cine1LVseg);
DV = DV/1000;


SV = cardiacStatistics(cine2LVseg);
SV = SV/1000;

EF = ((DV - SV) / DV) * 100;

slcThickness = num2str(5);
slcGap = num2str(5);
Dv = num2str(DV);
Sv = num2str(SV);
Ef = num2str(EF);


information = sprintf('     Cardiac Info... \n\nSlice Thickness: %s          End-Systolic Volume: %smL \n\nSlice Gap: %s                   End-Diastolic Volume: %smL\n\n                                       Ejection Fraction: %s%\n\n',...
    slcThickness, Sv, slcGap, Dv, Ef);
set(handles.metricsBox, 'String', information);


axes(handles.display)
imshow(cine2(:,:,5),[]);
axis off
hold on

temp = zeros(sz(1),sz(2),3);
overlay = imagesc(temp);
temp(:,:,1) = cine2LVseg(:,:,5);
set(overlay,'AlphaData',cine2LVseg(:,:,5) * 0.7,'CData',temp);
colormap('gray')

guidata(hObject, handles);


%% --- Executes on button press in pushbuttonSystolePhase.
function pushbuttonSystolePhase_Callback(hObject, eventdata, handles)
handles.index = 0;
set(gcbo,'userdata',1);

cine1 = handles.cine1;
handles.slices = cine1;
systoleSeg = handles.systoleSeg;
handles.segment = systoleSeg;
guidata(hObject, handles);

% displaying segmented parts
axes(handles.systolewindow);
im2 = imshow(cine1(:,:,1),[]);
hold on
axis off
sz = size(cine1);
tmp_ov = zeros(sz(1),sz(2),3);
ov = imagesc(tmp_ov);
"set(gcbo,'userdata',1)";
set(handles.exit,'userdata',0);
while ~get(handles.exit,'userdata')
    for j = 1:sz(3)
        set(im2,'CData',cine1(:,:,j));
        tmp_ov(:,:,1) = systoleSeg(:,:,j);
        set(ov,'AlphaData',systoleSeg(:,:,j) * 0.7,'CData',tmp_ov);
        colormap('gray')
        drawnow;
        pause(1/sz(3));
    end
end


%% --- Executes on button press in pushbuttonDiastolePhase.
function pushbuttonDiastolePhase_Callback(hObject, eventdata, handles)
handles.index = 0;
set(gcbo,'userdata',1);

cine2 = handles.cine2;
handles.slices = cine2;
diastoleSeg = handles.diastoleSeg;
handles.segment  = diastoleSeg;
sz = size(cine2);
guidata(hObject, handles);

% displaying segmented parts
axes(handles.diastolewindow);
im2 = imshow(cine2(:,:,1),[]);
hold on
axis off
tmp_ov = zeros(sz(1),sz(2),3);
ov = imagesc(tmp_ov);
"set(gcbo,'userdata',1)";
set(handles.exit,'userdata',0);
while ~get(handles.exit,'userdata')
    for j = 1:sz(3)
        set(im2,'CData',cine2(:,:,j));
        tmp_ov(:,:,1) = diastoleSeg(:,:,j);
        set(ov,'AlphaData',diastoleSeg(:,:,j) * 0.7,'CData',tmp_ov);
        colormap('gray')
        drawnow;
        pause(1/sz(3));
    end
end


%% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
set(gcbo,'userdata',1);
clear all force;
clc;
delete(mainFile);


%% ------------------------Deep_Learning-------------------------------%%
%% --- Executes on button press in convert_nifti_pushbutton.
function convert_nifti_pushbutton_Callback(hObject, eventdata, handles)
try
    resetMessage(handles.info_text);
    set(handles.metricsBox, 'String', '');
    delete(get(handles.display,'Children'));
    delete(get(handles.systolewindow,'Children'));
    delete(get(handles.diastolewindow,'Children'));
    Folder = uigetdir('./training/','Image Folder');
    if(length(Folder)>1)
        FileList = dir(fullfile(Folder, '*.nii.gz'));
        
        slices = [];
        
        for i = 1 : length(FileList)
            A1 = strfind(FileList(i).name, 'gt');
            if isempty(A1)
                A2 = strfind(FileList(i).name, '4d');
                if isempty(A2)
                    tmp = FileList(i);
                    slices = [slices;  tmp];
                end
            end
        end
        %  reading the systolic phase
        name1 = slices(1).name;
        path1 = FileList(1).folder;
        fullfilenames1 = fullfile(path1, name1);
        systole = niftiread(fullfilenames1);
        
        cine1 = zeros(size(systole));
        sz = size(cine1);
        count_exist_images = length(dir(fullfile(handles.image_path,'*.jpg')));
        for j = 1:sz(3)
            imwrite(uint8(systole(:,:,j)),[handles.image_path sprintf( '%05d', (j+count_exist_images) ) '.jpg'])
        end
        
        %  reading Diastolic phase
        name2 = slices(2).name;
        path2 = FileList(2).folder;
        fullfilenames2 = fullfile(path2, name2);
        diastole = niftiread(fullfilenames2);
        
        cine2 = zeros(size(diastole));
        sz = size(cine2);
        count_exist_images = length(dir(fullfile(handles.image_path,'*.jpg')));
        for j = 1:sz(3)
            imwrite(uint8(systole(:,:,j)),[handles.image_path sprintf( '%05d', (j+count_exist_images) ) '.jpg'])
        end
        showMessage(handles.info_text,'success',' Success: Selected nifti file has been converted successfully.');
    end
catch ME
    showMessage(handles.info_text,'error',' Error: An unexpected error has occured!');
    disp(ME);
end

%% --- Executes on button press in load_pushbutton.
function load_pushbutton_Callback(hObject, eventdata, handles)
try
    resetMessage(handles.info_text);
    set(handles.metricsBox, 'String', '');
    delete(get(handles.display,'Children'));
    delete(get(handles.systolewindow,'Children'));
    delete(get(handles.diastolewindow,'Children'));
    [names,path] = uigetfile('./Left-Ventricle-Database/images/.jpg','Select a JPG file', 'MultiSelect', 'on');
    if isnumeric(names)
        return
    end
    if ~iscellstr(names)
        names = cellstr(names);
    end
    handles.imageNames = names;
    handles.imageCounts = length(handles.imageNames);
    handles.path = path;
    %     set(handles.slice_thickness_text,'String',strcat(num2str(handles.imageCounts),{' '},'images are loading...'));
    handles.fileNo = 0;
    if handles.imageCounts > 0
        handles.fileNo = handles.fileNo + 1;
        handles.fileName = char(handles.imageNames(handles.fileNo));
        fullFileName = strcat(path,handles.fileName);
        handles.image = imread(fullFileName);
        axes(handles.display);
        imshow(handles.image,[]);
        axis off
    end
    %     if handles.imageCounts > 1
    %         set(handles.pushbuttonNext,'Visible','on');
    %     end
    %     set(handles.slice_thickness_text,'String',strcat(num2str(handles.imageCounts),{' '},'images have been loaded.'));
    guidata(hObject, handles);
catch ME
    showMessage(handles.info_text,'error',' Error: An unexpected error has occured!');
    disp(ME);
end

%% --- Executes on button press in pushbuttonNext.
function pushbuttonNext_Callback(hObject, eventdata, handles)
try
    resetMessage(handles.info_text);
    if(handles.auto_raido.Value ==1)
        if  handles.imageCounts > 1 && handles.fileNo < handles.imageCounts
            handles.fileNo = handles.fileNo + 1;
            handles.fileName = char(handles.imageNames(handles.fileNo));
            fullFileName = strcat(handles.path,handles.fileName);
            handles.image = imread(fullFileName);
            %bring axes into focus anf show image
            axes(handles.display);
            imshow(handles.image, []);
            set(handles.elipse_radiobutton,'Value',0);
            set(handles.polygon_radiobutton,'Value',0);
            set(handles.free_hand_radiobutton,'Value',0);
            %         set(handles.previous_pushbutton,'Visible','on');
            %         if(handles.fileNo == handles.imageCounts )
            %             set(handles.pushbuttonNext,'Visible','off');
            %             set(handles.previous_pushbutton,'Visible','on');
            %         end
        end
    end
    %%Kmeans
    if(handles.semi_auto_raido.Value ==1)
        index = handles.index;
        slices = handles.slices;
        segment = handles.segment;
        sz = size(slices);
        if(index == sz(3))
            return;
        end
        index = index + 1;
        handles.index = index;
        
        axes(handles.display)
        im1 = imshow(slices(:,:,index),[]);
        axis off
        hold on
        
        temp = zeros(sz(1),sz(2),3);
        overlay = imagesc(temp);
        set(im1,'CData',slices(:,:,index));
        temp(:,:,1) = segment(:,:,index);
        set(overlay,'AlphaData',segment(:,:,index) * 0.7,'CData',temp);
        colormap('gray')
    end
    guidata(hObject, handles);
catch ME
    showMessage(handles.info_text,'error',' Error: An unexpected error has occured!');
    disp(ME);
end

%% --- Executes on button press in previous_pushbutton.
function previous_pushbutton_Callback(hObject, eventdata, handles)
try
    resetMessage(handles.info_text);
    if(handles.auto_raido.Value ==1)
        if handles.imageCounts > 1 && handles.fileNo > 1
            handles.fileNo = handles.fileNo - 1;
            handles.fileName = char(handles.imageNames(handles.fileNo));
            fullFileName = strcat(handles.path,handles.fileName);
            handles.image = imread(fullFileName);
            axes(handles.display);
            imshow(handles.image, []);
            set(handles.elipse_radiobutton,'Value',0);
            set(handles.polygon_radiobutton,'Value',0);
            set(handles.free_hand_radiobutton,'Value',0);
            %         if(handles.fileNo == 1 )
            %             set(handles.previous_pushbutton,'Visible','off');
            %             set(handles.pushbuttonNext,'Visible','on');
            %         end
        end
    end
    
    %Kmeans
    if(handles.semi_auto_raido.Value ==1)
        index = handles.index;
        slices = handles.slices;
        segment = handles.segment;
        if(index == 1)
            return;
        end
        
        index = index - 1;
        handles.index = index;
        
        sz = size(slices);
        
        axes(handles.display)
        im1 = imshow(slices(:,:,index),[]);
        axis off
        hold on
        
        temp = zeros(sz(1),sz(2),3);
        overlay = imagesc(temp);
        set(im1,'CData',slices(:,:,index));
        temp(:,:,1) = segment(:,:,index);
        set(overlay,'AlphaData',segment(:,:,index) * 0.7,'CData',temp);
        colormap('gray')
    end
    guidata(hObject, handles);
catch ME
    showMessage(handles.info_text,'error',' Error: An unexpected error has occured!');
    disp(ME);
end

%% --- Executes on button press in create_ROI_pushbutton.
function create_ROI_pushbutton_Callback(hObject, eventdata, handles)
try
    resetMessage(handles.info_text);
    if(handles.elipse_radiobutton.Value == 1)
        position = handles.hE.getVertices;
        binaryMask = handles.hE.createMask;
        roi=findROI(position(:,1),position(:,2), binaryMask,handles.folder_name,handles.fileName,handles.image_path,handles.annot_path);
        %         figure
        %         imshow(roi);
        %         binaryMask = handles.hE.createMask;
        imwrite(roi,strcat(handles.mask_path,handles.fileName));
        
        handles.fileName = char(handles.imageNames(handles.fileNo));
        fullFileName = strcat(handles.path,handles.fileName);
        handles.image = imread(fullFileName);
        %bring axes into focus anf show image
        axes(handles.display);
        imshow(handles.image, []);
        
    elseif(handles.polygon_radiobutton.Value == 1)
        roi=findROI(handles.x,handles.y,handles.binaryMask,handles.folder_name,handles.fileName,handles.image_path,handles.annot_path);
        imwrite(roi,strcat(handles.mask_path,handles.fileName));
    elseif(handles.free_hand_radiobutton.Value == 1)
        position = handles.hE.getPosition;
        binaryMask = handles.hE.createMask;
        roi=findROI(position(:,1),position(:,2), binaryMask,handles.folder_name,handles.fileName,handles.image_path,handles.annot_path);
        imwrite(roi,strcat(handles.mask_path,handles.fileName));
    end
    %reload current image
    handles.fileName = char(handles.imageNames(handles.fileNo));
    fullFileName = strcat(handles.path,handles.fileName);
    handles.image = imread(fullFileName);
    %bring axes into focus anf show image
    axes(handles.display);
    imshow(handles.image, []);
    
    set(handles.elipse_radiobutton,'Value',0);
    set(handles.polygon_radiobutton,'Value',0);
    set(handles.free_hand_radiobutton,'Value',0);
    set(handles.create_ROI_pushbutton,'Enable','off');
    guidata(hObject, handles);
catch ME
    showMessage(handles.info_text,'error',' Error: An unexpected error has occured!');
    disp(ME);
end

%% --- Executes on button press in elipse_radiobutton.
function elipse_radiobutton_Callback(hObject, eventdata, handles)
try
    resetMessage(handles.info_text);
    set(handles.create_ROI_pushbutton,'Enable','on');
    handles.hE = imellipse;
    addNewPositionCallback(handles.hE, @(p) setPosition(p));
    guidata(hObject, handles);
catch ME
    showMessage(handles.info_text,'error',' Error: An unexpected error has occured!');
    disp(ME);
end

%% --- Executes on button press in polygon_radiobutton.
function polygon_radiobutton_Callback(hObject, eventdata, handles)
try
    resetMessage(handles.info_text);
    set(handles.create_ROI_pushbutton,'Enable','on');
    [handles.binaryMask,handles.x,handles.y] = roipoly(handles.image);
    guidata(hObject, handles);
catch ME
    showMessage(handles.info_text,'error',' Error: An unexpected error has occured!');
    disp(ME);
end

%% --- Executes on button press in free_hand_radiobutton.
function free_hand_radiobutton_Callback(hObject, eventdata, handles)
try
    resetMessage(handles.info_text);
    set(handles.create_ROI_pushbutton,'Enable','on');
    handles.hE= imfreehand(gca,'closed','false');
    addNewPositionCallback(handles.hE, @(p) setPosition(p));
    guidata(hObject, handles);
catch ME
    showMessage(handles.info_text,'error',' Error: An unexpected error has occured!');
    disp(ME);
end

%% --- Executes on button press in start_training_pushbutton.
function start_training_pushbutton_Callback(hObject, eventdata, handles)
try
    resetMessage(handles.info_text);
    set(handles.metricsBox, 'String', '');
    delete(get(handles.display,'Children'));
    delete(get(handles.systolewindow,'Children'));
    delete(get(handles.diastolewindow,'Children'));
    command_train_network = 'python network_training_LV.py 1';
    [status_test, commandOut_test] = system(command_train_network,'-echo')
    if status_test==0
        fprintf('squared result is %d\n',str2num(commandOut_test));
    end
    set(handles.slice_thickness_text,'String','Training has finished!');
catch ME
    showMessage(handles.info_text,'error',' Error: An unexpected error has occured!');
    disp(ME);
end

%% --- Executes on button press in evaluate_single_pushbutton.
function evaluate_single_pushbutton_Callback(hObject, eventdata, handles)
try
    resetMessage(handles.info_text);
    set(handles.metricsBox, 'String', '');
    delete(get(handles.display,'Children'));
    delete(get(handles.systolewindow,'Children'));
    delete(get(handles.diastolewindow,'Children'));
    [name,path] = uigetfile('./Left-Ventricle-Database/images/.jpg','Select a JPG file');
    if(length(name) > 1)
        %         f = waitbar(0.1,'Please wait...','Name','Evaluation');
        %         pause(1)
        %         waitbar(.3,f,'Loading');
        %         pause(0.2);
        fullFileName = strcat(path,name);
        commandpython_eval = ['python Mask_RCNN_segmentation.py ',char(strcat('single',{' '},fullFileName))];
        
        %         waitbar(.5,f,'Processing');
        %         pause(0.1)
        %         waitbar(.6,f,'Processing');
        %         pause(0.1)
        %         waitbar(.7,f,'Processing');
        %         pause(0.1)
        %         waitbar(.8,f,'Processing');
        %         pause(0.1)
        [status_eval, commandOut_eval] = system(commandpython_eval,'-echo');
        
        if status_eval == 0
            result = imread(strcat('./SegmentedImages/',name));
            delete(strcat('./SegmentedImages/',name));
            axes(handles.display);
            imshow(result,[]);
            axis off
            %             close(f);
        end
    end
catch ME
    showMessage(handles.info_text,'error',' Error: An unexpected error has occured!');
    disp(ME);
end

%% --- Executes on button press in evaluate_multi_pushbutton.
function evaluate_multi_pushbutton_Callback(hObject, eventdata, handles)
try
    resetMessage(handles.info_text);
    set(handles.metricsBox, 'String', '');
    delete(get(handles.display,'Children'));
    delete(get(handles.systolewindow,'Children'));
    delete(get(handles.diastolewindow,'Children'));
    Folder = uigetdir('./training/','Image Folder');
    if(length(Folder)>1)
        FileList = dir(fullfile(Folder, '*.nii.gz'));
        slices = [];
        for i = 1 : length(FileList)
            A1 = strfind(FileList(i).name, 'gt');
            if isempty(A1)
                A2 = strfind(FileList(i).name, '4d');
                if isempty(A2)
                    tmp = FileList(i);
                    slices = [slices;  tmp];
                end
            end
        end
        %%  reading the systolic phase
        name_sys = slices(1).name;
        path_sys = FileList(1).folder;
        fullfilenames_sys = fullfile(path_sys, name_sys);
        systole = niftiread(fullfilenames_sys);
        
        cine_sys = zeros(size(systole));
        sz = size(cine_sys);
        count_exist_images_sys = length(dir(fullfile(handles.evaluation_image_path,'*.jpg')));
        fullFileNames_sys = '';
        fileNames_sys = '';
        %% write original images
        for j = 1:sz(3)
            n = [sprintf( '%05d', (j+count_exist_images_sys) ) '.jpg'];
            pn = [handles.evaluation_image_path n]
            fullFileNames_sys = strcat(fullFileNames_sys,pn,',');
            fileNames_sys = strcat(fileNames_sys,n,',');
            imwrite(uint8((systole(:,:,j))),pn)
        end
        %% run segmentation
        if(length(name_sys) > 1)
            fullFileNames_sys = extractBetween(fullFileNames_sys,1,strlength(fullFileNames_sys)-1);
            fileNameList_sys = split(fileNames_sys,',');
            commandpython_eval = ['python Mask_RCNN_segmentation.py ',char(strcat('multi',{' '},fullFileNames_sys))];
            %             set(handles.slice_thickness_text,'String','Evaluation in progress...');
            
            [status_eval, commandOut_eval] = system(commandpython_eval,'-echo');
            %% calculate volume
            handles.result_sys = [];
            if status_eval == 0
                for i = 1:sz(3)
                    org_image_name = strcat(handles.evaluation_image_path,char(fileNameList_sys(i)));
                    sgm_image_name = strcat('./SegmentedImages/',char(fileNameList_sys(i)));
                    if exist(sgm_image_name, 'file') == 2 && exist(org_image_name, 'file') == 2
                        org_image = imread(org_image_name);
                        sgm_image = imread(sgm_image_name);
                        all_images_sys{i} = sgm_image;
                        all_masks_sys{i} = imbinarize(abs(org_image-rgb2gray(sgm_image)));
                    end
                end
                handles.result_sys = all_images_sys;
                
                DV = cardiacVolume(all_masks_sys);
                DV = DV/1000;
            end
        end
        %%  reading the dialostic phase
        name_dis = slices(2).name;
        path_dis = FileList(2).folder;
        fullfilenames_dis = fullfile(path_dis, name_dis);
        diastol = niftiread(fullfilenames_dis);
        
        cine_dis = zeros(size(diastol));
        sz = size(cine_dis);
        count_exist_images_dis = length(dir(fullfile(handles.evaluation_image_path,'*.jpg')));
        fullFileNames_dis = '';
        fileNames_dis = '';
        %% write original images
        for j = 1:sz(3)
            n = [sprintf( '%05d', (j+count_exist_images_dis) ) '.jpg'];
            pn = [handles.evaluation_image_path n]
            fullFileNames_dis = strcat(fullFileNames_dis,pn,',');
            fileNames_dis = strcat(fileNames_dis,n,',');
            imwrite(uint8((diastol(:,:,j))),pn)
        end
        %% run segmentation
        if(length(name_dis) > 1)
            fullFileNames_dis = extractBetween(fullFileNames_dis,1,strlength(fullFileNames_dis)-1);
            fileNameList_dis = split(fileNames_dis,',');
            %%---------------------------------------------
            handles.imageNames = fileNameList_dis;
            handles.path = './SegmentedImages/';
            
            commandpython_eval = ['python Mask_RCNN_segmentation.py ',char(strcat('multi',{' '},fullFileNames_dis))];
            %             set(handles.slice_thickness_text,'String','Evaluation in progress...');
            
            [status_eval, commandOut_eval] = system(commandpython_eval,'-echo');
            %% calculate volume
            handles.result_dis = [];
            if status_eval == 0
                for i = 1:sz(3)
                    org_image_name = strcat(handles.evaluation_image_path,char(fileNameList_dis(i)));
                    sgm_image_name = strcat('./SegmentedImages/',char(fileNameList_dis(i)));
                    if exist(sgm_image_name, 'file') == 2 && exist(org_image_name, 'file') == 2
                        org_image = imread(org_image_name);
                        sgm_image = imread(sgm_image_name);
                        all_images_dis{i} = sgm_image;
                        all_masks_dis{i} = imbinarize(abs(org_image-rgb2gray(sgm_image)));
                    end
                end
                handles.result_dis = all_images_dis;
                
                SV = cardiacVolume(all_masks_dis);
                SV = SV/1000;
            end
        end
        
        EF = ((DV - SV) / DV) * 100;
        slcThickness = num2str(5);
        slcGap = num2str(5);
        Dv = num2str(DV);
        Sv = num2str(SV);
        Ef = num2str(EF);
        
        information = sprintf('     Cardiac Info... \n\nSlice Thickness: %s          End-Systolic Volume: %smL \n\nSlice Gap: %s                   End-Diastolic Volume: %smL\n\n                                       Ejection Fraction: %s%\n\n',...
            slcThickness, Sv, slcGap, Dv, Ef);
        set(handles.metricsBox, 'String', information);
        
        %% test
        sz = size(handles.result_dis);
        handles.imageCounts = sz(2);
        handles.fileNo = 0;
        if handles.imageCounts > 0
            handles.fileNo = handles.fileNo + 1;
            handles.fileName = char(handles.imageNames(handles.fileNo));
            fullFileName = strcat(handles.path,handles.fileName);
            handles.image = imread(fullFileName);
            axes(handles.display);
            imshow(handles.image,[]);
            axis off
        end
    end
    guidata(hObject, handles);
catch ME
    showMessage(handles.info_text,'error',' Error: An unexpected error has occured!');
    disp(ME);
end

%% --- Executes on button press in systolic_pushbutton.
function systolic_pushbutton_Callback(hObject, eventdata, handles)
try
    resetMessage(handles.info_text);
    sz = size(handles.result_sys);
    set(handles.exit,'userdata',0);
    while ~get(handles.exit,'userdata')
        for i=1:sz(2)
            axes(handles.systolewindow);
            imshow(handles.result_sys{i});
            pause(0.2);
        end
    end
catch ME
    showMessage(handles.info_text,'error',' Error: An unexpected error has occured!');
    disp(ME);
end

%% --- Executes on button press in diastolic_pushbutton.
function diastolic_pushbutton_Callback(hObject, eventdata, handles)
try
    resetMessage(handles.info_text);
    sz = size(handles.result_dis);
    set(handles.exit,'userdata',0);
    while ~get(handles.exit,'userdata')
        for i=1:sz(2)
            axes(handles.diastolewindow);
            imshow(handles.result_dis{i});
            pause(0.2);
        end
    end
catch ME
    showMessage(handles.info_text,'error',' Error: An unexpected error has occured!');
    disp(ME);
end

function setPosition(p)

%% --- Executes during object creation, after setting all properties.
function trainng_info_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trainng_info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
