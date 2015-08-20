function varargout = bin_params_gui(varargin)
% BIN_PARAMS_GUI MATLAB code for bin_params_gui.fig
%      bin_params_gui opens the GUI that asks for the parameters for bin
%      analysis. Saves parameters between runs for convenience. returns a
%      parameter value explained below
%
%      BIN_PARAMS_GUI, by itself, creates a new BIN_PARAMS_GUI or raises the existing
%      singleton*.
%
%      params = BIN_PARAMS_GUI returns params = {density, angleOrLED,  edit6, volume, edit7, prop, tasks, numTasks, oneFile};
%
%      BIN_PARAMS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BIN_PARAMS_GUI.M with the given input arguments.
%
%      BIN_PARAMS_GUI('Property','Value',...) creates a new BIN_PARAMS_GUI or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bin_params_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bin_params_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bin_params_gui

% Last Modified by GUIDE v2.5 28-May-2014 09:44:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bin_params_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @bin_params_gui_OutputFcn, ...
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

% --- Executes just before bin_params_gui is made visible.
function bin_params_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bin_params_gui (see VARARGIN)

% Choose default command line output for bin_params_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false, false);



% UIWAIT makes bin_params_gui wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = bin_params_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% This function is responsible for outputting the return values for the
% GUI.
varargout{1} = handles.output;
radiobutton19 = get(handles.radiobutton19,'Value');
si = get(handles.si,'Value');
if si == 1
    listbox1 = 1;
    listbox2 = get(handles.listbox2,'Value');
else
    listbox1 = get(handles.listbox1,'Value');
    listbox2 = 1;
end
density = [get(handles.density,'String') '.txt'];
volume = str2double(get(handles.volume,'String'));
edit6 = str2double(get(handles.edit6,'String'));
edit7 = [get(handles.edit7,'String')];
if radiobutton19 == 1
    angleOrLED = 'LED';
else
    angleOrLED = 'Angle';
end
if get(handles.radiobutton20,'Value')
    oneFile = 1;
else
    oneFile = 0;
end
if si == 1
    prop = listbox2;
    if prop == 1, prop = 'Angle'; end
    if prop == 2, prop = 'C.Angle'; end
    if prop == 3, prop = 'S.Angle'; end
    if prop == 4, prop = 'Vel'; end
    if prop == 5, prop = 'Acc'; end
else
    prop = listbox1;
    if prop == 1, prop = 'Px'; end
    if prop == 2, prop = 'Py'; end
    if prop == 3, prop = 'Pz'; end
    if prop == 4, prop = 'Vx'; end
    if prop == 5, prop = 'Vy'; end
    if prop == 6, prop = 'Vz'; end
    if prop == 7, prop = 'Ax'; end
    if prop == 8, prop = 'Ay'; end
    if prop == 9, prop = 'Az'; end
end
if get(handles.radiobutton22,'Value')
    numTasks = 1;
    tasks = get(handles.edit8,'String');
else
    numTasks = 2;
    tasks = [get(handles.edit8,'String') '&' get(handles.edit9,'String')];
end
params = {density, angleOrLED,  edit6, volume, edit7, prop, tasks, numTasks, oneFile};
varargout{1} = params;
delete(handles.figure1);



% --- Executes during object creation, after setting all properties.
function density_CreateFcn(hObject, eventdata, handles)
% hObject    handle to density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function density_Callback(hObject, eventdata, handles)
% hObject    handle to density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of density as text
%        str2double(get(hObject,'String')) returns contents of density as a double


% Save the new density value


% --- Executes during object creation, after setting all properties.
function volume_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function volume_Callback(hObject, eventdata, handles)
% hObject    handle to volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of volume as text
%        str2double(get(hObject,'String')) returns contents of volume as a doubl

% Save the new volume value




% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

initialize_gui(gcbf, handles, true, false);


% --- Executes when selected object changed in unitgroup.
function unitgroup_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in unitgroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset, isdefault)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.

% This function sees if there were parameters saved from a previous session
% and if there are, sets them.
if isdefault == 0
    varExist = exist('bin_params.mat');
    if varExist == 2;
        load('bin_params.mat');
        set(handles.radiobutton19,'Value',radiobutton19);
        set(handles.si,'Value',si);
        set(handles.listbox1,'Value',listbox1);
        set(handles.density,'String',density);
        set(handles.volume,'String',volume);
        set(handles.edit6,'String',edit6);
        set(handles.edit7,'String',edit7);
        set(handles.edit8,'String',edit8);
        set(handles.edit9,'String',edit9);
        set(handles.listbox2,'Value',listbox2);
        if si == 1
            set(handles.listbox1,'Visible','off');
            set(handles.listbox2,'Visible','on');
        else
            set(handles.listbox1,'Visible','on');
            set(handles.listbox2,'Visible','off');
        end
        
    end
