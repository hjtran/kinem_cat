function varargout = coord_params_gui(varargin)
% COORD_PARAMS_GUI MATLAB code for coord_params_gui.fig
%      COORD_PARAMS_GUI, by itself, creates a new COORD_PARAMS_GUI or raises the existing
%      singleton*.
%
%      params = COORD_PARAMS_GUI returns param variable of class cell
%      composed of params = {toeText, tasks, numTasks, oneFile};
%
%      COORD_PARAMS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COORD_PARAMS_GUI.M with the given input arguments.
%
%      COORD_PARAMS_GUI('Property','Value',...) creates a new COORD_PARAMS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before coord_params_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to coord_params_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help coord_params_gui

% Last Modified by GUIDE v2.5 28-May-2014 09:28:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @coord_params_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @coord_params_gui_OutputFcn, ...
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


% --- Executes just before coord_params_gui is made visible.
function coord_params_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to coord_params_gui (see VARARGIN)

% Choose default command line output for coord_params_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
varExist = exist('coord_params.mat');
if varExist == 2;
    load('coord_params.mat');
    set(handles.edit1,'String',edit1);
    set(handles.edit2,'String',edit2);
end


% UIWAIT makes coord_params_gui wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = coord_params_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if size(handles) ~= 0
toeText = [get(handles.edit1,'String') '.txt'];
oneFile = get(handles.radiobutton1,'Value');
numTasks = get(handles.radiobutton3,'Value');
if numTasks == 1
    numTasks = 1;
    tasks = get(handles.edit2,'String');
elseif numTasks == 0
    numTasks = 2;
    tasks = [get(handles.edit2,'String') '&' get(handles.edit3,'String');];
end
params = {toeText, tasks, numTasks, oneFile};
varargout{1} = params;
delete(handles.figure1);
end



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
edit1 = get(handles.edit1,'String');
edit2 = get(handles.edit2,'String');
save('coord_params.mat','edit1','edit2');
uiresume(handles.figure1);
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.radiobutton1,'Value')
    set(handles.radiobutton2,'Value',0);
else
    set(handles.radiobutton2,'Value',1);
end

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.radiobutton2,'Value')
    set(handles.radiobutton1,'Value',0)
else
    set(handles.radiobutton1,'Value',1)
end

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.radiobutton3,'Value')
    set(handles.radiobutton4,'Value',0);
    set(handles.edit3,'Visible','off');
    set(handles.text7,'Visible','off');
    set(handles.text8,'Visible','off');
else
    set(handles.radiobutton4,'Value',1);
    set(handles.edit3,'Visible','on');
    set(handles.text7,'Visible','on');
    set(handles.text8,'Visible','on');
end

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.radiobutton4,'Value')
    set(handles.radiobutton3,'Value',0);
    set(handles.edit3,'Visible','on');
    set(handles.text7,'Visible','on');
    set(handles.text8,'Visible','on');
else
    set(handles.radiobutton3,'Value',1);
    set(handles.edit3,'Visible','off');
    set(handles.text7,'Visible','off');
    set(handles.text8,'Visible','off');
end
% Hint: get(hObject,'Value') returns toggle state of radiobutton4



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
