function varargout = kiedy_zjadlooo(varargin)
% KIEDY_ZJADLOOO MATLAB code for kiedy_zjadlooo.fig
%      KIEDY_ZJADLOOO, by itself, creates a new KIEDY_ZJADLOOO or raises the existing
%      singleton*.
%
%      H = KIEDY_ZJADLOOO returns the handle to a new KIEDY_ZJADLOOO or the handle to
%      the existing singleton*.
%
%      KIEDY_ZJADLOOO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KIEDY_ZJADLOOO.M with the given input arguments.
%
%      KIEDY_ZJADLOOO('Property','Value',...) creates a new KIEDY_ZJADLOOO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before kiedy_zjadlooo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to kiedy_zjadlooo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help kiedy_zjadlooo

% Last Modified by GUIDE v2.5 30-Nov-2019 02:56:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @kiedy_zjadlooo_OpeningFcn, ...
                   'gui_OutputFcn',  @kiedy_zjadlooo_OutputFcn, ...
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

% --- Executes just before kiedy_zjadlooo is made visible.
function kiedy_zjadlooo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to kiedy_zjadlooo (see VARARGIN)

% Choose default command line output for kiedy_zjadlooo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using kiedy_zjadlooo.
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(5));

end

% UIWAIT makes kiedy_zjadlooo wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = kiedy_zjadlooo_OutputFcn(hObject, eventdata, handles)
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
axes(handles.axes1);
cla;

hiper = get(handles.edit2, 'String');
hipo = get(handles.edit3, 'String');
col = get(handles.edit1, 'String');
hiper = str2num(hiper);
hipo = str2num(hipo);
col = str2num(col);
% Załadowanie danych 
load('only.mat');

% % pola do modyfikacji, "progi" detekcji oraz wybór rekordu
% hiper = 0.5;  % if V > hiper them...
% hipo = -0.95; % if V < hipo them...
% col = 3;% 16 kolumn, 1 kolumna to 1 rekord



s = only.interpolated_seconds(:, col);
t = only.interpolated_datatime(:, col);
g = only.interpolated_data(:, col);
%
index = length(t(~isnat(t))); % indeksy dla tego co chcemy.

s = s(1:index);
t = t(1:index);
g = g(1:index);

% strukturę only można uzyskać uruchamiając skrypt Zestaw_Danych.m ||| 


load('Activity_for_plot.mat'); 
% dane załadowane ręcznie podobnie jak librelink.csv, nie wymagały obróbki.


% Plot posiłków i okresów snu oraz treningu.

%funkcje anonimowe łatek dla snu i treningu
spanko = @(x, y) fill(x, y, [.1 .1 .6], 'FaceAlpha', .21, 'EdgeColor', 'none');
trening = @(x, y) fill(x, y, [.9 .3 .1], 'FaceAlpha', .21, 'EdgeColor', 'none');

%figure('Name', 'Activity and Glucose');
% rysowanie snu i treningu
for i = 1:length(A.sleep)
    spanko([(A.sleep{i, 1}(1)),(A.sleep{i, 1}(2)),(A.sleep{i, 1}(2)),(A.sleep{i, 1}(1))],...
    [0,0,200,200]);
hold all
end
for i = 1:length(A.exercise_time)
    trening([(A.exercise_time{i, 1}(1)),(A.exercise_time{i, 1}(2)),(A.exercise_time{i, 1}(2)),(A.exercise_time{i, 1}(1))],...
    [0,0,200,200]);
hold all
end
% rysowanie glukozy
plot(t, g, 'c.-'); hold all; grid minor; grid on;
%  rysowanie jedzenia
food_value = 1:length(A.food_time); food_value(1:end) = 80;
h = text((A.food_time), food_value, A.food);
plot(A.food_time, food_value - 5, 'gs',...
    'MarkerSize',10,...
    'MarkerEdgeColor','m',...
    'MarkerFaceColor',[0.5,0.5,0.5]);
