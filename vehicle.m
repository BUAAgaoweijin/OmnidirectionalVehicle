function varargout = vehicle(varargin)
% VEHICLE MATLAB code for vehicle.fig
%      VEHICLE, by itself, creates a new VEHICLE or raises the existing
%      singleton*.
%
%      H = VEHICLE returns the handle to a new VEHICLE or the handle to
%      the existing singleton*.
%
%      VEHICLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VEHICLE.M with the given input arguments.
%
%      VEHICLE('Property','Value',...) creates a new VEHICLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before vehicle_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to vehicle_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help vehicle

% Last Modified by GUIDE v2.5 28-Sep-2017 20:02:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @vehicle_OpeningFcn, ...
                   'gui_OutputFcn',  @vehicle_OutputFcn, ...
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


% --- Executes just before vehicle is made visible.
function vehicle_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to vehicle (see VARARGIN)

% Choose default command line output for vehicle
handles.output = hObject;


load_system('OmnidirectionalVehicle');

global desiredx desiredy desiredyaw
desiredx = 0;
desiredy = 0;
desiredyaw = 0;
global xpospipe ypospipe yawpospipe
global desiredxpipe desiredypipe desiredyawpipe
xpospipe = zeros(1,50);
ypospipe = zeros(1,50);
yawpospipe = zeros(1,50);
desiredxpipe = zeros(1,50);
desiredypipe = zeros(1,50);
desiredyawpipe = zeros(1,50);
set_param('OmnidirectionalVehicle/desiredx', 'Value', num2str(desiredx));
set_param('OmnidirectionalVehicle/desiredy', 'Value', num2str(desiredy));
set_param('OmnidirectionalVehicle/desiredyaw', 'Value', num2str(desiredyaw));

set(handles.editx,'String', num2str(desiredx));
set(handles.edity,'String', num2str(desiredy));
set(handles.edityaw,'String', num2str(desiredyaw));
handles.pushbutton1.Enable = 'on';
handles.pushbutton2.Enable = 'off';
handles.pushbutton3.Enable = 'off';

update_rate = 20;
handles.timer = timer('ExecutionMode', 'fixedSpacing', 'Period', round(1000 / update_rate) / 1000, 'TimerFcn', {@update_data, handles});

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes vehicle wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function update_data(hObject, eventdata, handles)
tic;
global xpospipe ypospipe yawpospipe
global desiredxpipe desiredypipe desiredyawpipe
global desiredx desiredy desiredyaw
simulation_data = get_param('OmnidirectionalVehicle/simulation_data', 'RuntimeObject');
xpos = simulation_data.InputPort(1).Data(1);
ypos = simulation_data.InputPort(2).Data(1);
yaw = pi/180*simulation_data.InputPort(3).Data(1);

%»­Í¼º¯Êý
plot(handles.gaoweijin,[xpos xpos+sin(yaw)],[ypos ypos+cos(yaw)] ,'color','r');
x5 = [xpos+sin(yaw-pi/4) xpos+2*sin(yaw) xpos+sin(yaw+pi/4)  xpos+sin(yaw+3*pi/4) xpos+sin(yaw-3*pi/4)];
y5 = [ypos+cos(yaw-pi/4) ypos+2*cos(yaw) ypos+cos(yaw+pi/4)  ypos+cos(yaw+3*pi/4) ypos+cos(yaw-3*pi/4)];
fill(handles.gaoweijin,x5,y5,'r');
handles.gaoweijin.XLim = [-5,5]';
handles.gaoweijin.YLim = [-5,5]';
grid(handles.gaoweijin,'on');

time = 1:1:50;
xpospipe(1:49) = xpospipe(2:50);
ypospipe(1:49) = ypospipe(2:50);
yawpospipe(1:49) = yawpospipe(2:50);
desiredxpipe(1:49) = desiredxpipe(2:50);
desiredypipe(1:49) = desiredypipe(2:50);
desiredyawpipe(1:49) = desiredyawpipe(2:50);

xpospipe(50) = xpos;
ypospipe(50) = ypos;
yawpospipe(50) = yaw*180/pi;

desiredxpipe(50) = desiredx;
desiredypipe(50) = desiredy;
desiredyawpipe(50) = desiredyaw;