else
    set(handles.radiobutton19,'Value',1);
    set(handles.si,'Value',0);
    set(handles.listbox1,'Value',1);
    set(handles.density,'String','Toe');
    set(handles.volume,'String','1');
    set(handles.edit6,'String','20');
    set(handles.edit7,'String','Wrist');
    set(handles.edit8,'String','Flat');
    set(handles.edit9,'String','Rocks');
    set(handles.listbox2,'Value',1);
    set(handles.listbox1,'Visible','on');
    set(handles.listbox2,'Visible','off');
end







% Update handles structure
guidata(handles.figure1, handles);



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in radiobutton19.
function radiobutton19_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.radiobutton19,'Value')
    set(handles.si,'Value',0);
    set(handles.listbox1,'Visible','on');
    set(handles.listbox2,'Visible','off');
    
else
    set(handles.si,'Value',1);
    set(handles.listbox1,'Visible','off');
    set(handles.listbox2,'Visible','on');
end
% Hint: get(hObject,'Value') returns toggle state of radiobutton19


% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
% hObject    handle to calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

radiobutton19 = get(handles.radiobutton19,'Value');
si = get(handles.si,'Value');
if si == 1
    listbox1 = 1;
    listbox2 = get(handles.listbox2,'Value');
else
    listbox1 = get(handles.listbox1,'Value');
    listbox2 = 1;
end
density = get(handles.density,'String');
volume = get(handles.volume,'String');
edit6 = get(handles.edit6,'String');
edit7 = get(handles.edit7,'String');
edit8 = get(handles.edit8,'String');
edit9 = get(handles.edit9,'String');
save('bin_params.mat','radiobutton19','si','listbox1','density','volume','edit6','edit7','listbox2','edit8','edit9');
if radiobutton19 == 1
    angleOrLED = 'LED';
else
    angleOrLED = 'Angle';
end
if get(handles.radiobutton20,'Value')
    oneFile = 1;
else
    oneFile = 0;
end
if si == 1
    prop = listbox2;
else
    prop = listbox1;
end
params = {density, angleOrLED,  edit6, volume, edit7, prop, oneFile};
handles.output = params;
uiresume(handles.figure1);



% --- Executes on button press in si.
function si_Callback(hObject, eventdata, handles)
% hObject    handle to si (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.si,'Value')
    set(handles.radiobutton19,'Value',0);
    set(handles.listbox1,'Visible','off');
    set(handles.listbox2,'Visible','on');
else
    set(handles.radiobutton19,'Value',1);
    set(handles.listbox1,'Visible','on');
    set(handles.listbox2,'Visible','off');
end
% Hint: get(hObject,'Value') returns toggle state of si

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initialize_gui(gcbf, handles, true, true);


function radiobutton20_Callback(hObject, eventdata, handles)
if get(radiobutton20,'Value')
    set(handles.radiobutton21,'Value','0');
else
    set(handles.radiobutton21,'Value','1');
end

function radiobutton21_Callback(hObject, eventdata, handles)
if get(radiobutton21,'Value')
    set(handles.radiobutton20,'Value','0');
else
    set(handles.radiobutton20,'Value','1');
end


% --- Executes on button press in radiobutton22.
function radiobutton22_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.radiobutton22,'Value')
    set(handles.radiobutton23,'Value',0);
    set(handles.text24,'Visible','off');
    set(handles.text25,'Visible','off');
    set(handles.edit9,'Visible','off');
else
    set(handles.radiobutton23,'Value',1);
    set(handles.text24,'Visible','on');
    set(handles.text25,'Visible','on');
    set(handles.edit9,'Visible','on');
end

% Hint: get(hObject,'Value') returns toggle state of radiobutton22


% --- Executes on button press in radiobutton23.
function radiobutton23_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.radiobutton23,'Value')
    set(handles.radiobutton22,'Value',0);
    set(handles.text24,'Visible','on');
    set(handles.text25,'Visible','on');
    set(handles.edit9,'Visible','on');
else
    set(handles.radiobutton22,'Value',0);
    set(handles.text24,'Visible','off');
    set(handles.text25,'Visible','off');
    set(handles.edit9,'Visible','off');
end

% Hint: get(hObject,'Value') returns toggle state of radiobutton23



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



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