set(h,'Rotation',90);

ylabel('Historic Glucose [mg/dL]');

xlim([t(1) t(end)]);

%clear A food_value index t g only h

% Wykrywanie posiłków

%figure('Name', 'Detekcja Posiłku');

% Określenie działki dni, w pętli będzie to powtarzane.
min_max = minmax(g');% wysokość działki (to linia pionowa na wykresie)
dateforday = t(1);% data dla pierwszej działki
day = dateforday.Day;% dzień, kótry potem sprawdzamy, jeśli się zmieni to znak, by kreślić kolejną działkę
dateforday.Hour = 0; dateforday.Minute = 0; % ustawiamy działkę na 00:00
plot([dateforday dateforday], [min_max(1)-5 min_max(2)+5], '-.', 'color', [.5 .1 .7]);% rysowanie
hold on; % pozostajemy na tym samym wykresie cały czas

% Filtr 
%med = medfilt1(g, 3*2);
%med = movmean(g, 3*1);
med=g;
med(1)= g(1); % dla 1 próbki filtr robi głupie "przeregulowanie", w ten sposób je usuwamy.

% Odległość czekania dla kolejnego odkrycia posiłku
N = 4;% 1 próbka to 5 minut, ale oryginał to 15 minut około więc przynajmniej N*3 np.: N=2 to czekanie 30min
czekanie = N*3; 
czekaj = czekanie; % licznik, dla wartości większej/równej 'czekanie' pozwala odnotować posiłek
% po wykryciu posiłku ustawia czekaj=0 i znów liczy próbki odpowiadające za N*15minut

plot(t, med, '--', 'color', [.1 .3 .7]); grid on;
hold on; % to był cały wykres
plot([t(1) t(end)], [140 140], 'r-.');
hold on; % to była działka 140 mg/dL
plot([t(1) t(end)], [45 45], 'g-.');
hold on; % to była działka 45 mg/dL
for i = 2:length(med)
    % Określenie prędkości przyrostu
    delta = s(i) - s(i - 1);
    V = med(i) - med(i - 1);
    V = (V * 60) / delta; % to aktualna prędkość zmian
    
    czekaj = czekaj + 1; % liczenie, +1 czyli +5 minut, istotne po wykryciu posiłku.
    if V > hiper % Oznaczanie posiłków [mg/dL na minutę]
        if czekaj >= czekanie % upłynęło dość czasu od ostatniego wykrycia?
            plot(t(i), med(i), 'or'); % rysuj posiłek
            hold on;
            czekaj = 0; % start czekania
        end
    end
    if V < hipo % Oznaczanie spadków
        plot(t(i), med(i), '<g');
        hold on;
    end
    
    % Oddzielenie na wykresie dni o porach [00:00 (day i-1)]=> [00:00 (day i)]
    if day ~= t(i).Day % jeśli zapamiętany dzień różni się od dnia aktualnej próbki to...
        day = t(i).Day; % ustaw nowy dzień
        dateforday = t(1); % stwórz jakąś datę.
        dateforday.Day = day; % ustaw wymagany dzień dla działki
        dateforday.Hour = 0; % godzinę 
        dateforday.Month = t(i).Month; % upewnij się że miesiąc się zgadza (są rekordy z pograniczy 2 miesięcy)
        dateforday.Minute = 0; % Takie postępowanie zakłada posługiwanie się datami w obrębie 1 roku
        % W przeciwnym razie należałoby wykrywać zmianę roku. Zakładamy ciągłość danych względem dni.
        plot([dateforday dateforday], [min_max(1)-5 min_max(2)+5], '-.', 'color', [.5 .1 .7]);
        hold on; 
    end
end


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


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
handles.limit_of_x=get(gca, 'XLim');
handles.limit_of_y=get(gca, 'YLim');

guidata(hObject,handles)

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
set(handles.axes1,'XLim',handles.limit_of_x,'YLim',handles.limit_of_y);