plot(handles.axesx,time,xpospipe,'color','r');     %,'color','r'
hold(handles.axesx,'on');
plot(handles.axesx,time,desiredxpipe,'color','g');     %,'color','r'
hold(handles.axesx,'off');

plot(handles.axesy,time,ypospipe,'color','r');     %,'color','r'
hold(handles.axesy,'on');
plot(handles.axesy,time,desiredypipe,'color','g');     %,'color','r'
hold(handles.axesy,'off');

plot(handles.axesyaw,time,yawpospipe,'color','r');     %,'color','r'
hold(handles.axesyaw,'on');
plot(handles.axesyaw,time,desiredyawpipe,'color','g');     %,'color','r'
hold(handles.axesyaw,'off');

uplimx = max(desiredxpipe)+1;
downlimx = min(desiredxpipe)-1;
handles.axesx.YLim = [downlimx,uplimx]';
grid(handles.axesx,'on');

uplimy = max(desiredypipe)+1;
downlimy = min(desiredypipe)-1;
handles.axesy.YLim = [downlimy,uplimy]';
grid(handles.axesy,'on');

uplimyaw = max(desiredyawpipe)+10;
downlimyaw = min(desiredyawpipe)-10;
handles.axesyaw.YLim = [downlimyaw,uplimyaw]';
grid(handles.axesyaw,'on');

cycles = 1 / toc;
set(handles.gaoweijintext,'String', ['[' num2str(round(cycles)) ' fps]']);



% --- Outputs from this function are returned to the command line.
function varargout = vehicle_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global desiredx desiredy desiredyaw
desiredx = 0;
desiredy = 0;
desiredyaw = 0;

set_param('OmnidirectionalVehicle/desiredx', 'Value', num2str(desiredx));
set_param('OmnidirectionalVehicle/desiredy', 'Value', num2str(desiredy));
set_param('OmnidirectionalVehicle/desiredyaw', 'Value', num2str(desiredyaw));

set(handles.editx,'String', num2str(desiredx));
set(handles.edity,'String', num2str(desiredy));
set(handles.edityaw,'String', num2str(desiredyaw));

set_param('OmnidirectionalVehicle','SimulationCommand','Start');
pause(1);
start(handles.timer);
handles.pushbutton1.Enable = 'off';
handles.pushbutton2.Enable = 'on';
handles.pushbutton3.Enable = 'on';


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stop(handles.timer);
pause(1);
set_param('OmnidirectionalVehicle','SimulationCommand','Stop');


handles.pushbutton1.Enable = 'on';
handles.pushbutton2.Enable = 'off';
handles.pushbutton3.Enable = 'off';

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(handles.pushbutton3.String,'pause')
    stop(handles.timer);
    set_param('OmnidirectionalVehicle','SimulationCommand','Pause');
    handles.pushbutton3.String = 'continue';
else
    
    set_param('OmnidirectionalVehicle','SimulationCommand','Continue');
    start(handles.timer);
    handles.pushbutton3.String = 'pause';
end


function editx_Callback(hObject, eventdata, handles)
% hObject    handle to editx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editx as text
%        str2double(get(hObject,'String')) returns contents of editx as a double
global desiredx
desiredx = str2double(get(hObject,'String'));
set_param('OmnidirectionalVehicle/desiredx', 'Value', num2str(desiredx));


% --- Executes during object creation, after setting all properties.
function editx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edity_Callback(hObject, eventdata, handles)
% hObject    handle to edity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edity as text
%        str2double(get(hObject,'String')) returns contents of edity as a double
global desiredy
desiredy = str2double(get(hObject,'String'));
set_param('OmnidirectionalVehicle/desiredy', 'Value', num2str(desiredy));


% --- Executes during object creation, after setting all properties.
function edity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edityaw_Callback(hObject, eventdata, handles)
% hObject    handle to edityaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edityaw as text
%        str2double(get(hObject,'String')) returns contents of edityaw as a double
global desiredyaw
desiredyaw = str2double(get(hObject,'String'));
set_param('OmnidirectionalVehicle/desiredyaw', 'Value', num2str(desiredyaw));


% --- Executes during object creation, after setting all properties.
function edityaw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edityaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
